import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:validators/validators.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

Future<RemoteServerAuthData> promptAuthData(
  BuildContext context, {
  restore = false,
}) {
  return Navigator.of(context).push<RemoteServerAuthData>(FadeInRoute(
    builder: (BuildContext context) {
      final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
      return withBreezTheme(
        context,
        RemoteServerAuthPage(backupBloc, restore),
      );
    },
  ));
}

const String BREEZ_BACKUP_DIR = "DO_NOT_DELETE_Breez_Backup";

class RemoteServerAuthPage extends StatefulWidget {
  final BackupBloc _backupBloc;
  final bool restore;

  const RemoteServerAuthPage(
    this._backupBloc,
    this.restore,
  );

  @override
  State<StatefulWidget> createState() {
    return RemoteServerAuthPageState();
  }
}

class RemoteServerAuthPageState extends State<RemoteServerAuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  bool failDiscoverURL = false;
  bool failAuthenticate = false;
  bool _passwordObscured = true;

  @override
  void initState() {
    super.initState();
    widget._backupBloc.backupSettingsStream.first.then((value) {
      var data = value.remoteServerAuthData;
      if (data != null) {
        _urlController.text = data.url;
        _userController.text = data.user;
        _passwordController.text = data.password;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final nav = Navigator.of(context);

    return StreamBuilder<BackupSettings>(
      stream: widget._backupBloc.backupSettingsStream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            leading: backBtn.BackButton(
              onPressed: () {
                nav.pop(null);
              },
            ),
            automaticallyImplyLeading: false,
            iconTheme: themeData.appBarTheme.iconTheme,
            textTheme: themeData.appBarTheme.textTheme,
            backgroundColor: themeData.canvasColor,
            title: Text(
              texts.remote_server_title,
              style: themeData.appBarTheme.textTheme.headline6,
            ),
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            reverse: true,
            child: StreamBuilder<BackupSettings>(
              stream: widget._backupBloc.backupSettingsStream,
              builder: (context, snapshot) {
                var settings = snapshot.data;
                if (settings == null) {
                  return Loader();
                }
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _formFieldUrl(context),
                          _formFieldUserName(context),
                          _formFieldPassword(context),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(bottom: 0.0),
            child: SingleButtonBottomBar(
              stickToBottom: true,
              text: widget.restore
                  ? texts.remote_server_action_restore
                  : texts.remote_server_action_save,
              onPressed: () async {
                Uri uri = Uri.parse(_urlController.text);
                var connectionWarningResponse = true;
                if (uri.scheme != 'https') {
                  connectionWarningResponse = await promptAreYouSure(
                    context,
                    texts.remote_server_warning_connection_title,
                    Text(
                      texts.remote_server_warning_connection_message,
                    ),
                  );
                }

                if (connectionWarningResponse) {
                  failDiscoverURL = false;
                  failAuthenticate = false;
                  if (_formKey.currentState.validate()) {
                    final newSettings = snapshot.data.copyWith(
                      remoteServerAuthData: RemoteServerAuthData(
                        _urlController.text,
                        _userController.text,
                        _passwordController.text,
                        BREEZ_BACKUP_DIR,
                      ),
                    );
                    final loader = createLoaderRoute(
                      context,
                      message: texts.remote_server_testing_connection,
                      opacity: 0.8,
                    );
                    Navigator.push(context, loader);
                    discoverURL(newSettings.remoteServerAuthData)
                        .then((value) async {
                      nav.removeRoute(loader);
                      final error = value.authError;
                      if (error == DiscoverResult.SUCCESS) {
                        Navigator.pop(context, value.authData);
                      }
                      setState(() {
                        failDiscoverURL = error == DiscoverResult.INVALID_URL;
                        failAuthenticate = error == DiscoverResult.INVALID_AUTH;
                      });
                      _formKey.currentState.validate();
                    }).catchError((err) {
                      nav.removeRoute(loader);
                      promptError(
                        context,
                        texts.remote_server_error_remote_server_title,
                        Text(
                          texts.remote_server_error_remote_server_message,
                        ),
                      );
                    });
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _formFieldUrl(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return TextFormField(
      controller: _urlController,
      minLines: 1,
      maxLines: 1,
      validator: (value) {
        final validURL = isURL(
          value,
          protocols: ['https', 'http'],
          requireProtocol: true,
          allowUnderscore: true,
        );
        if (!failDiscoverURL && validURL) {
          return null;
        }
        return texts.remote_server_error_invalid_url;
      },
      decoration: InputDecoration(
        hintText: texts.remote_server_server_url_hint,
        labelText: texts.remote_server_server_url_label,
      ),
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }

  Widget _formFieldUserName(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return TextFormField(
      validator: (value) {
        if (failAuthenticate) {
          return texts.remote_server_error_invalid_username_or_password;
        }
        return null;
      },
      controller: _userController,
      minLines: 1,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: texts.remote_server_server_username_hint,
        labelText: texts.remote_server_server_username_label,
      ),
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }

  Widget _formFieldPassword(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return TextFormField(
      validator: (value) {
        if (failAuthenticate) {
          return texts.remote_server_error_invalid_username_or_password;
        }
        return null;
      },
      controller: _passwordController,
      minLines: 1,
      maxLines: 1,
      obscureText: _passwordObscured,
      decoration: InputDecoration(
        hintText: texts.remote_server_server_password_hint,
        labelText: texts.remote_server_server_password_label,
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          onPressed: () {
            setState(() {
              _passwordObscured = !_passwordObscured;
            });
          },
        ),
      ),
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }

  Future testConnection(RemoteServerAuthData authData) async {
    var client = webdav.newClient(
      authData.url,
      user: authData.user,
      password: authData.password,
      debug: true,
    );
    await client.ping();
  }

  Future<DiscoveryResult> discoverURL(RemoteServerAuthData authData) async {
    var result = await testAuthData(authData);
    if (result == DiscoverResult.SUCCESS ||
        result == DiscoverResult.INVALID_AUTH) {
      return DiscoveryResult(authData, result);
    }

    var url = authData.url;
    if (!url.endsWith("/")) {
      url = url + "/";
    }
    final nextCloudURL = url + "remote.php/webdav";
    result = await testAuthData(authData.copyWith(url: nextCloudURL));
    if (result == DiscoverResult.SUCCESS ||
        result == DiscoverResult.INVALID_AUTH) {
      return DiscoveryResult(authData.copyWith(url: nextCloudURL), result);
    }
    return DiscoveryResult(authData, result);
  }

  Future<DiscoverResult> testAuthData(RemoteServerAuthData authData) async {
    try {
      var client = webdav.newClient(
        authData.url,
        user: authData.user,
        password: authData.password,
        debug: true,
      );
      await client.readDir("/");
    } on DioError catch (e) {
      if (e.response != null &&
          (e.response.statusCode == 401 || e.response.statusCode == 403)) {
        return DiscoverResult.INVALID_AUTH;
      }
      return DiscoverResult.INVALID_URL;
    }
    return DiscoverResult.SUCCESS;
  }
}

enum DiscoverResult {
  SUCCESS,
  INVALID_URL,
  INVALID_AUTH,
}

class DiscoveryResult {
  final RemoteServerAuthData authData;
  final DiscoverResult authError;

  const DiscoveryResult(
    this.authData,
    this.authError,
  );
}
