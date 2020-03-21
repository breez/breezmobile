import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/routes/sync_progress_dialog.dart';
import 'package:breez/services/countdown.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/compact_qr_image.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

import 'loader.dart';

enum _PosPaymentState { WAITING_FOR_PAYMENT, PAYMENT_RECEIVED }

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
  _PosPaymentState _state = _PosPaymentState.WAITING_FOR_PAYMENT;
  CountDown _paymentTimer;
  StreamSubscription<Duration> _timerSubscription;
  String _countdownString = "3:00";
  String _debugMessage = "";

  StreamSubscription<String> _sentInvoicesSubscription;
  StreamSubscription<bool> _paidInvoicesSubscription;

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
        Navigator.of(context).pop(false);
      }
    });

    _sentInvoicesSubscription =
        widget._invoiceBloc.sentInvoicesStream.listen((message) {
      _debugMessage = message;

      setState(() {
        _state = _PosPaymentState.WAITING_FOR_PAYMENT;
      });
    }, onError: (err) {
      Navigator.of(context).pop(false);
      showFlushbar(context,
          message: err.toString(), duration: Duration(seconds: 3));
    });

    _paidInvoicesSubscription =
        widget._invoiceBloc.paidInvoicesStream.listen((paid) {
      setState(() {
        _state = _PosPaymentState.PAYMENT_RECEIVED;
      });
    }, onError: (err) {
      Navigator.of(context).pop(false);
      showFlushbar(context,
          message: err.toString(), duration: Duration(seconds: 3));
    });
  }

  @override
  void dispose() {
    _timerSubscription?.cancel();
    _paidInvoicesSubscription?.cancel();
    _sentInvoicesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          flex: 2,
          child: AutoSizeText(
            "Scan to Process Payment",
            style: Theme.of(context).dialogTheme.titleTextStyle,
            maxLines: 1,
            minFontSize: MinFontSize(context).minFontSize,
            stepGranularity: 0.1,
          ),
        ),
        // TODO: Hide share & copy icons during sync
        Expanded(
          flex: 1,
          child: Row(children: [
            IconButton(
              padding: EdgeInsets.only(
                  top: 8.0, bottom: 8.0, right: 2.0, left: 14.0),
              icon: Icon(IconData(0xe917, fontFamily: 'icomoon')),
              color: Theme.of(context).primaryTextTheme.button.color,
              onPressed: () {
                ShareExtend.share("lightning:" + widget.paymentRequest, "text");
              },
            ),
            IconButton(
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
          ]),
        )
      ]),
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      content: SingleChildScrollView(
          child: _state == _PosPaymentState.WAITING_FOR_PAYMENT
              ? buildWaitingPayment(context)
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  child: ListBody(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 40.0),
                        child: Text(
                          'Payment approved!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .display1
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 40.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Theme.of(context).buttonColor,
                            shape: BoxShape.circle,
                          ),
                          child: Image(
                            image: AssetImage("src/icon/ic_done.png"),
                            height: 48.0,
                            color: theme.themeId == "BLUE"
                                ? Color.fromRGBO(0, 133, 251, 1.0)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
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

          var saleCurrency = CurrencyWrapper.fromShortName(
              widget._user.posCurrencyShortName, account);
          var userCurrency = CurrencyWrapper.fromBTC(widget._user.currency);
          var priceInSaleCurrency = "";
          if (saleCurrency.symbol != userCurrency.symbol) {
            String salePrice = saleCurrency.format(
                widget.satAmount / saleCurrency.satConversionRate,
                removeTrailingZeros: true);
            priceInSaleCurrency = " (${saleCurrency.symbol}$salePrice)";
          }
          return ListBody(
            children: <Widget>[
              Text(
                userCurrency.format(
                        widget.satAmount / userCurrency.satConversionRate,
                        includeCurrencySuffix: true) +
                    priceInSaleCurrency,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
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
              Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(_countdownString,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .display1
                          .copyWith(fontSize: 16))),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 17),
                child: _actionsWidget(),
              ),
            ],
          );
        });
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
        Navigator.of(context).pop(true);
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
        Navigator.of(context).pop(false);
      },
    );
  }
}
