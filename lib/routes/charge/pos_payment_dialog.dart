import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/routes/sync_progress_dialog.dart';
import 'package:breez/services/countdown.dart';
import 'package:breez/widgets/compact_qr_image.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';

class PosPaymentResult {
  final bool paid;
  final bool clearSale;

  PosPaymentResult({this.paid = false, this.clearSale = false});
}

class _PosPaymentDialogState extends State<PosPaymentDialog> {
  CountDown _paymentTimer;
  StreamSubscription<Duration> _timerSubscription;
  StreamSubscription<String> _paidInvoiceSubscription;
  String _countdownString = "3:00";

  @override
  void initState() {
    super.initState();

    _paymentTimer = CountDown(
        Duration(seconds: widget._user.cancellationTimeoutValue.toInt()));
    _timerSubscription = _paymentTimer.stream.listen((d) {
      setState(() {
        _countdownString = d.inMinutes.toRadixString(10) +
            ":" +
            (d.inSeconds - (d.inMinutes * 60))
                .toRadixString(10)
                .padLeft(2, '0');
      });
    }, onDone: () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(PosPaymentResult());
      }
    });

    _paidInvoiceSubscription =
          widget._invoiceBloc.paidInvoicesStream.listen((paidRequest) {
        setState(() {
          if (paidRequest == widget.paymentRequest) {
            Navigator.of(context).pop(PosPaymentResult(paid: true));
          }
        });
      });
  }

  @override
  void dispose() {
    _timerSubscription?.cancel();
    _paidInvoiceSubscription?.cancel();
    super.dispose();
  }

  Widget _actionsWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _clearSaleButton(), _cancelButton()
      ],
    );
  }

  Widget _cancelButton() {
    return FlatButton(
        padding: EdgeInsets.only(top: 8.0, bottom: 16.0, left: 0.0),
        child: Text(
          'CANCEL',
          textAlign: TextAlign.center,
          style: Theme.of(context).primaryTextTheme.button,
        ),
        onPressed: () {
          Navigator.of(context).pop(PosPaymentResult());
        },
      );
  }

  Widget _clearSaleButton() {
    return FlatButton(
        padding: EdgeInsets.only(top: 8.0, bottom: 16.0, right: 0.0),
        child: Text(
          'CLEAR SALE',
          textAlign: TextAlign.center,
          style: Theme.of(context).primaryTextTheme.button,
        ),
        onPressed: () {
          Navigator.of(context).pop(PosPaymentResult(clearSale: true));
        },
      );
  }

  Widget buildWaitingPayment(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          var account = snapshot.data;
          if (account == null) {
            return Loader();
          }

          if (account.syncedToChain == false) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: SyncProgressDialog(closeOnSync: false),
            );
          }

          return ListBody(
            children: <Widget>[
              _buildDialogBody(
                  'Scan the QR code to process this payment.',
                  AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                          height: 230.0,
                          width: 230.0,
                          child: CompactQRImage(
                            data: widget.paymentRequest,
                          )))),
              Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text(_countdownString,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .display1
                          .copyWith(fontSize: 16))),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: _actionsWidget(),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(40.0, 28.0, 40.0, 0.0),
      content: SingleChildScrollView(
          child: buildWaitingPayment(context)
      )
    );
  }

  ListBody _buildDialogBody(String title, Widget body) {
    return ListBody(children: <Widget>[
      Text(
        title,
        textAlign: TextAlign.center,
        style:
            Theme.of(context).primaryTextTheme.display1.copyWith(fontSize: 16),
      ),
      Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: body,
      )
    ]);
  }
}

class PosPaymentDialog extends StatefulWidget {
  final InvoiceBloc _invoiceBloc;
  final BreezUserModel _user;
  final String paymentRequest;

  PosPaymentDialog(this._invoiceBloc, this._user, this.paymentRequest);

  @override
  _PosPaymentDialogState createState() {
    return _PosPaymentDialogState();
  }
}
