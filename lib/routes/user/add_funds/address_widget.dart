import 'package:breez/widgets/compact_qr_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:share_extend/share_extend.dart';

class AddressWidget extends StatelessWidget {
  
  final String address;
  final String backupJson;

  AddressWidget(this.address, this.backupJson);

  @override
  Widget build(
      BuildContext context) {
    final snackBar = new SnackBar(
      content: new Text(
        'Deposit address was copied to your clipboard.',
        style: theme.snackBarStyle,
      ),
      backgroundColor: theme.snackBarBackgroundColor,
      duration: new Duration(seconds: 4),
    );

    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                "Deposit Address",
                style: theme.FieldTextStyle.labelStyle,
              ),
              new Container(
                child: Row(
                  children: _buildShareAndCopyIcons(context, snackBar),
                ),
              ),
            ],
          ),
        ),
        address == null
            ? _buildQRPlaceholder()
            : new Column(children: <Widget>[
                new GestureDetector(
                  child: new Container(
                    margin: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                    padding: const EdgeInsets.all(8.6),
                    decoration: theme.qrImageStyle,
                    child: new Container(
                      color: theme.whiteColor,
                      child: new CompactQRImage(
                        data: "bitcoin:" + address,
                        size: 180.0,
                      ),
                    ),
                  ),
                  onLongPress: () => _showAlertDialog(context),
                ),
                new Container(
                  padding: EdgeInsets.only(top: 16.0),
                  child: new GestureDetector(
                    onTap: () {
                      Clipboard.setData(new ClipboardData(text: address));
                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    child: new Text(
                      address,
                      style: theme.smallTextStyle,
                    ),
                  ),
                ),
              ])
      ],
    );
  }

  Widget _buildQRPlaceholder() {
    return Container(
      width: 188.6,
      height: 188.6,
      margin: const EdgeInsets.only(top: 32.0, bottom: 16.0),
      padding: const EdgeInsets.all(8.6),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  List<Widget> _buildShareAndCopyIcons(BuildContext context, SnackBar snackBar) {
    List<Widget> _icons = List();
    if (address == null) {
      _icons.add(SizedBox(height: 48.0,));
      return _icons;
    }
    Widget _shareIcon = new IconButton(
      icon: new Icon(IconData(0xe917, fontFamily: 'icomoon')),
      color: theme.whiteColor,
      onPressed: () {
        final RenderBox box = context.findRenderObject();
        ShareExtend.share(address,
            "text",
            sharePositionOrigin:
            box.localToGlobal(Offset.zero) & box.size);
      },
    );
    Widget _copyIcon = new IconButton(
      icon: new Icon(IconData(0xe90b, fontFamily: 'icomoon')),
      color: theme.whiteColor,
      onPressed: () {
        Clipboard.setData(new ClipboardData(text: address));
        Scaffold.of(context).showSnackBar(snackBar);
      },
    );
    _icons.add(_shareIcon);
    _icons.add(_copyIcon);
    return _icons;
  }

  void _showAlertDialog(BuildContext context) {
    AlertDialog dialog = new AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(20.0,20.0,20.0,4.0),
      content: RichText(
        text: TextSpan(
            style: theme.alertStyle,
            text: "Breez is using Submarine Swaps to execute on-chain transactions. Click ",
            children: <TextSpan>[
              TextSpan(
                text: "here",
                style: TextStyle(color: Colors.blue),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    final RenderBox box = context.findRenderObject();
                    ShareExtend.share(backupJson, "text", sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                  },
              ),
              TextSpan(text: " to view the script associated with this address.")
            ]),
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text("OK", style: theme.buttonStyle))
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
    );
    showDialog(context: context, builder: (_) => dialog);
  }
}