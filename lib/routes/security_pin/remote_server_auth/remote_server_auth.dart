import 'dart:io';

import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/tor/bloc.dart';
import 'package:breez/routes/initial_walkthrough/loaders/loader_indicator.dart';
import 'package:breez/routes/network/network.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/routes/security_pin/remote_server_auth/models/remote_server_models.dart';
import 'package:breez/routes/security_pin/remote_server_auth/widgets/auth_form/remote_server_auth_form.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logging/logging.dart';

final _log = Logger("remote_server_auth.dart");

Future<RemoteServerAuthData> promptAuthData(
  BuildContext context,
  BackupSettings backupSettings, {
  restore = false,
}) {
  return Navigator.of(context).push<RemoteServerAuthData>(
    FadeInRoute(
      builder: (BuildContext context) {
        return withBreezTheme(
          context,
          RemoteServerAuthPage(
            backupSettings: backupSettings,
            isRestoreFlow: restore,
          ),
          isRestoreFlow: restore,
        );
      },
    ),
  );
}

const String BREEZ_BACKUP_DIR = "DO_NOT_DELETE_Breez_Backup";

class RemoteServerAuthPage extends StatefulWidget {
  final BackupSettings backupSettings;
  final bool isRestoreFlow;

  const RemoteServerAuthPage({this.backupSettings, this.isRestoreFlow});

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
  bool failNoBackupFound = false;
  bool failAuthenticate = false;

  ServiceInjector injector = ServiceInjector();

  String appendPath(String uri, List<String> pathSegments) {
    var uriObject = Uri.parse(uri);
    uriObject = uriObject.replace(
      pathSegments: uriObject.pathSegments.toList()..addAll(pathSegments),
    );
    return uriObject.toString();
  }

  @override
  void initState() {
    super.initState();
    _restoreCredentialsFromSettings();
  }

  void _restoreCredentialsFromSettings() {
    var data = widget.backupSettings.remoteServerAuthData;
    if (data != null) {
      var breezDir = data.breezDir;
      if (breezDir != null) {
        var backupDirPathSegments = breezDir.split("/");
        _urlController.text = data.url;
        if (backupDirPathSegments.length > 1) {
          backupDirPathSegments.removeLast();
          _urlController.text = appendPath(data.url, backupDirPathSegments);
        }
      }
      _userController.text = data.user;
      _passwordController.text = data.password;
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const backBtn.BackButton(),
        title: Text(texts.remote_server_title),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: RemoteServerAuthForm(
            formKey: _formKey,
            urlController: _urlController,
            failDiscoverURL: failDiscoverURL,
            failNoBackupFound: failNoBackupFound,
            userController: _userController,
            failAuthenticate: failAuthenticate,
            passwordController: _passwordController,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: SingleButtonBottomBar(
          isRestoreFlow: widget.isRestoreFlow,
          stickToBottom: true,
          text: widget.isRestoreFlow ? texts.remote_server_action_restore : texts.remote_server_action_save,
          onPressed: () async {
            Uri uri = Uri.parse(_urlController.text);
            bool hasError = (await _handleConnectionWarnings(uri) == false);
            if (!hasError) {
              _resetErrors();
              if (_formKey.currentState.validate()) {
                BackupSettings newSettings = _updateBackupSettings(
                  url: uri.toString(),
                );
                EasyLoading.show(
                  indicator: LoaderIndicator(
                    message: texts.remote_server_testing_connection,
                  ),
                );
                await discoverURL(newSettings.remoteServerAuthData).then(
                  (value) async {
                    _handleDiscoveryResult(value);
                    _formKey.currentState.validate();
                  },
                ).catchError((err) => _handleConnectionError());
              }
            }
          },
        ),
      ),
    );
  }

  Future<bool> _handleConnectionWarnings(Uri uri) async {
    final torBloc = AppBlocsProvider.of<TorBloc>(context);

    bool isAndroid = Platform.isAndroid;
    bool resolvedConnectionWarnings = true;
    if (isAndroid && uri.host.endsWith('onion') && torBloc.torConfig == null) {
      resolvedConnectionWarnings = await _handleEnableTor(resolvedConnectionWarnings);
    }
    if ((!uri.host.endsWith('.onion') && uri.scheme == 'http')) {
      resolvedConnectionWarnings = await _handleNonSecureConnection();
    }
    return resolvedConnectionWarnings;
  }

  Future<bool> _handleEnableTor(bool resolvedConnectionWarnings) async {
    final texts = context.texts();
    final themeData = widget.isRestoreFlow ? blueTheme : Theme.of(context);

    await promptError(
      context,
      texts.remote_server_warning_connection_title,
      Text(
        texts.remote_server_warning_onion_message,
        style: themeData.dialogTheme.contentTextStyle,
      ),
      optionText: texts.remote_server_onion_warning_dialog_default_action_cancel,
      optionFunc: () {
        resolvedConnectionWarnings = false;
        Navigator.pop(context);
      },
      okText: texts.remote_server_onion_warning_dialog_settings,
      okFunc: () async {
        resolvedConnectionWarnings = false;
        Navigator.push(
          context,
          FadeInRoute(
            builder: (_) => withBreezTheme(
              context,
              const NetworkPage(),
              isRestoreFlow: widget.isRestoreFlow,
            ),
          ),
        );
        return false;
      },
      isRestoreFlow: widget.isRestoreFlow,
    );

    return resolvedConnectionWarnings;
  }

  Future<bool> _handleNonSecureConnection() async {
    final texts = context.texts();

    return await promptAreYouSure(
      context,
      texts.remote_server_warning_connection_title,
      Text(
        texts.remote_server_warning_connection_message,
      ),
    );
  }

  void _resetErrors() {
    setState(() {
      failDiscoverURL = false;
      failAuthenticate = false;
      failNoBackupFound = false;
    });
  }

  BackupSettings _updateBackupSettings({String url}) {
    final newSettings = widget.backupSettings.copyWith(
      remoteServerAuthData: RemoteServerAuthData(
        url,
        _userController.text,
        _passwordController.text,
        BREEZ_BACKUP_DIR,
      ),
    );
    return newSettings;
  }

  void _handleDiscoveryResult(DiscoveryResult result) {
    EasyLoading.dismiss();

    final error = result.authError;
    if (error == DiscoverResult.SUCCESS) {
      Navigator.pop(context, result.authData);
    }
    setState(() {
      failDiscoverURL = error == DiscoverResult.INVALID_URL;
      failAuthenticate = error == DiscoverResult.INVALID_AUTH;
      failNoBackupFound = error == DiscoverResult.BACKUP_NOT_FOUND;
    });
  }

  void _handleConnectionError() async {
    final texts = context.texts();
    EasyLoading.dismiss();

    await promptError(
      context,
      texts.remote_server_error_remote_server_title,
      Text(
        texts.remote_server_error_remote_server_message,
      ),
      isRestoreFlow: widget.isRestoreFlow,
    );
  }

  // We try to discover the webdav url using a backward search where on every
  // step we take the last path segment from the url and append it as a prefix
  // to the folder path.
  Future<DiscoveryResult> discoverURL(RemoteServerAuthData authData) async {
    RemoteServerAuthData testedAuthData = authData;
    while (true) {
      var testedUrl = Uri.parse(testedAuthData.url);
      var result = await discoverURLInternal(testedAuthData);
      if (result.authError == DiscoverResult.SUCCESS || result.authError == DiscoverResult.INVALID_AUTH) {
        return result;
      }

      List<String> pathSegments = testedUrl.pathSegments.toList();

      // if we reached url origin then we fail.
      if (pathSegments.isEmpty) {
        return DiscoveryResult(testedAuthData, DiscoverResult.INVALID_URL);
      }
      String lastSegment = pathSegments.removeLast();

      // we couldn't use webdav with the current root, try differenet origin
      // and move the last path segment as the directory prefix
      testedAuthData = testedAuthData.copyWith(
          url: testedUrl.replace(pathSegments: pathSegments).toString(),
          breezDir: "$lastSegment/${testedAuthData.breezDir}");

      if (result.authError == DiscoverResult.BACKUP_NOT_FOUND) {
        // ignore: use_build_context_synchronously
        await promptMessage(
          context,
          NoBackupFoundException().toString(),
          // ignore: use_build_context_synchronously
          Text(context.texts().initial_walk_through_error_backup_location),
          isRestoreFlow: widget.isRestoreFlow,
        );
        return result;
      }
    }
  }

  Future<DiscoveryResult> discoverURLInternal(RemoteServerAuthData authData) async {
    // First we try to use the path the user inserted
    var result = await testAuthData(authData);
    if (result == DiscoverResult.SUCCESS || result == DiscoverResult.INVALID_AUTH) {
      return DiscoveryResult(authData, result);
    }

    // Backwards compatibility
    // since the user might accidentally insert a wrong path we'll reconstruct
    // the url to be the short url+remote.php/webdav.
    Uri uri = Uri.parse(authData.url); // + "remote.php/webdav/";
    final nextCloudURL =
        Uri(scheme: uri.scheme, host: uri.host, port: uri.port, path: "remote.php/webdav/").toString();
    if (authData.url == nextCloudURL) {
      return DiscoveryResult(authData, result);
    }
    result = await testAuthData(authData.copyWith(url: nextCloudURL));
    if (result == DiscoverResult.SUCCESS || result == DiscoverResult.INVALID_AUTH) {
      return DiscoveryResult(authData.copyWith(url: nextCloudURL), result);
    }
    return DiscoveryResult(authData, result);
  }

  Future<DiscoverResult> testAuthData(RemoteServerAuthData authData) async {
    _log.info('remote_server_auth.dart: testAuthData');
    try {
      final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
      await backupBloc.testAuth(BackupProvider.remoteServer(), authData);
    } on SignInFailedException catch (e) {
      _log.warning('remote_server_auth.dart: testAuthData: $e');
      return DiscoverResult.INVALID_AUTH;
    } on RemoteServerNotFoundException {
      return DiscoverResult.INVALID_URL;
    } on MethodNotFoundException {
      return DiscoverResult.METHOD_NOT_FOUND;
    }
    return DiscoverResult.SUCCESS;
  }
}
