import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/exceptions.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

import '../sync_progress_dialog.dart';

class LNURlWithdrawDialog extends StatefulWidget {
  final InvoiceBloc invoiceBloc;
  final AccountBloc accountBloc;
  final LNUrlBloc lnurlBloc;
  final Function(dynamic result) _onFinish;

  const LNURlWithdrawDialog(
    this.invoiceBloc,
    this.accountBloc,
    this.lnurlBloc,
    this._onFinish,
  );

  @override
  State<StatefulWidget> createState() {
    return LNUrlWithdrawDialogState();
  }
}

class LNUrlWithdrawDialogState extends State<LNURlWithdrawDialog>
    with SingleTickerProviderStateMixin {
  String _error;
  Animation<double> _opacityAnimation;
  ModalRoute _currentRoute;

  @override
  void initState() {
    super.initState();
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    ));
    controller.value = 1.0;
    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && mounted) {
        onFinish(true);
      }
    });

    widget.invoiceBloc.readyInvoicesStream
        .firstWhere((e) => e != null, orElse: () => null)
        .then((payReqModel) {
      return widget.accountBloc.accountStream
          .firstWhere((a) => a != null && a.syncedToChain == true)
          .then((_) {
        if (mounted && payReqModel != null) {
          Withdraw withdrawAction = Withdraw(payReqModel.rawPayReq);
          widget.lnurlBloc.actionsSink.add(withdrawAction);
          _listenPaidInvoice(payReqModel, controller);
          return withdrawAction.future;
        }
        return null;
      });
    }).catchError((err) {
      setState(() {
        _error = extractExceptionMessage(err);
      });
    });
  }

  void _listenPaidInvoice(
    PaymentRequestModel payReqModel,
    AnimationController controller,
  ) async {
    var payreq = await widget.invoiceBloc.paidInvoicesStream.firstWhere(
      (payreq) => payreq.paymentHash == payReqModel.paymentHash,
      orElse: () => null,
    );
    if (payreq != null) {
      Timer(const Duration(milliseconds: 1000), () {
        if (mounted) {
          controller.reverse();
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute ??= ModalRoute.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return FadeTransition(
      opacity: _opacityAnimation,
      child: AlertDialog(
        title: Text(
          texts.lnurl_withdraw_dialog_title,
          style: themeData.dialogTheme.titleTextStyle,
          textAlign: TextAlign.center,
        ),
        content: StreamBuilder<AccountModel>(
          stream: widget.accountBloc.accountStream,
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _error != null
                    ? Text(
                        texts.lnurl_withdraw_dialog_error(_error),
                        style: themeData.dialogTheme.contentTextStyle,
                        textAlign: TextAlign.center,
                      )
                    : snapshot.hasData && snapshot.data.syncedToChain != true
                        ? const SizedBox()
                        : LoadingAnimatedText(
                            texts.lnurl_withdraw_dialog_wait,
                            textStyle: themeData.dialogTheme.contentTextStyle,
                            textAlign: TextAlign.center,
                          ),
                _error != null
                    ? const SizedBox(height: 16.0)
                    : snapshot.hasData && snapshot.data.syncedToChain != true
                        ? const Padding(
                            padding: EdgeInsets.only(bottom: 12.0),
                            child: SyncProgressDialog(closeOnSync: false),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Image.asset(
                              theme.customData[theme.themeId].loaderAssetPath,
                              gaplessPlayback: true,
                            ),
                          ),
                TextButton(
                  onPressed: () => onFinish(false),
                  child: Text(
                    texts.lnurl_withdraw_dialog_action_close,
                    style: themeData.primaryTextTheme.labelLarge,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  onFinish(dynamic result) {
    Navigator.removeRoute(context, _currentRoute);
    widget._onFinish(result);
  }
}
