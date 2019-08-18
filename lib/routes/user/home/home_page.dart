import 'dart:async';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/shared/account_required_actions.dart';
import 'package:breez/routes/shared/no_connection_dialog.dart';
import 'package:breez/routes/user/connect_to_pay/connect_to_pay_page.dart';
import 'package:breez/routes/user/ctp_join_session_handler.dart';
import 'package:breez/routes/user/received_invoice_notification.dart';
import 'package:breez/routes/user/showPinHandler.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/barcode_scanner_placeholder.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/fade_in_widget.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/lost_card_dialog.dart' as lostCard;
import 'package:breez/widgets/navigation_drawer.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../sync_ui_handler.dart';
import 'account_page.dart';

final GlobalKey firstPaymentItemKey = new GlobalKey();
final ScrollController scrollController = new ScrollController();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class Home extends StatefulWidget {
  final AccountBloc accountBloc;
  final InvoiceBloc invoiceBloc;
  final UserProfileBloc userProfileBloc;
  final ConnectPayBloc ctpBloc;
  final BackupBloc backupBloc;

  Home(this.accountBloc, this.invoiceBloc, this.userProfileBloc, this.ctpBloc, this.backupBloc);

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
        "/connect_to_pay", "Connect to Pay", "src/icon/connect_to_pay.png")
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

  final List<DrawerItemConfig> _minorActionsAdvanced =
      new List<DrawerItemConfig>.unmodifiable([
    new DrawerItemConfig(
        "/network", "Network", "src/icon/network.png"),
    new DrawerItemConfig(
        "/security", "Security PIN", "src/icon/security.png"),
    new DrawerItemConfig(
        "/developers", "Developers", "src/icon/developers.png"),
  ]);

  final Map<String, Widget> _screenBuilders = {"breezHome": new AccountPage(firstPaymentItemKey, scrollController)};

  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> {
  String _activeScreen = "breezHome";
  Set _hiddenRountes = Set<String>();
  StreamSubscription<String> _accountNotificationsSubscription;

  @override
  void initState() {
    super.initState();    
    _registerNotificationHandlers();
    listenNoConnection(context, widget.accountBloc);
    _listenBackupConflicts();
    _listenWhiltelistPermissionsRequest();
    _hiddenRountes.add("/get_refund");
    widget.accountBloc.accountStream.listen((acc){
      setState(() {        
        if (acc != null && acc.swapFundsStatus.maturedRefundableAddresses.length > 0) {
          _hiddenRountes.remove("/get_refund");
        } else {
          _hiddenRountes.add("/get_refund");
        }     
      });      
    });

    widget.accountBloc.accountStream.listen((acc) {
      var activeAccountRoutes = ["/connect_to_pay", "/pay_invoice", "/create_invoice"];
      Function addOrRemove = acc.active ? _hiddenRountes.remove : _hiddenRountes.add;
      setState(() {
        activeAccountRoutes.forEach((r) => addOrRemove(r));      
      });
    });
  }  

  @override
  void dispose() {
    _accountNotificationsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
        color: theme.BreezColors.blue[500],        
      ),
      child: FadeInWidget(
        child: new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              centerTitle: false,
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
                [
                  DrawerItemConfigGroup(_filterItems(widget._majorActionsFunds)),
                  DrawerItemConfigGroup(_filterItems(widget._majorActionsPay)),
                  _buildMinorActionsInvoice(context),
                  DrawerItemConfigGroup(_filterItems(widget._minorActionsCard), groupTitle: "Card", groupAssetImage: "src/icon/card.png"),
                  DrawerItemConfigGroup(_filterItems(widget._minorActionsAdvanced), groupTitle: "Advanced", groupAssetImage: "src/icon/advanced.png"),
                ],
                _onNavigationItemSelected),
            body: widget._screenBuilders[_activeScreen]),
      ),
    );
  }

  DrawerItemConfigGroup _buildMinorActionsInvoice(BuildContext context) {
    List<DrawerItemConfig> minorActionsInvoice = new List<DrawerItemConfig>.unmodifiable([
      new DrawerItemConfig("/pay_invoice", "Pay Invoice", "src/icon/qr_scan.png", onItemSelected: (String name) async {
        try {
          String decodedQr = await BarcodeScanner.scan();
          (decodedQr.toLowerCase().startsWith("ln") || decodedQr.toLowerCase().startsWith("lightning:"))
              ? widget.invoiceBloc.decodeInvoiceSink.add(decodedQr)
              : showFlushbar(context, message: "Lightning Invoice wasn’t detected.");
        } on PlatformException catch (e) {
          if (e.code == BarcodeScanner.CameraAccessDenied) {
            Navigator.of(context).push(FadeInRoute(builder: (_) => BarcodeScannerPlaceholder(widget.invoiceBloc)));
          }
        }
      }),
      new DrawerItemConfig("/create_invoice", "Create Invoice", "src/icon/paste.png"),
    ]);
    return DrawerItemConfigGroup(_filterItems(minorActionsInvoice));
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
          if (message != null && message.runtimeType == String) {
            showFlushbar(context, message: message);
          }
        });
      }
    }
  }

  void _registerNotificationHandlers(){        
    new InvoiceNotificationsHandler(context, widget.accountBloc, widget.invoiceBloc.receivedInvoicesStream, firstPaymentItemKey, scrollController, _scaffoldKey);
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
    new SyncUIHandler(widget.accountBloc, context);
    new ShowPinHandler(widget.userProfileBloc, context);

    _accountNotificationsSubscription = widget.accountBloc.accountNotificationsStream
      .listen(
        (data) => showFlushbar(context, message: data), 
        onError: (e) => showFlushbar(context, message: e.toString())
      );    
  }

  void _listenBackupConflicts(){
    widget.accountBloc.nodeConflictStream.listen((_) async {
      Navigator.popUntil(context, (route) {
          return route.settings.name == "/home" || route.settings.name == "/";
        }
      );
      await promptError(context, "Configuration Error", Text("Breez detected another device is running with the same configuration (probably due to restore). Breez cannot run the same configuration on more than one device. Please reinstall Breez if you wish to continue using Breez on this device.", style: theme.alertStyle), 
                        okText: "Exit Breez", okFunc: () => exit(0), disableBack: true );        
    });
  }

  void _listenWhiltelistPermissionsRequest(){
    widget.accountBloc.optimizationWhitelistExplainStream.listen((_) async {
      await promptError(context, "Background Synchronization", 
        Text("In order to support instantaneous payments, Breez needs your permission in order to synchronize the information while the app is not active. Please approve the app in the next dialog.", 
        style: theme.alertStyle), 
        okFunc: () => widget.accountBloc.optimizationWhitelistRequestSink.add(null));      
    });
  }

  List<DrawerItemConfig> _filterItems(List<DrawerItemConfig> items){
    return items.where( (c) => !_hiddenRountes.contains(c.name)).toList();
  }

  DrawerItemConfig get activeScreen {
    return widget._screens.firstWhere((screen) => screen.name == _activeScreen);
  }
}
