import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/services/countdown.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/compact_qr_image.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

class PosPaymentResult {
  final bool paid;
  final bool clearSale;

  PosPaymentResult({this.paid = false, this.clearSale = false});
}

class PosPaymentDialog extends StatefulWidget {
  final InvoiceBloc _invoiceBloc;
  final BreezUserModel _user;
  final String paymentRequest;
  final double satAmount;

  PosPaymentDialog(
      this._invoiceBloc, this._user, this.paymentRequest, this.satAmount);

  @override
  _PosPaymentDialogState createState() {
    return _PosPaymentDialogState();
  }
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

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          var account = snapshot.data;
          if (account == null) {
            return Loader();
          }

          return AlertDialog(
              titlePadding: EdgeInsets.fromLTRB(20.0, 22.0, 0.0, 8.0),
              title: _buildDialogTitle(account, context),
              contentPadding:
                  EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              content: _buildWaitingPayment(account, context));
        });
  }

  Widget _buildDialogTitle(AccountModel account, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Scan to Pay",
          style: Theme.of(context).dialogTheme.titleTextStyle,
        ),
        Row(
          children: <Widget>[
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: EdgeInsets.only(
                  top: 8.0, bottom: 8.0, right: 2.0, left: 14.0),
              icon: Icon(IconData(0xe917, fontFamily: 'icomoon')),
              color: Theme.of(context).primaryTextTheme.button.color,
              onPressed: () {
                ShareExtend.share("lightning:" + widget.paymentRequest, "text");
              },
            ),
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: EdgeInsets.only(
                  top: 8.0, bottom: 8.0, right: 14.0, left: 2.0),
              icon: Icon(IconData(0xe90b, fontFamily: 'icomoon')),
              color: Theme.of(context).primaryTextTheme.button.color,
              onPressed: () {
                ServiceInjector()
                    .device
                    .setClipboardText(widget.paymentRequest);
                showFlushbar(context,
                    message: "Invoice address was copied to your clipboard.",
                    duration: Duration(seconds: 3));
              },
            )
          ],
        )
      ],
    );
  }

  Widget _buildWaitingPayment(AccountModel account, BuildContext context) {
    var saleCurrency = CurrencyWrapper.fromShortName(
        widget._user.posCurrencyShortName, account);
    var userCurrency = CurrencyWrapper.fromBTC(widget._user.currency);
    var priceInSaleCurrency = "";
    if (saleCurrency != null && saleCurrency.symbol != userCurrency.symbol) {
      String salePrice = saleCurrency.format(
          widget.satAmount / saleCurrency.satConversionRate,
          removeTrailingZeros: true);
      priceInSaleCurrency = " (${saleCurrency.symbol}$salePrice)";
    }
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text(
            userCurrency.format(
                    widget.satAmount / userCurrency.satConversionRate,
                    includeCurrencySuffix: true) +
                priceInSaleCurrency,
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.headline4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                height: 230.0,
                width: 230.0,
                child: CompactQRImage(
                  data: widget.paymentRequest,
                ),
              ),
            ),
          ),
          Text(_countdownString,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline4
                  .copyWith(fontSize: 16)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: _actionsWidget(),
          ),
        ],
      ),
    );
  }

  Widget _actionsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[_clearSaleButton(), _cancelButton()],
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
}
