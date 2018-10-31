import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';

class QrCodeDialog extends StatelessWidget {
  final BuildContext context;
  final InvoiceBloc _invoiceBloc;

  final snackBar = new SnackBar(
    content: new Text(
      'Deposit address was copied to your clipboard.',
      style: theme.snackBarStyle,
    ),
    backgroundColor: theme.snackBarBackgroundColor,
    duration: new Duration(seconds: 4),
  );

  QrCodeDialog(this.context, this._invoiceBloc);

  @override
  Widget build(BuildContext context) {
    return _buildQrCodeDialog();
  }

  Widget _buildQrCodeDialog() {
    return new SimpleDialog(
      title: new Text(
        "Invoice",
        style: theme.alertTitleStyle,
      ),
      titlePadding: EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 8.0),
      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      children: <Widget>[
        new StreamBuilder<String>(
            stream: _invoiceBloc.readyInvoicesStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    width: 150.0,
                    height: 150.0,
                    child: Padding(
                        padding: EdgeInsets.only(right: 45.0, left: 45.0, bottom: 20.0),
                        child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(theme.BreezColors.grey[500],),
                      backgroundColor: theme.BreezColors.grey[500],
                    )));
              }
              return new Column(
                children: [
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new IconButton(
                        icon: new Icon(IconData(0xe917, fontFamily: 'icomoon')),
                        color: theme.BreezColors.grey[500],
                        onPressed: () {
                          Share.share("lightning:" + snapshot.data);
                        },
                      ),
                      new IconButton(
                        icon: new Icon(IconData(0xe90b, fontFamily: 'icomoon')),
                        color: theme.BreezColors.grey[500],
                        onPressed: () {
                          Clipboard.setData(
                              new ClipboardData(text: snapshot.data));
                          Scaffold.of(context).showSnackBar(snackBar);
                        },
                      )
                    ],
                  ),
                  new Container(
                    width: 230.0,
                    height: 230.0,
                    child: new QrImage(
                      version: 20,
                      data: snapshot.data,
                    ),
                  ),
                  new GestureDetector(
                    onTap: () {
                      Share.share(snapshot.data);
                    },
                    child: new Container(
                      child: new Text(
                        snapshot.data,
                        style: theme.bolt11Style,
                      ),
                    ),
                  ),
                  _buildExpiryMessage(),
                ],
              );
            }),
        _buildCloseButton()
      ],
    );
  }

  Widget _buildExpiryMessage() {
    return new Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: Text(
              "Keep the Breez app open in order to receive payment.",
              style: theme.alertStyle))
    ]);
  }

  Widget _buildCloseButton() {
    return new FlatButton(
      onPressed: (() {
        Navigator.pop(context);
      }),
      child: new Text("CANCEL", style: theme.buttonStyle),
    );
  }
}
