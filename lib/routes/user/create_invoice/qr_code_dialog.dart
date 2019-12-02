import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/widgets/circular_progress.dart';
import 'package:breez/widgets/compact_qr_image.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:share_extend/share_extend.dart';

class QrCodeDialog extends StatelessWidget {
  final BuildContext context;
  final InvoiceBloc _invoiceBloc;
  final AccountBloc _accountBloc;

  QrCodeDialog(this.context, this._invoiceBloc, this._accountBloc);

  @override
  Widget build(BuildContext context) {
    return _buildQrCodeDialog();
  }

  Widget _buildQrCodeDialog() {
    return SimpleDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Invoice",
            style: Theme.of(context).dialogTheme.titleTextStyle,
          ),
          StreamBuilder<String>(
            stream: _invoiceBloc.readyInvoicesStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return Row(
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: 8.0, right: 2.0, left: 14.0),
                    icon: Icon(IconData(0xe917, fontFamily: 'icomoon')),
                    color: Theme.of(context).primaryTextTheme.button.color,
                    onPressed: () {
                      ShareExtend.share("lightning:" + snapshot.data, "text");
                    },
                  ),
                  IconButton(
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: 8.0, right: 14.0, left: 2.0),
                    icon: Icon(IconData(0xe90b, fontFamily: 'icomoon')),
                    color: Theme.of(context).primaryTextTheme.button.color,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: snapshot.data));
                      showFlushbar(context,
                          message:
                              "Invoice address was copied to your clipboard.",
                          duration: Duration(seconds: 3));
                    },
                  )
                ],
              );
            },
          ),
        ],
      ),
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 8.0),
      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      children: <Widget>[
        StreamBuilder<AccountModel>(
          stream: _accountBloc.accountStream,
          builder: (context, accSnapshot) {
            return StreamBuilder<String>(
                stream: _invoiceBloc.readyInvoicesStream,
                builder: (context, snapshot) {
                  bool synced = accSnapshot.data?.synced;
                  if (!snapshot.hasData || accSnapshot.data?.synced != true) {
                    double syncProgress = accSnapshot.data?.syncProgress;
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 150.0,
                        child: synced == false
                            ? CircularProgress(
                                color: Theme.of(context).textTheme.button.color,
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
                      Container(
                        width: 230.0,
                        height: 230.0,
                        color: Colors.white,
                        child: CompactQRImage(
                          data: snapshot.data,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 8.0)),
                      GestureDetector(
                        onTap: () {
                          ShareExtend.share(snapshot.data, "text");
                        },
                        child: Container(
                          child: Text(
                            snapshot.data,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .caption
                                .copyWith(fontSize: 9),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          },
        ),
        Padding(padding: EdgeInsets.only(top: 16.0)),
        _buildExpiryMessage(),
        Padding(padding: EdgeInsets.only(top: 16.0)),
        _buildCloseButton()
      ],
    );
  }

  Widget _buildExpiryMessage() {
    return Column(children: <Widget>[
      Text("Keep the Breez app open in order to receive payment.",
          style: Theme.of(context).primaryTextTheme.caption)
    ]);
  }

  Widget _buildCloseButton() {
    return FlatButton(
      onPressed: (() {
        Navigator.pop(context);
      }),
      child: Text("CLOSE", style: Theme.of(context).primaryTextTheme.button),
    );
  }
}
