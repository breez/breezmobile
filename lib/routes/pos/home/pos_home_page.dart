import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/shared/account_required_actions.dart';
import 'package:breez/routes/user/sync_ui_handler.dart';

import 'pos_invoice.dart';
import 'package:flutter/material.dart';
import 'package:breez/widgets/navigation_drawer.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/routes/shared/no_connection_dialog.dart';
import 'package:breez/bloc/account/account_bloc.dart';

class PosHome extends StatefulWidget {
  final AccountBloc accountBloc;
  final BackupBloc backupBloc;
  final UserProfileBloc userBlock;

  PosHome(this.accountBloc, this.backupBloc, this.userBlock);

  final List<DrawerItemConfig> _screens =
      new List<DrawerItemConfig>.unmodifiable([]);

  final List<DrawerItemConfig> _majorActions =
      new List<DrawerItemConfig>.unmodifiable([
    new DrawerItemConfig(
        "/transactions", "Transactions", "src/icon/transactions.png"),
    new DrawerItemConfig(
        "/withdraw_funds", "Remove Funds", "src/icon/withdraw_funds.png"),
    new DrawerItemConfig("/settings", "Settings", "src/icon/settings.png")
  ]);

  final List<DrawerItemConfig> _minorActions =
      new List<DrawerItemConfig>.unmodifiable([
    new DrawerItemConfig(
        "/network", "Network", "src/icon/network.png"),
    new DrawerItemConfig(
        "/developers", "Developers", "src/icon/developers.png"),
  ]);

  @override
  State<StatefulWidget> createState() {
    return new PosHomeState();
  }
}

class PosHomeState extends State<PosHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    new SyncUIHandler(widget.accountBloc, context);
    listenNoConnection(context, widget.accountBloc);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: AccountRequiredActionsIndicator(
                  widget.backupBloc, widget.accountBloc, widget.userBlock),
            ),
          ],
          leading: new IconButton(
              icon: ImageIcon(
                AssetImage("src/icon/hamburger.png"),
                size: 24.0,
                color: null,
              ),
              onPressed: () => _scaffoldKey.currentState.openDrawer()),
          title: new Image.asset(
            "src/images/logo-color.png",
            height: 23.5,
            width: 62.7,
          ),
          iconTheme: new IconThemeData(color: Color.fromARGB(255, 0, 133, 251)),
          backgroundColor: theme.whiteColor,
          elevation: 0.0,
        ),
        drawer: new NavigationDrawer(
            false,
            [
              DrawerItemConfigGroup(widget._majorActions),
              DrawerItemConfigGroup(widget._minorActions),
            ],
            _onNavigationItemSelected),
        body: new Builder(builder: (BuildContext context) {
          return POSInvoice();
        }));
  }

  _onNavigationItemSelected(String itemName) {
    Navigator.of(this.context).pushNamed(itemName);
  }
}
