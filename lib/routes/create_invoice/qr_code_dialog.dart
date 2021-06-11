import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/circular_progress.dart';
import 'package:breez/widgets/compact_qr_image.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/utils/i18n.dart';
import 'package:share_extend/share_extend.dart';

class QrCodeDialog extends StatefulWidget {
  final BuildContext context;
  final InvoiceBloc _invoiceBloc;
  final AccountBloc _accountBloc;
  final Function(dynamic result) _onFinish;

  QrCodeDialog(
      this.context, this._invoiceBloc, this._accountBloc, this._onFinish);

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
        vsync: this, duration: Duration(milliseconds: 1000));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.ease));
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

    _invoiceSubscription = widget._invoiceBloc.readyInvoicesStream
        .listen((event) {}, onError: (err) {
      onFinish("Failed to create an invoice ($err). Please try again later.");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentRoute == null) {
      _currentRoute = ModalRoute.of(context);
    }
  }

  void _listenPaidInvoice(
      PaymentRequestModel payReqModel, AnimationController controller) async {
    var payreq =
        await widget._invoiceBloc.paidInvoicesStream.firstWhere((payreq) {
      bool ok = payreq.paymentHash == payReqModel.paymentHash;
      return ok;
    }, orElse: () => null);
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
    return _buildQrCodeDialog();
  }

  Widget _buildQrCodeDialog() {
    return StreamBuilder<PaymentRequestModel>(
        stream: widget._invoiceBloc.readyInvoicesStream,
        builder: (context, snapshot) {
          return FadeTransition(
            opacity: _opacityAnimation,
            child: SimpleDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t(context, "invoice"),
                    style: Theme.of(context).dialogTheme.titleTextStyle,
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
                              children: <Widget>[
                                IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  padding: EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 8.0,
                                      right: 2.0,
                                      left: 14.0),
                                  icon: Icon(
                                      IconData(0xe917, fontFamily: 'icomoon')),
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .button
                                      .color,
                                  onPressed: () {
                                    ShareExtend.share(
                                        "lightning:" + snapshot.data.rawPayReq,
                                        "text");
                                  },
                                ),
                                IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  padding: EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 8.0,
                                      right: 14.0,
                                      left: 2.0),
                                  icon: Icon(
                                      IconData(0xe90b, fontFamily: 'icomoon')),
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .button
                                      .color,
                                  onPressed: () {
                                    ServiceInjector().device.setClipboardText(
                                        snapshot.data.rawPayReq);
                                    showFlushbar(context,
                                        message: t(context,
                                            "invoice_data_was_copied_to_your_clipboard"),
                                        duration: Duration(seconds: 3));
                                  },
                                )
                              ],
                            );
                          },
                        );
                      }),
                ],
              ),
              titlePadding: EdgeInsets.fromLTRB(20.0, 22.0, 0.0, 8.0),
              contentPadding:
                  EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              children: <Widget>[
                StreamBuilder<AccountModel>(
                  stream: widget._accountBloc.accountStream,
                  builder: (context, accSnapshot) {
                    if (snapshot.hasError) {
                      return Container();
                    }
                    bool synced = accSnapshot.data?.synced;
                    double syncProgress = accSnapshot.data?.syncProgress;
                    return AnimatedCrossFade(
                      firstChild: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 310.0,
                          child: synced == false
                              ? CircularProgress(
                                  color:
                                      Theme.of(context).textTheme.button.color,
                                  size: 100.0,
                                  value: syncProgress,
                                  title: t(
                                      context, "synchronizing_to_the_network"))
                              : Align(
                                  alignment: Alignment(0, -0.33),
                                  child: Container(
                                    height: 80.0,
                                    width: 80.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context)
                                              .primaryTextTheme
                                              .button
                                              .color),
                                      backgroundColor:
                                          Theme.of(context).backgroundColor,
                                    ),
                                  ))),
                      secondChild: snapshot.data?.rawPayReq == null
                          ? SizedBox()
                          : Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    width: 230.0,
                                    height: 230.0,
                                    child: CompactQRImage(
                                      data: snapshot.data?.rawPayReq,
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 24.0)),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: _buildExpiryAndFeeMessage(snapshot)),
                                Padding(padding: EdgeInsets.only(top: 16.0)),
                              ],
                            ),
                      duration: Duration(seconds: 1),
                      crossFadeState: (!snapshot.hasData ||
                              snapshot.data?.rawPayReq == null ||
                              !synced)
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                    );
                  },
                ),
                _buildCloseButton()
              ],
            ),
          );
        });
  }

  Widget _buildExpiryAndFeeMessage(
      AsyncSnapshot<PaymentRequestModel> snapshot) {
    String _message = "";
    bool _hasError = true;
    return StreamBuilder<AccountModel>(
        stream: widget._accountBloc.accountStream,
        builder: (context, accSnapshot) {
          if (accSnapshot.hasError ||
              !accSnapshot.hasData ||
              snapshot.hasError ||
              !snapshot.hasData) {
            _message = t(context, "failed_to_create_invoice");
          } else {
            _hasError = false;
            _message = t(context, "keep_breez_open_until_payment_is_completed");

            if (snapshot.data.lspFee != 0) {
              _message +=
                  t(context, "a_setup_fee_is_applied_to_this_invoice", params: {
                "satFee": Currency.SAT.format(snapshot.data.lspFee),
                "fiatFee":
                    accSnapshot.data.fiatCurrency.format(snapshot.data.lspFee)
              });
            }
          }

          return Text(
            _message,
            textAlign: TextAlign.center,
            style: (_hasError)
                ? Theme.of(context).dialogTheme.contentTextStyle
                : Theme.of(context).primaryTextTheme.caption,
          );
        });
  }

  Widget _buildCloseButton() {
    return TextButton(
      onPressed: (() {
        onFinish(false);
      }),
      child: Text(t(context, "CLOSE"),
          style: Theme.of(context).primaryTextTheme.button),
    );
  }

  onFinish(dynamic result) {
    Navigator.removeRoute(context, _currentRoute);
    widget._onFinish(result);
  }
}
