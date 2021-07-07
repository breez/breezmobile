import 'dart:convert';

import 'package:breez/bloc/backup/backup_actions.dart';
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
import 'package:webdav_client/webdav_client.dart' as webdav;
import 'package:path/path.dart' as p;
import '../backup_in_progress_dialog.dart';

Future<NextCloudAuthData> promptAuthData(BuildContext context,
    {restore = false}) {
  return Navigator.of(context).push<NextCloudAuthData>(FadeInRoute(
    builder: (BuildContext context) {
      final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
      return withBreezTheme(
        context,
        NextCloudAuthPage(backupBloc, restore),
      );
    },
  ));
}

const String BREEZ_BACKUP_DIR = "DO_NOT_DELETE_Breez_Backup";

class NextCloudAuthPage extends StatefulWidget {
  NextCloudAuthPage(this._backupBloc, this.restore);

  final String _title = "Remote Server";
  final BackupBloc _backupBloc;
  final bool restore;

  @override
  State<StatefulWidget> createState() {
    return NextCloudAuthPageState();
  }
}

class NextCloudAuthPageState extends State<NextCloudAuthPage> {
  final _formKey = GlobalKey<FormState>();
  var _urlController = TextEditingController();
  var _userController = TextEditingController();
  var _passwordController = TextEditingController();
  bool failDiscoverURL = false;
  bool failAuthenticate = false;

  @override
  void initState() {
    super.initState();
    widget._backupBloc.backupSettingsStream.first.then((value) {
      var nextCloudData = value.nextCloudAuthData;
      if (nextCloudData != null) {
        _urlController.text = nextCloudData.url;
        _userController.text = nextCloudData.user;
        _passwordController.text = nextCloudData.password;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BackupSettings>(
        stream: widget._backupBloc.backupSettingsStream,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                leading: backBtn.BackButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
                automaticallyImplyLeading: false,
                iconTheme: Theme.of(context).appBarTheme.iconTheme,
                textTheme: Theme.of(context).appBarTheme.textTheme,
                backgroundColor: Theme.of(context).canvasColor,
                title: Text(
                  widget._title,
                  style: Theme.of(context).appBarTheme.textTheme.headline6,
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
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  controller: _urlController,
                                  minLines: 1,
                                  maxLines: 1,
                                  validator: (value) {
                                    var urlPattern =
                                        r"(https)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
                                    var match = new RegExp(urlPattern,
                                            caseSensitive: false)
                                        .firstMatch(value);
                                    if (!failDiscoverURL &&
                                        match != null &&
                                        match.start == 0 &&
                                        match.end == value.length) {
                                      return null;
                                    }
                                    if (!value.startsWith("https://")) {
                                      return "Must start with https";
                                    }
                                    return "Invalid URL";
                                  },
                                  decoration: InputDecoration(
                                      hintText:
                                          "https://example.nextcloud.com'",
                                      labelText:
                                          "Server Address (Nextcloud, WebDav)"),
                                  onEditingComplete: () =>
                                      FocusScope.of(context).nextFocus(),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (failAuthenticate) {
                                      return "Wrong username";
                                    }
                                    return null;
                                  },
                                  controller: _userController,
                                  minLines: 1,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      hintText: "Username",
                                      labelText: "User Name"),
                                  onEditingComplete: () =>
                                      FocusScope.of(context).nextFocus(),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (failAuthenticate) {
                                      return "Wrong password";
                                    }
                                    return null;
                                  },
                                  controller: _passwordController,
                                  minLines: 1,
                                  maxLines: 1,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      labelText: "Password"),
                                  onEditingComplete: () =>
                                      FocusScope.of(context).nextFocus(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(bottom: 0.0),
                child: SingleButtonBottomBar(
                  stickToBottom: true,
                  text: widget.restore ? "RESTORE" : "SAVE",
                  onPressed: () async {
                    var nav = Navigator.of(context);
                    failDiscoverURL = false;
                    failAuthenticate = false;
                    if (_formKey.currentState.validate()) {
                      var newSettings = snapshot.data.copyWith(
                          nextCloudAuthData: NextCloudAuthData(
                              _urlController.text,
                              _userController.text,
                              _passwordController.text,
                              BREEZ_BACKUP_DIR));
                      var loader = createLoaderRoute(context,
                          message: "Testing connection", opacity: 0.8);
                      Navigator.push(context, loader);
                      discoverURL(newSettings.nextCloudAuthData)
                          .then((value) async {
                        nav.removeRoute(loader);
                        if (value.authError == DiscoverResult.SUCCESS) {
                          Navigator.pop(context, value.authData);
                        }
                        setState(() {
                          failDiscoverURL =
                              value.authError == DiscoverResult.INVALID_URL;
                          failAuthenticate =
                              value.authError == DiscoverResult.INVALID_AUTH;
                        });
                        _formKey.currentState.validate();
                      }).catchError((err) {
                        nav.removeRoute(loader);
                        promptError(
                            context,
                            "Remote Server",
                            Text(
                                "Failed to connect with the remote server, please check your settings."));
                      });
                    }
                  },
                ),
              ));
        });
  }

  Future testConnection(NextCloudAuthData authData) async {
    var client = webdav.newClient(
      authData.url,
      user: authData.user,
      password: authData.password,
      debug: true,
    );
    await client.ping();
  }

  Future<DiscoveryResult> discoverURL(NextCloudAuthData authData) async {
    var result = await testAuthData(authData);
    if (result == DiscoverResult.SUCCESS ||
        result == DiscoverResult.INVALID_AUTH) {
      return DiscoveryResult(authData, result);
    }

    var url = authData.url;
    if (!url.endsWith("/")) {
      url = url + "/";
    }
    var nextCloudURL = url + "remote.php/webdav";
    result = await testAuthData(authData.copyWith(url: nextCloudURL));
    if (result == DiscoverResult.SUCCESS ||
        result == DiscoverResult.INVALID_AUTH) {
      return DiscoveryResult(authData.copyWith(url: nextCloudURL), result);
    }
    return DiscoveryResult(authData, result);
  }

  Future<DiscoverResult> testAuthData(NextCloudAuthData authData) async {
    try {
      var client = webdav.newClient(
        authData.url,
        user: authData.user,
        password: authData.password,
        debug: true,
      );
      await client.ping();
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

enum DiscoverResult { SUCCESS, INVALID_URL, INVALID_AUTH }

class DiscoveryResult {
  final NextCloudAuthData authData;
  final DiscoverResult authError;

  DiscoveryResult(this.authData, this.authError);
}
