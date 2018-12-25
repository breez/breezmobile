import 'dart:io';

import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/routes/user/connect_to_pay/connect_to_pay_page.dart';
import 'package:breez/routes/user/ctp_join_session_handler.dart';
import 'package:breez/routes/shared/account_required_actions.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:breez/widgets/navigation_drawer.dart';
import 'account_page.dart';
import 'package:breez/routes/user/received_invoice_notification.dart';
import 'package:breez/widgets/lost_card_dialog.dart' as lostCard;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/routes/shared/no_connection_dialog.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';

class Home extends StatefulWidget {
  final AccountBloc accountBloc;
  final InvoiceBloc invoiceBloc;
  final ConnectPayBloc ctpBloc;
  final BackupBloc backupBloc;

  Home(this.accountBloc, this.invoiceBloc, this.ctpBloc, this.backupBloc) {
    _minorActionsInvoice =
    new List<DrawerItemConfig>.unmodifiable([
      new DrawerItemConfig(
          "/scan_invoice", "Scan Invoice", "src/icon/qr_scan.png", onItemSelected: (String name) async {
          String decodedQr = await BarcodeScanner.scan();
          invoiceBloc.decodeInvoiceSink.add(decodedQr);
      }),
      new DrawerItemConfig(
          "/create_invoice", "Create Invoice", "src/icon/paste.png"),
    ]);
  }

  final List<DrawerItemConfig> _screens =
      new List<DrawerItemConfig>.unmodifiable(
          [new DrawerItemConfig("breezHome", "Breez", "")]);

  final List<DrawerItemConfig> _majorActionsFunds =
      new List<DrawerItemConfig>.unmodifiable([
    new DrawerItemConfig("/add_funds", "Add Funds", "src/icon/add_funds.png"),
    new DrawerItemConfig(
        "/withdraw_funds", "Remove Funds", "src/icon/withdraw_funds.png"),
       new DrawerItemConfig(
         "/get_refund", "Get Refund", "src/icon/withdraw_funds.png"),
  ]);

  final List<DrawerItemConfig> _majorActionsPay =
      new List<DrawerItemConfig>.unmodifiable([
    new DrawerItemConfig(
        "/connect_to_pay", "Connect to Pay", "src/icon/connect_to_pay.png"),
    new DrawerItemConfig(
        "/pay_nearby", "Pay Someone Nearby", "src/icon/pay.png"),
  ]);

  final List<DrawerItemConfig> _minorActionsCard =
      new List<DrawerItemConfig>.unmodifiable([
    new DrawerItemConfig(
        "/order_card", "Order", "src/icon/order_card.png"),
    new DrawerItemConfig(
        "/activate_card", "Activate", "src/icon/activate_card.png"),
    new DrawerItemConfig(
        "/lost_card", "Lost or Stolen", "src/icon/lost_card.png"),
  ]);

  List<DrawerItemConfig> _minorActionsInvoice;

  final List<DrawerItemConfig> _minorActionsDev =
      new List<DrawerItemConfig>.unmodifiable([
    new DrawerItemConfig(
        "/developers", "Developers", "src/icon/developers.png"),
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
  Set _hiddenRountes = Set<String>();

  @override
  void initState() {
    super.initState();
    registerNotificationHandlers();
    listenNoConnection(context, widget.accountBloc);
    listenBackupConflicts();
    listenWhiltelistPermissionsRequest();
    _hiddenRountes.add("/get_refund");
    widget.accountBloc.refundableDepositsStream.listen((addresses){
      setState(() {
        if (addresses.length > 0) {
          _hiddenRountes.remove("/get_refund");
        } else {
          _hiddenRountes.add("/get_refund");
        }     
      });      
    });

    widget.accountBloc.accountStream.listen((acc) {
      var activeAccountRoutes = ["/connect_to_pay", "/scan_invoice", "/create_invoice"];
      Function addOrRemove = acc.active ? _hiddenRountes.remove : _hiddenRountes.add;
      setState(() {
        activeAccountRoutes.forEach((r) => addOrRemove(r));      
      });
    });
  }

  registerNotificationHandlers(){        
    new InvoiceNotificationsHandler(context, widget.accountBloc, widget.invoiceBloc.receivedInvoicesStream);
    new CTPJoinSessionHandler(widget.ctpBloc, this.context, 
      (session) {
        Navigator.popUntil(context, (route) {
          return route.settings.name != "/connect_to_pay";          
        });        
        var ctpRoute = FadeInRoute(builder: (_) => new ConnectToPayPage(session), settings: RouteSettings(name: "/connect_to_pay"));
        Navigator.of(context).push(ctpRoute);                    
      },
      (e) {
        promptError(context, "Connect to Pay", Text(e.toString(), style: theme.alertStyle));
      }
    );
  }

  void listenBackupConflicts(){
    widget.accountBloc.nodeConflictStream.listen((_) async {
      Navigator.popUntil(context, (route) {
          return route.settings.name == "/home" || route.settings.name == "/";
        }
      );
      await promptError(context, "Configuration Error", Text("Breez detected another device is running with the same configuration (probably due to restore). Breez cannot run the same configuration on more than one device. Please reinstall Breez if you wish to continue using Breez on this device.", style: theme.alertStyle), 
                        okText: "Exit Breez", okFunc: () => exit(0), disableBack: true );        
    });
  }

  void listenWhiltelistPermissionsRequest(){
    widget.accountBloc.optimizationWhitelistExplainStream.listen((_) async {
      await promptError(context, "Background Synchronization", 
        Text("In order to support instantaneous payments, Breez needs your permission in order to synchronize the information while the app is not active. Please approve the app in the next dialog.", 
        style: theme.alertStyle), 
        okFunc: () => widget.accountBloc.optimizationWhitelistRequestSink.add(null));      
    });
  }

  List<DrawerItemConfig> filterItems(List<DrawerItemConfig> items){
    return items.where( (c) => !_hiddenRountes.contains(c.name)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: AccountRequiredActionsIndicator(widget.backupBloc, widget.accountBloc),
            ),],
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
            true,
            filterItems(widget._screens),
            filterItems(widget._majorActionsFunds),
            filterItems(widget._majorActionsPay),
            filterItems(widget._minorActionsCard),
            filterItems(widget._minorActionsInvoice),
            filterItems(widget._minorActionsDev),
            _onNavigationItemSelected),
        body: widget._screenBuilders[_activeScreen]);
  }

  _onNavigationItemSelected(String itemName) {
    if (widget._screens.map((sc) => sc.name).contains(itemName)) {
      setState(() {
        _activeScreen = itemName;
      });
    } else {
      if (itemName == "/lost_card") {
        showDialog(
            context: context,
            builder: (_) => lostCard.LostCardDialog(
                  context: context,
                ));
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
