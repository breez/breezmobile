import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/compact_qr_image.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_extend/share_extend.dart';

class AddressWidget extends StatelessWidget {
  
  final String address;
  final String backupJson;

  AddressWidget(this.address, this.backupJson);

  @override
  Widget build(
      BuildContext context) {
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
                  children: _buildShareAndCopyIcons(context),
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
                      color: Theme.of(context).accentColor,
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
                      showFlushbar(context, message: "Deposit address was copied to your clipboard.");
                    },
                    child: new Text(
                      address,
                      style: Theme.of(context).primaryTextTheme.subtitle,
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

  List<Widget> _buildShareAndCopyIcons(BuildContext context) {
    List<Widget> _icons = List();
    if (address == null) {
      _icons.add(SizedBox(height: 48.0,));
      return _icons;
    }
    Widget _shareIcon = new IconButton(
      icon: new Icon(IconData(0xe917, fontFamily: 'icomoon')),
      color: Theme.of(context).buttonColor,
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
      color: Theme.of(context).buttonColor,
      onPressed: () {
        Clipboard.setData(new ClipboardData(text: address));
        showFlushbar(context, message: "Deposit address was copied to your clipboard.");
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
            style: Theme.of(context).dialogTheme.contentTextStyle,
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
            child: new Text("OK", style: Theme.of(context).primaryTextTheme.button))
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }
}