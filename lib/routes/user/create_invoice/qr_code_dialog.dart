import 'package:breez/widgets/compact_qr_image.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/services.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:share_extend/share_extend.dart';

class QrCodeDialog extends StatelessWidget {
  final BuildContext context;
  final InvoiceBloc _invoiceBloc;

  QrCodeDialog(this.context, this._invoiceBloc);

  @override
  Widget build(BuildContext context) {
    return _buildQrCodeDialog();
  }

  Widget _buildQrCodeDialog() {
    return new SimpleDialog(
      title: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          new Text(
            "Invoice",
            style: Theme.of(context).dialogTheme.titleTextStyle,
          ),
          new StreamBuilder<String>(
            stream: _invoiceBloc.readyInvoicesStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return new Row(
                children: <Widget>[
                  new IconButton(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 2.0, left: 14.0),
                    icon: new Icon(IconData(0xe917, fontFamily: 'icomoon')),
                    color: Theme.of(context).primaryIconTheme.color,
                    onPressed: () {
                      ShareExtend.share("lightning:" + snapshot.data, "text");
                    },
                  ),
                  new IconButton(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0, right: 14.0, left: 2.0),
                    icon: new Icon(IconData(0xe90b, fontFamily: 'icomoon')),
                    color: Theme.of(context).primaryIconTheme.color,
                    onPressed: () {
                      Clipboard.setData(new ClipboardData(text: snapshot.data));
                      showFlushbar(context, message: "Invoice address was copied to your clipboard.", duration:Duration(seconds: 3));                      
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
        new StreamBuilder<String>(
            stream: _invoiceBloc.readyInvoicesStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    width: 150.0,
                    height: 150.0,
                    child: Center(                                                
                        child: Container(
                          height: 80.0,
                          width: 80.0,
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                              theme.BreezColors.grey[500],
                            ),
                            backgroundColor: theme.whiteColor,
                          ),
                        )));
              }
              return new Column(
                children: [
                  new Container(
                    width: 230.0,
                    height: 230.0,
                    color: Colors.white,
                    child: new CompactQRImage(
                      data: snapshot.data,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 8.0)),
                  new GestureDetector(
                    onTap: () {
                      ShareExtend.share(snapshot.data, "text");
                    },
                    child: new Container(
                      child: new Text(
                        snapshot.data,
                        style: theme.bolt11Style,
                      ),
                    ),
                  ),
                ],
              );
            }),
        Padding(padding: EdgeInsets.only(top: 16.0)),
        _buildExpiryMessage(),
        Padding(padding: EdgeInsets.only(top: 16.0)),
        _buildCloseButton()
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
    );
  }

  Widget _buildExpiryMessage() {
    return new Column(children: <Widget>[
      Text("Keep the Breez app open in order to receive payment.",
          style: theme.createInvoiceDialogWarningStyle)
    ]);
  }

  Widget _buildCloseButton() {
    return new FlatButton(
      onPressed: (() {
        Navigator.pop(context);
      }),
      child: new Text("CLOSE", style: Theme.of(context).primaryTextTheme.button),
    );
  }
}
