import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkLauncher extends StatelessWidget {
  final String linkName;
  final String linkAddress;

  const LinkLauncher({Key key, this.linkName, this.linkAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            '$linkName',
            textAlign: TextAlign.left,
            overflow: TextOverflow.clip,
            maxLines: 4,
          ),
        ),
        Expanded(
          flex: 0,
          child: Padding(
              padding: EdgeInsets.zero,
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[                  
                  IconButton(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.zero,
                    iconSize: 16.0,
                    color: Colors.white,
                    icon: Icon(
                      IconData(0xe90b, fontFamily: 'icomoon'),
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: linkName));
                      showFlushbar(context,
                          message:
                              "Transaction ID was copied to your clipboard.",
                          duration: Duration(seconds: 3));
                    },
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 16.0,
                    color: Colors.white,
                    icon: Icon(Icons.launch),
                    onPressed: () {
                      launch(linkAddress);
                    },
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
