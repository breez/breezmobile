import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkLauncher extends StatelessWidget {
  final double iconSize;
  final TextStyle textStyle;
  final String linkTitle;
  final String linkName;
  final String linkAddress;
  final Function onCopy;

  const LinkLauncher(
      {Key key,
      this.linkName,
      this.linkAddress,
      this.onCopy,
      this.textStyle,
      this.linkTitle,
      this.iconSize = 16.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = DefaultTextStyle.of(context).style;
    if (this.textStyle != null) {
      style = this.textStyle;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Text("Transaction ID:",
                      textAlign: TextAlign.start, style: textStyle)),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerRight,
                          iconSize: this.iconSize,
                          color: style.color,
                          icon: Icon(Icons.launch),
                          onPressed: () {
                            launch(linkAddress);
                          },
                        ),
                      ],
                    )),
              ),
            ]),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: GestureDetector(
                  onTap: () {
                    this.onCopy();
                  },
                  child: Text(
                    '$linkName',
                    style: style,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    maxLines: 4,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
