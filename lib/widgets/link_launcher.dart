import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkLauncher extends StatelessWidget {  
  final String linkName;
  final String linkAddress;
  final Function onCopy;

  const LinkLauncher({Key key, this.linkName, this.linkAddress, this.onCopy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: (){
              this.onCopy();
            },
            child: Text(
              '$linkName',
              textAlign: TextAlign.left,
              overflow: TextOverflow.clip,
              maxLines: 4,
            ),
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
                      this.onCopy();
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
