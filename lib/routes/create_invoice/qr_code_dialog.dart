import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/circular_progress.dart';
import 'package:breez/widgets/compact_qr_image.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

class QrCodeDialog extends StatefulWidget {
  final BuildContext context;
  final InvoiceBloc _invoiceBloc;
  final AccountBloc _accountBloc;
  final Function(dynamic result) _onFinish;

  const QrCodeDialog(
    this.context,
    this._invoiceBloc,
    this._accountBloc,
    this._onFinish,
  );

  @override
  State<StatefulWidget> createState() {
    return QrCodeDialogState();
  }
}

class QrCodeDialogState extends State<QrCodeDialog>
    with SingleTickerProviderStateMixin {
  Animation<double> _opacityAnimation;
  StreamSubscription<PaymentRequestModel> _invoiceSubscription;
  ModalRoute _currentRoute;

  @override
  void initState() {
    super.initState();
    var controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    ));
    controller.value = 1.0;
    controller.addStatusListener((status) async {
      if (status == AnimationStatus.dismissed && this.mounted) {
        onFinish(true);
      }
    });

    widget._invoiceBloc.readyInvoicesStream
        .firstWhere((element) => element != null, orElse: () => null)
        .then((payReqModel) {
      if (payReqModel != null) {
        _listenPaidInvoice(payReqModel, controller);
      }
    });

    _invoiceSubscription = widget._invoiceBloc.readyInvoicesStream.listen(
      (event) {},
      onError: (err) {
        final texts = AppLocalizations.of(context);
        onFinish(texts.qr_code_dialog_error(err));
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentRoute == null) {
      _currentRoute = ModalRoute.of(context);
    }
  }

  void _listenPaidInvoice(
    PaymentRequestModel payReqModel,
    AnimationController controller,
  ) async {
    var payreq = await widget._invoiceBloc.paidInvoicesStream.firstWhere(
      (payreq) => payreq.paymentHash == payReqModel.paymentHash,
      orElse: () => null,
    );
    if (payreq != null) {
      Timer(Duration(milliseconds: 1000), () {
        if (this.mounted) {
          controller.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _invoiceSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    return StreamBuilder<PaymentRequestModel>(
      stream: widget._invoiceBloc.readyInvoicesStream,
      builder: (context, snapshot) {
        final requestModel = snapshot.data;

        return FadeTransition(
          opacity: _opacityAnimation,
          child: SimpleDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  texts.qr_code_dialog_invoice,
                  style: themeData.dialogTheme.titleTextStyle,
                ),
                StreamBuilder<AccountModel>(
                  stream: widget._accountBloc.accountStream,
                  builder: (accCtx, accSnapshot) {
                    bool synced = accSnapshot.data?.synced == true;

                    return StreamBuilder<PaymentRequestModel>(
                      stream: widget._invoiceBloc.readyInvoicesStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || !synced) {
                          return Container();
                        }

                        return Row(
                          children: [
                            Tooltip(
                              child: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                  right: 2.0,
                                  left: 14.0,
                                ),
                                icon: Icon(IconData(
                                  0xe917,
                                  fontFamily: "icomoon",
                                )),
                                color: themeData.primaryTextTheme.button.color,
                                onPressed: () {
                                  Share.share(
                                      "lightning:" + requestModel.rawPayReq,
                                  );
                                },
                              ),
                              message: texts.qr_code_dialog_share,
                            ),
                            Tooltip(
                              child: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                  right: 14.0,
                                  left: 2.0,
                                ),
                                icon: Icon(IconData(
                                  0xe90b,
                                  fontFamily: "icomoon",
                                )),
                                color: themeData.primaryTextTheme.button.color,
                                onPressed: () {
                                  ServiceInjector()
                                      .device
                                      .setClipboardText(requestModel.rawPayReq);
                                  showFlushbar(
                                    context,
                                    message: texts.qr_code_dialog_copied,
                                    duration: Duration(seconds: 3),
                                  );
                                },
                              ),
                              message: texts.qr_code_dialog_copy,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            titlePadding: const EdgeInsets.fromLTRB(20.0, 22.0, 0.0, 8.0),
            contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
            children: [
              StreamBuilder<AccountModel>(
                stream: widget._accountBloc.accountStream,
                builder: (context, accSnapshot) {
                  final accountModel = accSnapshot.data;
                  if (snapshot.hasError || accountModel == null) {
                    return Container();
                  }
                  bool synced = accountModel.synced;
                  double syncProgress = accountModel.syncProgress;

                  return AnimatedCrossFade(
                    firstChild: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 310.0,
                      child: synced == false
                          ? CircularProgress(
                              color: themeData.textTheme.button.color,
                              size: 100.0,
                              value: syncProgress,
                              title: texts.qr_code_dialog_synchronizing,
                            )
                          : Align(
                              alignment: Alignment(0, -0.33),
                              child: Container(
                                height: 80.0,
                                width: 80.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    themeData.primaryTextTheme.button.color,
                                  ),
                                  backgroundColor: themeData.backgroundColor,
                                ),
                              ),
                            ),
                    ),
                    secondChild: requestModel?.rawPayReq == null
                        ? SizedBox()
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    width: 230.0,
                                    height: 230.0,
                                    child: CompactQRImage(
                                      data: requestModel?.rawPayReq,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 16.0)),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: _buildExpiryAndFeeMessage(
                                  context,
                                  snapshot,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                              ),
                            ],
                          ),
                    duration: Duration(seconds: 1),
                    crossFadeState: (!snapshot.hasData ||
                            requestModel?.rawPayReq == null ||
                            !synced)
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  );
                },
              ),
              _buildCloseButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpiryAndFeeMessage(
    BuildContext context,
    AsyncSnapshot<PaymentRequestModel> snapshot,
  ) {
    final themeData = Theme.of(context);

    return StreamBuilder<AccountModel>(
      stream: widget._accountBloc.accountStream,
      builder: (context, accSnapshot) {
        bool hasError = accSnapshot.hasError ||
            !accSnapshot.hasData ||
            snapshot.hasError ||
            !snapshot.hasData;

        return WarningBox(
          boxPadding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8,
          ),
          backgroundColor: theme.themeId == "BLUE" ? Color(0xFFf3f8fc) : null,
          borderColor: theme.themeId == "BLUE" ? Color(0xFF0085fb) : null,
          child: Text(
            _warningMessage(context, hasError, snapshot, accSnapshot),
            textAlign: TextAlign.center,
            style: (hasError)
                ? themeData.dialogTheme.contentTextStyle
                : themeData.primaryTextTheme.caption,
          ),
        );
      },
    );
  }

  String _warningMessage(
    BuildContext context,
    bool hasError,
    AsyncSnapshot<PaymentRequestModel> snapshot,
    AsyncSnapshot<AccountModel> accSnapshot,
  ) {
    final texts = AppLocalizations.of(context);
    if (hasError) {
      return texts.qr_code_dialog_warning_message_error;
    } else {
      final lspFee = snapshot.data.lspFee;
      if (lspFee != 0) {
        return texts.qr_code_dialog_warning_message_with_lsp(
          Currency.SAT.format(lspFee),
          accSnapshot.data.fiatCurrency.format(lspFee),
        );
      }
      return texts.qr_code_dialog_warning_message;
    }
  }

  Widget _buildCloseButton(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    return TextButton(
      onPressed: (() {
        onFinish(false);
      }),
      child: Text(
        texts.qr_code_dialog_action_close,
        style: themeData.primaryTextTheme.button,
      ),
    );
  }

  onFinish(dynamic result) {
    Navigator.removeRoute(context, _currentRoute);
    widget._onFinish(result);
  }
}
