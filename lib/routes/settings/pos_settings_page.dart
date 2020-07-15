import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/settings/set_admin_password.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

class PosSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    return StreamBuilder<BreezUserModel>(
        stream: _userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _PosSettingsPage(_userProfileBloc, snapshot.data);
          }

          return StaticLoader();
        });
  }
}

class _PosSettingsPage extends StatefulWidget {
  _PosSettingsPage(this._userProfileBloc, this.currentProfile);

  final String _title = "POS Settings";
  final UserProfileBloc _userProfileBloc;
  final BreezUserModel currentProfile;

  @override
  State<StatefulWidget> createState() {
    return PosSettingsPageState();
  }
}

class PosSettingsPageState extends State<_PosSettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _cancellationTimeoutValueController = TextEditingController();
  AutoSizeGroup _autoSizeGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();
    _cancellationTimeoutValueController.text =
        widget.currentProfile.cancellationTimeoutValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    UserProfileBloc userProfileBloc =
        AppBlocsProvider.of<UserProfileBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: backBtn.BackButton(),
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
      body: StreamBuilder<BreezUserModel>(
          stream: userProfileBloc.userStream,
          builder: (context, snapshot) {
            var user = snapshot.data;
            if (user == null) {
              return Loader();
            }
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(top: 32.0, bottom: 19.0, left: 16.0),
                    child: Text(
                      "Payment Cancellation Timeout (in seconds)",
                      style: TextStyle(
                          fontSize: 12.4,
                          letterSpacing: 0.11,
                          height: 1.24,
                          color: Color.fromRGBO(255, 255, 255, 0.87)),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 304.0,
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: Slider(
                                value: widget
                                    .currentProfile.cancellationTimeoutValue,
                                label:
                                    '${widget.currentProfile.cancellationTimeoutValue.toStringAsFixed(0)}',
                                min: 30.0,
                                max: 180.0,
                                divisions: 5,
                                onChanged: (double value) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _cancellationTimeoutValueController.text =
                                      value.toString();
                                  widget._userProfileBloc.userSink.add(
                                      widget.currentProfile.copyWith(
                                          cancellationTimeoutValue: value));
                                }),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8.0, right: 16.0),
                          child: Text(
                            num.parse(_cancellationTimeoutValueController.text)
                                .toStringAsFixed(0),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.4,
                                letterSpacing: 0.11),
                          ),
                        ),
                      ]),
                  ..._buildAdminPasswordTiles(userProfileBloc, user),
                  Divider(),
                  _buildExportItemsTile()
                ],
              ),
            );
          }),
    );
  }

  List<Widget> _buildAdminPasswordTiles(
      UserProfileBloc userProfileBloc, BreezUserModel user) {
    var widgets = <Widget>[
      Divider(),
      _buildEnablePasswordTile(userProfileBloc, user)
    ];
    if (user.hasAdminPassword) {
      widgets..add(Divider())..add(_buildSetPasswordTile());
    }
    return widgets;
  }

  Widget _buildExportItemsTile() {
    return ListTile(
      title: Container(
        child: AutoSizeText(
          "Items List",
          style: TextStyle(color: Colors.white),
          maxLines: 1,
          minFontSize: MinFontSize(context).minFontSize,
          stepGranularity: 0.1,
          group: _autoSizeGroup,
        ),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: PopupMenuButton(
          color: Theme.of(context).backgroundColor,
          icon: Icon(
            Icons.more_horiz,
            color: Theme.of(context).iconTheme.color,
          ),
          padding: EdgeInsets.zero,
          offset: Offset(12, 36),
          onSelected: _select,
          itemBuilder: (context) => [
            PopupMenuItem(
              height: 36,
              value: Choice(() => _importPayments(context)),
              child: Text('Import from CSV',
                  style: Theme.of(context).textTheme.button),
            ),
            PopupMenuItem(
              height: 36,
              value: Choice(() => _exportPayments(context)),
              child: Text('Export to CSV',
                  style: Theme.of(context).textTheme.button),
            ),
          ],
        ),
      ),
      onTap: () => _onChangeAdminPasswordSelected(),
    );
  }

  void _select(Choice choice) {
    choice.function();
  }

  Future _importPayments(BuildContext context) async {
    return promptAreYouSure(
            context,
            "Import items",
            Text(
                "Importing this list will override the existing one. Are you sure you want to continue?",
                style: Theme.of(context).dialogTheme.contentTextStyle),
            contentPadding: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
            cancelText: "NO",
            okText: "YES")
        .then((acknowledged) {
      if (acknowledged) {
        showFlushbar(context, message: "Not implemented");
      }
    });
  }

  Future _exportPayments(BuildContext context) async {
    PosCatalogBloc posCatalogBloc =
        AppBlocsProvider.of<PosCatalogBloc>(context);
    var action = ExportItems();
    posCatalogBloc.actionsSink.add(action);
    Navigator.of(context).push(createLoaderRoute(context));
    action.future.then((filePath) {
      Navigator.of(context).pop();
      ShareExtend.share(filePath, "file");
    }).catchError((err) {
      Navigator.of(context).pop();
      showFlushbar(context, message: "Failed to export pos items.");
    });
  }

  ListTile _buildSetPasswordTile() {
    return ListTile(
      title: Container(
        child: AutoSizeText(
          "Change Manager Password",
          style: TextStyle(color: Colors.white),
          maxLines: 1,
          minFontSize: MinFontSize(context).minFontSize,
          stepGranularity: 0.1,
          group: _autoSizeGroup,
        ),
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () => _onChangeAdminPasswordSelected(),
    );
  }

  ListTile _buildEnablePasswordTile(
      UserProfileBloc userProfileBloc, BreezUserModel user) {
    return ListTile(
      title: AutoSizeText(
        user.hasAdminPassword
            ? "Activate Manager Password"
            : "Create Manager Password",
        style: TextStyle(color: Colors.white),
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
        group: user.hasAdminPassword ? _autoSizeGroup : null,
      ),
      trailing: user.hasAdminPassword
          ? Switch(
              value: user.hasAdminPassword,
              activeColor: Colors.white,
              onChanged: (bool value) {
                if (this.mounted) {
                  _resetAdminPassword(userProfileBloc);
                }
              },
            )
          : Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.keyboard_arrow_right,
                  color: Colors.white, size: 30.0),
            ),
      onTap: user.hasAdminPassword
          ? null
          : () => _onChangeAdminPasswordSelected(isNew: !user.hasAdminPassword),
    );
  }

  _onChangeAdminPasswordSelected({bool isNew = false}) async {
    BackupBloc backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    var backupState = await backupBloc.backupStateStream.first;
    if (backupState.lastBackupTime == null) {
      await promptError(
          context,
          "Manager Password",
          Text(
              "Manager Password can be configured only if you have an active backup. To trigger a backup process, go to Receive > Receive via BTC Address."));
      return;
    }

    bool confirmed = true;
    if (isNew) {
      confirmed = await promptAreYouSure(
          context,
          "Manager Password",
          Text(
              "If Manager Password is activated, sending funds from Breez will require you to enter a password.\nAre you sure you want to activate Manager Password?"));
    }
    if (confirmed) {
      Navigator.of(context).push(FadeInRoute(
        builder: (_) => SetAdminPasswordPage(
            submitAction: isNew ? "CREATE" : "CHANGE"),
      ));
    }
  }

  _resetAdminPassword(UserProfileBloc userProfileBloc) {
    SetAdminPassword action = SetAdminPassword(null);
    userProfileBloc.userActionsSink.add(action);
  }
}

class Choice {
  const Choice(this.function);

  final Function function;
}
