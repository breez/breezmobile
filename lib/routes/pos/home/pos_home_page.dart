import 'pos_invoice.dart';
import 'package:flutter/material.dart';
import 'package:breez/widgets/navigation_drawer.dart';
import 'package:breez/theme_data.dart' as theme;

class PosHome extends StatefulWidget {
  final List<DrawerItemConfig> _screens =
      new List<DrawerItemConfig>.unmodifiable([]);

  final List<DrawerItemConfig> _majorActions =
      new List<DrawerItemConfig>.unmodifiable([
        new DrawerItemConfig("/transactions", "Transactions","src/icon/transactions.png"),
        new DrawerItemConfig("/withdraw_funds", "Remove Funds", "src/icon/withdraw_funds.png"),
        new DrawerItemConfig("/settings", "Settings","src/icon/settings.png")
      ]);

  final List<DrawerItemConfig> _minorActions =
      new List<DrawerItemConfig>.unmodifiable([           
          new DrawerItemConfig("/developers", "Developers","src/icon/developers.png"),
        ]);

  @override
  State<StatefulWidget> createState() {
    return new PosHomeState();
  }
}

class PosHomeState extends State<PosHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          leading: new IconButton(icon: ImageIcon(AssetImage("src/icon/hamburger.png"),size: 24.0,color: null,),
              onPressed: () => _scaffoldKey.currentState.openDrawer()),
          title: new Image.asset("src/images/logo-color.png",height: 23.5,width: 62.7,),
          iconTheme: new IconThemeData(color: Color.fromARGB(255, 0, 133, 251)),
          backgroundColor: theme.whiteColor,
          elevation: 0.0,
        ),
        drawer: new NavigationDrawer(false, widget._screens, widget._majorActions, null,
            null, widget._minorActions, _onNavigationItemSelected),
        body: new Builder(builder: (BuildContext context) {
          return POSInvoice();
        }));
  }

  _onNavigationItemSelected(String itemName) {
    Navigator.of(this.context).pushNamed(itemName);
  }
}
