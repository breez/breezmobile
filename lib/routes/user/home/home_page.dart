import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:breez/widgets/navigation_drawer.dart';
import 'account_page.dart';
import 'package:breez/routes/user/received_invoice_notification.dart';
import 'package:breez/widgets/lost_card_dialog.dart' as lostCard;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/routes/shared/no_connection_dialog.dart';

class Home extends StatefulWidget {
  final AccountBloc accountBloc;
  final Stream<PaymentRequestModel> receivedInvoicesStream;

  Home(this.accountBloc, this.receivedInvoicesStream);

  final List<DrawerItemConfig> _screens =
      new List<DrawerItemConfig>.unmodifiable([new DrawerItemConfig("breezHome", "Breez", "")]);

  final List<DrawerItemConfig> _majorActionsFunds = new List<DrawerItemConfig>.unmodifiable([
    new DrawerItemConfig("/add_funds", "Add Funds", "src/icon/add_funds.png"),
    new DrawerItemConfig("/withdraw_funds", "Remove Funds", "src/icon/withdraw_funds.png"),
  ]);

  final List<DrawerItemConfig> _majorActionsPay = new List<DrawerItemConfig>.unmodifiable([
    new DrawerItemConfig("/connect_to_pay", "Connect to Pay", "src/icon/connect_to_pay.png"),
    new DrawerItemConfig("/pay_nearby", "Pay Someone Nearby", "src/icon/pay.png"),
  ]);

  final List<DrawerItemConfig> _minorActionsCard = new List<DrawerItemConfig>.unmodifiable([
    new DrawerItemConfig("/order_card", "Order Card", "src/icon/order_card.png"),
    new DrawerItemConfig("/activate_card", "Activate Card", "src/icon/activate_card.png"),
    new DrawerItemConfig("/lost_card", "Lost or Stolen Card", "src/icon/lost_card.png"),
  ]);

  final List<DrawerItemConfig> _minorActionsDev = new List<DrawerItemConfig>.unmodifiable([
    new DrawerItemConfig("/developers", "Developers", "src/icon/developers.png"),
  ]);

  final Map<String, Widget> _screenBuilders = {"breezHome": new AccountPage()};

  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _activeScreen = "breezHome";

  @override
  void initState() {
    super.initState();
    InvoiceNotificationsHandler _notificationsHandler =
    new InvoiceNotificationsHandler(context, widget.accountBloc, widget.receivedInvoicesStream);
    listenNoConnection(context, widget.accountBloc);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          leading: new IconButton(
              icon: ImageIcon(AssetImage("src/icon/hamburger.png"), size: 24.0, color: null,),
              onPressed: () => _scaffoldKey.currentState.openDrawer()),
          title: new Image.asset("src/images/logo-color.png", height: 23.5, width: 62.7,),
          iconTheme: new IconThemeData(color: Color.fromARGB(255, 0, 133, 251)),
          backgroundColor: theme.whiteColor,
          elevation: 0.0,
        ),
        drawer: new NavigationDrawer(true, widget._screens, widget._majorActionsFunds, widget._majorActionsPay,
            widget._minorActionsCard, widget._minorActionsDev, _onNavigationItemSelected),
        body: widget._screenBuilders[_activeScreen]);
  }

  _onNavigationItemSelected(String itemName) {
    if (widget._screens.map((sc) => sc.name).contains(itemName)) {
      setState(() {
        _activeScreen = itemName;
      });
    } else {
      if (itemName == "/lost_card") {
          showDialog(context: context, builder: (_) => lostCard.LostCardDialog(context: context,));
      } else {
        Navigator.of(context).pushNamed(itemName).then((message) {
          if (message != null) {
            showFlushbar(context, message: message);
          }
        });
      }
    }
  }

  DrawerItemConfig get activeScreen {
    return widget._screens.firstWhere((screen) => screen.name == _activeScreen);
  }
}
