import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/services/injector.dart';
import 'package:breez/services/nfc.dart';
import 'dart:async';

class PayNearbyComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new BlocConnector<AppBlocs>((context, blocs) =>
        _PayNearbyComplete(blocs.invoicesBloc, blocs.accountBloc));
  }
}

class _PayNearbyComplete extends StatefulWidget {
  InvoiceBloc _invoiceBloc;
  AccountBloc _accountBloc;

  _PayNearbyComplete(this._invoiceBloc, this._accountBloc);

  @override
  State<StatefulWidget> createState() {
    return new PayNearbyCompleteState();
  }
}

class PayNearbyCompleteState extends State<_PayNearbyComplete> {
  final String _title = "Pay Someone Nearby";
  final String _instructions =
      "To complete the payment,\nplease hold the payee's device close to yours\nas illustrated below:";
  static ServiceInjector _injector = new ServiceInjector();
  NFCService _nfc = _injector.nfc;
  StreamSubscription _blankInvoiceSubscription;
  StreamSubscription _paidInvoicesSubscription;
  StreamSubscription<String> _sentPaymentResultSubscription;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    _blankInvoiceSubscription = _nfc.startP2PBeam().listen((blankInvoice) {
      // In the future perhaps show some information about the user we are paying to?
    },
        onError: (err) => _scaffoldKey.currentState.showSnackBar(new SnackBar(
            duration: new Duration(seconds: 3),
            content: new Text(err.toString()))));

    _paidInvoicesSubscription = widget._invoiceBloc.paidInvoicesStream.listen(
        (paid) {
      Navigator.of(context).pop();
    },
        onError: (err) => _scaffoldKey.currentState.showSnackBar(new SnackBar(
            duration: new Duration(seconds: 3),
            content: new Text("Failed to send payment: " + err.toString()))));

    _sentPaymentResultSubscription =
        widget._accountBloc.fulfilledPayments.listen((fulfilledPayment) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          duration: new Duration(seconds: 3),
          content: new Text('Payment was sent successfuly!')));
      Navigator.of(this.context).pop();
    });
  }

  @override
  void dispose() {
    _blankInvoiceSubscription.cancel();
    _paidInvoicesSubscription.cancel();
    _sentPaymentResultSubscription.cancel();
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
          backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
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
              padding: EdgeInsets.only(top: 48.0, left: 23.0, right: 24.0),
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
