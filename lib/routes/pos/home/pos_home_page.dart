import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
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
  final LSPBloc lspBloc;

  PosHome(this.accountBloc, this.backupBloc, this.userBlock, this.lspBloc);

  final List<DrawerItemConfig> _screens =
      List<DrawerItemConfig>.unmodifiable([]);

  final List<DrawerItemConfig> _majorActions =
      List<DrawerItemConfig>.unmodifiable([
    DrawerItemConfig(
        "/transactions", "Transactions", "src/icon/transactions.png"),
    DrawerItemConfig(
        "/withdraw_funds", "Remove Funds", "src/icon/withdraw_funds.png"),
    DrawerItemConfig("/settings", "Settings", "src/icon/settings.png")
  ]);

  final List<DrawerItemConfig> _minorActions =
      List<DrawerItemConfig>.unmodifiable([
    DrawerItemConfig("/network", "Network", "src/icon/network.png"),
    DrawerItemConfig("/developers", "Developers", "src/icon/developers.png"),
  ]);

  @override
  State<StatefulWidget> createState() {
    return PosHomeState();
  }
}

class PosHomeState extends State<PosHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SyncUIHandler(widget.accountBloc, context);
    listenNoConnection(context, widget.accountBloc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          brightness: theme.themeId == "BLUE"
              ? Brightness.light
              : Theme.of(context).appBarTheme.brightness,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: AccountRequiredActionsIndicator(widget.backupBloc,
                  widget.accountBloc, widget.userBlock, widget.lspBloc),
            ),
          ],
          leading: IconButton(
              icon: ImageIcon(
                AssetImage("src/icon/hamburger.png"),
                size: 24.0,
                color: Theme.of(context).appBarTheme.actionsIconTheme.color,
              ),
              onPressed: () => _scaffoldKey.currentState.openDrawer()),
          title: Image.asset(
            "src/images/logo-color.png",
            height: 23.5,
            width: 62.7,
            color: Theme.of(context).appBarTheme.color,
            colorBlendMode: BlendMode.srcATop,
          ),
          iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 133, 251)),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.0,
        ),
        drawer: NavigationDrawer(
            false,
            [
              DrawerItemConfigGroup(widget._majorActions),
              DrawerItemConfigGroup(widget._minorActions),
            ],
            _onNavigationItemSelected),
        body: Builder(builder: (BuildContext context) {
          return POSInvoice();
        }));
  }

  _onNavigationItemSelected(String itemName) {
    Navigator.of(this.context).pushNamed(itemName);
  }
}
