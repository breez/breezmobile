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
import 'package:share_extend/share_extend.dart';

class QrCodeDialog extends StatefulWidget {
  final BuildContext context;
  final InvoiceBloc _invoiceBloc;
  final AccountBloc _accountBloc;

  QrCodeDialog(this.context, this._invoiceBloc, this._accountBloc);

  @override
  State<StatefulWidget> createState() {
    return QrCodeDialogState();
  }
}

class QrCodeDialogState extends State<QrCodeDialog>
    with SingleTickerProviderStateMixin {
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    var controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.ease));
    controller.value = 1.0;
    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && this.mounted) {
        Navigator.pop(context, true);
      }
    });

    widget._invoiceBloc.readyInvoicesStream.first.then((payReqModel) {
      _listenPaidInvoice(payReqModel, controller);
    });
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
                    "Invoice",
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
                                        message:
                                            "Invoice data was copied to your clipboard.",
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
                    if (!snapshot.hasData || accSnapshot.data?.synced != true) {
                      double syncProgress = accSnapshot.data?.syncProgress;
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150.0,
                          child: synced == false
                              ? CircularProgress(
                                  color:
                                      Theme.of(context).textTheme.button.color,
                                  size: 100.0,
                                  value: syncProgress,
                                  title: "Synchronizing to the network")
                              : Center(
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
                                )));
                    }
                    return Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            width: 230.0,
                            height: 230.0,
                            child: CompactQRImage(
                              data: snapshot.data.rawPayReq,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 8.0)),
                      ],
                    );
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 16.0)),
                _buildExpiryMessage(snapshot.hasError),
                _buildFeeMessage(snapshot),
                Padding(padding: EdgeInsets.only(top: 16.0)),
                _buildCloseButton()
              ],
            ),
          );
        });
  }

  Widget _buildExpiryMessage(bool hasError) {
    if (hasError) {
      return Column(children: <Widget>[
        Text("Failed to create invoice",
            style: Theme.of(context).dialogTheme.contentTextStyle)
      ]);
    }
    return Column(children: <Widget>[
      Text("Keep the Breez app open in order to receive payment.",
          style: Theme.of(context).primaryTextTheme.caption)
    ]);
  }

  Widget _buildFeeMessage(AsyncSnapshot<PaymentRequestModel> snapshot) {
    return StreamBuilder<AccountModel>(
        stream: widget._accountBloc.accountStream,
        builder: (context, accSnapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Container();
          }
          return snapshot.data.lspFee == 0
              ? SizedBox()
              : Container(
                  child: Text(
                    "A setup fee of ${Currency.SAT.format(snapshot.data.lspFee)} (${accSnapshot.data.fiatCurrency.format(snapshot.data.lspFee)}) is applied to this invoice.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).primaryTextTheme.caption,
                  ),
                );
        });
  }

  Widget _buildCloseButton() {
    return FlatButton(
      onPressed: (() {
        Navigator.pop(context, false);
      }),
      child: Text("CLOSE", style: Theme.of(context).primaryTextTheme.button),
    );
  }
}
