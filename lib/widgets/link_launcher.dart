import 'package:breez/utils/external_browser.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class LinkLauncher extends StatelessWidget {
  final double iconSize;
  final TextStyle textStyle;
  final String linkTitle;
  final String linkName;
  final String linkAddress;
  final Function onCopy;

  const LinkLauncher({
    Key key,
    this.linkName,
    this.linkAddress,
    this.onCopy,
    this.textStyle,
    this.linkTitle,
    this.iconSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final style = textStyle ?? DefaultTextStyle.of(context).style;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                linkTitle ?? texts.link_launcher_title,
                textAlign: TextAlign.start,
                style: textStyle,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerRight,
                      iconSize: iconSize,
                      color: style.color,
                      icon: const Icon(Icons.launch),
                      onPressed: () => launchLinkOnExternalBrowser(linkAddress),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: GestureDetector(
                  onTap: onCopy,
                  child: Text(
                    linkName ?? texts.link_launcher_link_name,
                    style: style,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.clip,
                    maxLines: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
