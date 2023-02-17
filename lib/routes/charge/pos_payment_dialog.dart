import 'dart:async';
import 'dart:io';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lnurl/nfc_withdraw_invoice_status.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/routes/charge/pos_sale_nfc_error.dart';
import 'package:breez/services/countdown.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/compact_qr_image.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

class PosPaymentResult {
  final bool paid;
  final bool clearSale;

  const PosPaymentResult({
    this.paid = false,
    this.clearSale = false,
  });
}

class PosPaymentDialog extends StatefulWidget {
  final InvoiceBloc _invoiceBloc;
  final LNUrlBloc _lnUrlBloc;
  final BreezUserModel _user;
  final PaymentRequestModel paymentRequest;
  final double satAmount;

  const PosPaymentDialog(
    this._invoiceBloc,
    this._lnUrlBloc,
    this._user,
    this.paymentRequest,
    this.satAmount,
  );

  @override
  PosPaymentDialogState createState() {
    return PosPaymentDialogState();
  }
}

class PosPaymentDialogState extends State<PosPaymentDialog> {
  CountDown _paymentTimer;
  StreamSubscription<Duration> _timerSubscription;
  StreamSubscription<PaymentRequestModel> _paidInvoiceSubscription;
  StreamSubscription<NfcWithdrawInvoiceStatus> _nfcInvoiceSubscription;
  String _countdownString = "3:00";
  var _loadingNfc = false;

  @override
  void initState() {
    super.initState();

    _paymentTimer = CountDown(Duration(
      seconds: widget._user.cancellationTimeoutValue.toInt(),
    ));
    _timerSubscription = _paymentTimer.stream.listen((d) {
      setState(() {
        final texts = context.texts();

        _countdownString = texts.pos_dialog_clock(
          d.inMinutes.toRadixString(10),
          (d.inSeconds - (d.inMinutes * 60)).toRadixString(10).padLeft(2, "0"),
        );
      });
    }, onDone: () {
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop(const PosPaymentResult());
      }
    });

    _paidInvoiceSubscription =
        widget._invoiceBloc.paidInvoicesStream.listen((paidRequest) {
      setState(() {
        if (paidRequest.paymentHash == widget.paymentRequest.paymentHash) {
          Navigator.of(context).pop(const PosPaymentResult(paid: true));
        }
      });
    });

    _nfcInvoiceSubscription =
        widget._lnUrlBloc.nfcWithdrawStream.listen(_listenNfcWithdraw);

    widget._lnUrlBloc.actionsSink.add(RegisterNfcSaleRequest(
      Int64(widget.satAmount.toInt()),
      widget.paymentRequest,
    ));
  }

  @override
  void dispose() {
    _timerSubscription?.cancel();
    _paidInvoiceSubscription?.cancel();
    _nfcInvoiceSubscription?.cancel();
    widget._lnUrlBloc.actionsSink.add(ClearNfcSaleRequest());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (context, snapshot) {
        final account = snapshot.data;
        if (account == null) {
          return const Loader();
        }

        return AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(20.0, 22.0, 0.0, 8.0),
          title: _buildDialogTitle(context, account),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
          content: _buildWaitingPayment(context, account),
        );
      },
    );
  }

  Widget _buildDialogTitle(
    BuildContext context,
    AccountModel account,
  ) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            texts.pos_dialog_title,
            style: themeData.dialogTheme.titleTextStyle,
          ),
        ),
        Row(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset(
                "src/icon/nfc.svg",
                colorFilter: ColorFilter.mode(
                  Platform.isAndroid
                      ? themeData.dialogTheme.titleTextStyle.color
                      : themeData.primaryTextTheme.labelLarge.color,
                  BlendMode.srcATop,
                ),
              ),
              onPressed: Platform.isAndroid
                  ? null
                  : () {
                      ServiceInjector().nfc.starSession(autoClose: true);
                    },
            ),
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 2.0, 8.0),
              icon: const Icon(IconData(0xe917, fontFamily: 'icomoon')),
              color: themeData.primaryTextTheme.labelLarge.color,
              tooltip: texts.pos_dialog_share,
              onPressed: () => Share.share(
                "lightning:${widget.paymentRequest.rawPayReq}",
              ),
            ),
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: const EdgeInsets.fromLTRB(2.0, 8.0, 14.0, 8.0),
              icon: const Icon(IconData(0xe90b, fontFamily: 'icomoon')),
              color: themeData.primaryTextTheme.labelLarge.color,
              tooltip: texts.pos_dialog_invoice_copy,
              onPressed: () {
                ServiceInjector()
                    .device
                    .setClipboardText(widget.paymentRequest.rawPayReq);
                showFlushbar(
                  context,
                  message: texts.pos_dialog_invoice_copied,
                  duration: const Duration(seconds: 3),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWaitingPayment(
    BuildContext context,
    AccountModel account,
  ) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    final lspFee = widget.paymentRequest.lspFee;
    var saleCurrency = CurrencyWrapper.fromShortName(
        widget._user.posCurrencyShortName, account);
    var userCurrency = (saleCurrency.isFiat)
        ? CurrencyWrapper.fromBTC(Currency.SAT)
        : saleCurrency;
    var priceInSaleCurrency = "";
    if (saleCurrency.isFiat) {
      String salePrice = saleCurrency.format(
        widget.satAmount / saleCurrency.satConversionRate,
        includeCurrencySymbol: true,
        removeTrailingZeros: true,
      );
      priceInSaleCurrency =
          saleCurrency.rtl ? "($salePrice) " : " ($salePrice)";
    }

    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text(
            userCurrency.format(
                  widget.satAmount / userCurrency.satConversionRate,
                  includeCurrencySymbol: true,
                ) +
                priceInSaleCurrency,
            textAlign: TextAlign.center,
            style: themeData.primaryTextTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: SizedBox(
                height: 230.0,
                width: 230.0,
                child: _loadingNfc
                    ? const Loader()
                    : CompactQRImage(
                        data: widget.paymentRequest.rawPayReq,
                      ),
              ),
            ),
          ),
          lspFee == 0
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    texts.pos_dialog_setup_fee(
                      Currency.SAT.format(lspFee),
                      account.fiatCurrency.format(lspFee),
                    ),
                    textAlign: TextAlign.center,
                    style: themeData.primaryTextTheme.headlineMedium,
                  ),
                ),
          Text(
            _countdownString,
            textAlign: TextAlign.center,
            style: themeData.primaryTextTheme.headlineMedium.copyWith(
              fontSize: 16,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: _actionsWidget(context),
          ),
        ],
      ),
    );
  }

  Widget _actionsWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _clearSaleButton(context),
        _cancelButton(context),
      ],
    );
  }

  Widget _clearSaleButton(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 16.0),
      ),
      child: Text(
        texts.pos_dialog_clear_sale,
        textAlign: TextAlign.center,
        style: themeData.primaryTextTheme.labelLarge,
      ),
      onPressed: () {
        Navigator.of(context).pop(const PosPaymentResult(clearSale: true));
      },
    );
  }

  Widget _cancelButton(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 16.0),
      ),
      child: Text(
        texts.pos_dialog_cancel,
        textAlign: TextAlign.center,
        style: themeData.primaryTextTheme.labelLarge,
      ),
      onPressed: () {
        Navigator.of(context).pop(const PosPaymentResult());
      },
    );
  }

  void _nfcWithdrawStarted() {
    if (mounted) {
      setState(() {
        _loadingNfc = true;
      });
    }
  }

  void _nfcWithdrawFinished() {
    if (mounted) {
      setState(() {
        _loadingNfc = false;
      });
    }
  }

  void _listenNfcWithdraw(NfcWithdrawInvoiceStatus status) {
    final texts = context.texts();
    if (status is NfcWithdrawInvoiceStatusStarted) {
      _nfcWithdrawStarted();
      return;
    }

    if (status is NfcWithdrawInvoiceStatusRangeError) {
      showDialog(
        context: context,
        builder: (_) => PosSaleNfcError(
          texts.pos_payment_nfc_range_error(
            Currency.SAT.format(status.minAmount, includeDisplayName: false),
            Currency.SAT.format(status.maxAmount),
          ),
        ),
      );
    } else if (status is NfcWithdrawInvoiceStatusTimeoutError) {
      showFlushbar(
        context,
        message: texts.payment_error_payment_timeout_exceeded,
      );
    } else if (status is NfcWithdrawInvoiceStatusError) {
      showFlushbar(context, message: status.message);
    }

    _nfcWithdrawFinished();
  }
}
