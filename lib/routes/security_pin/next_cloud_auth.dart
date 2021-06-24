import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

Future<NextCloudAuthData> promptAuthData(BuildContext context) {
  return Navigator.of(context).push<NextCloudAuthData>(FadeInRoute(
    builder: (BuildContext context) {
      final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
      return withBreezTheme(
        context,
        NextCloudAuthPage(backupBloc),
      );
    },
  ));
}

class NextCloudAuthPage extends StatefulWidget {
  NextCloudAuthPage(this._backupBloc);

  final String _title = "Next Cloud Settings";
  final BackupBloc _backupBloc;

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
  var _backupDirController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget._backupBloc.backupSettingsStream.first.then((value) {
      var nextCloudData = value.nextCloudAuthData;
      if (nextCloudData != null) {
        _urlController.text = nextCloudData.url;
        _userController.text = nextCloudData.user;
        _passwordController.text = nextCloudData.password;
        _backupDirController.text = nextCloudData.breezDir;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backBtn.BackButton(
          onPressed: () {
            Navigator.pop(
                context,
                NextCloudAuthData(_urlController.text, _userController.text,
                    _passwordController.text, _backupDirController.text));
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
                        TextField(
                          controller: _urlController,
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: "https://nextcloud.example.cloud/",
                              labelText: "Server URL"),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        TextField(
                          controller: _userController,
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: "User Name", labelText: "User Name"),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        TextField(
                          controller: _passwordController,
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: "Password", labelText: "Password"),
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                        ),
                        TextField(
                          controller: _backupDirController,
                          minLines: 1,
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: "breez", labelText: "Backup Directory"),
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
    );
  }
}
