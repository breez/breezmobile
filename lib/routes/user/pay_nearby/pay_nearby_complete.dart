import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/services/injector.dart';
import 'package:breez/services/nfc.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

class PayNearbyComplete extends StatefulWidget {  
  PayNearbyComplete();

  @override
  State<StatefulWidget> createState() {
    return PayNearbyCompleteState();
  }
}

class PayNearbyCompleteState extends State<PayNearbyComplete> with WidgetsBindingObserver {
  final String _title = "Pay Someone Nearby";
  final String _instructions =
      "To complete the payment,\nplease hold the payee's device close to yours\nas illustrated below:";
  static ServiceInjector _injector = new ServiceInjector();
  NFCService _nfc = _injector.nfc;

  InvoiceBloc _invoiceBloc;
  AccountBloc _accountBloc;

  StreamSubscription _blankInvoiceSubscription;
  StreamSubscription _paidInvoicesSubscription;
  StreamSubscription<CompletedPayment> _sentPaymentResultSubscription;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isInit = false;

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _blankInvoiceSubscription = _nfc.startP2PBeam().listen((blankInvoice) {},
          onError: (err) =>
              _scaffoldKey.currentState.showSnackBar(new SnackBar(
                  duration: new Duration(seconds: 3),
                  content: new Text(err.toString()))));
    }
  }

  @override
  void didChangeDependencies() {        
    if (!_isInit) {
      _invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);    
      startNFCStream();
      registerFulfilledPayments();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  void startNFCStream(){    
    _blankInvoiceSubscription = _nfc.startP2PBeam()
      .listen((blankInvoice) {
        // In the future perhaps show some information about the user we are paying to?
      },
      onError: (err) => _scaffoldKey.currentState.showSnackBar(new SnackBar(
          duration: new Duration(seconds: 3),
          content: new Text(err.toString()))));
  }

  void registerFulfilledPayments(){    
    _paidInvoicesSubscription = _invoiceBloc.paidInvoicesStream
      .listen((paid) {
        Navigator.of(context).pop('Payment was sent successfuly!');
      },
      onError: (err) => _scaffoldKey.currentState.showSnackBar(new SnackBar(
          duration: new Duration(seconds: 3),
          content: new Text("Failed to send payment: " + err.toString()))));
    
    _sentPaymentResultSubscription = _accountBloc.completedPaymentsStream
      .listen((fulfilledPayment) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
            duration: new Duration(seconds: 3),
            content: new Text('Payment was sent successfuly!')));
        Navigator.of(this.context).pop();
      });
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _nfc.checkNFCSettings().then((isNfcEnabled) {
      if (!isNfcEnabled) {
        return new Timer(new Duration(milliseconds: 500), () {
          _showAlertDialog();
        });
      }
    });        
  }

  void _showAlertDialog() {
    AlertDialog dialog = new AlertDialog(
      content: new Text("Breez requires NFC to be enabled in your device in order to pay someone nearby.",
          style: Theme.of(context).dialogTheme.contentTextStyle),
      actions: <Widget>[
        new FlatButton(onPressed: () => Navigator.pop(context), child: new Text("CANCEL", style: Theme.of(context).primaryTextTheme.button)),
        new FlatButton(
            onPressed: () {
              _nfc.openSettings();
              Navigator.pop(context);
            },
            child: new Text("SETTINGS", style: Theme.of(context).primaryTextTheme.button))
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  @override
  void dispose() {
    _blankInvoiceSubscription.cancel();
    _paidInvoicesSubscription.cancel();
    _sentPaymentResultSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: theme.BreezColors.blue[500],
          leading: backBtn.BackButton(),
          title: new Text(
            _title,
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 48.0, left: 16.0, right: 16.0),
              child: new Text(
                _instructions,
                textAlign: TextAlign.center,
                style: theme.textStyle,
              ),
            ),
            Positioned.fill(
              child: Image.asset(
                "src/images/waves-middle.png",
                fit: BoxFit.contain,
                width: double.infinity,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Positioned.fill(
              child: Image.asset(
                "src/images/nfc-p2p-background.png",
                fit: BoxFit.contain,
                width: double.infinity,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
