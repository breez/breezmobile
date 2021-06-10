import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/material.dart';
import 'package:breez/utils/i18n.dart';
import 'package:share_extend/share_extend.dart';

import 'flushbar.dart';

class CollapsibleListItem extends StatelessWidget {
  final String title;
  final String sharedValue;
  final AutoSizeGroup labelGroup;
  final TextStyle userStyle;

  const CollapsibleListItem(
      {Key key, this.title, this.sharedValue, this.labelGroup, this.userStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      contentPadding: EdgeInsets.zero,
      textColor: this.userStyle.color,
      iconColor: this.userStyle.color,
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          unselectedWidgetColor: this.userStyle.color,
          colorScheme: ColorScheme.dark(secondary: this.userStyle.color),
        ),
        child: ExpansionTile(
            title: AutoSizeText(
              title,
              style:
                  Theme.of(context).primaryTextTheme.headline4.merge(userStyle),
              maxLines: 1,
              group: labelGroup,
            ),
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 0.0),
                      child: Text('$sharedValue',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                          maxLines: 4,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline3
                              .copyWith(fontSize: 10)
                              .merge(userStyle)),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Padding(
                        padding: EdgeInsets.zero,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 8.0),
                              tooltip: I18N.t(context, "copy_text",
                                  translationParams: {"text": title}),
                              iconSize: 16.0,
                              color: this.userStyle.color ??
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .button
                                      .color,
                              icon: Icon(
                                IconData(0xe90b, fontFamily: 'icomoon'),
                              ),
                              onPressed: () {
                                ServiceInjector()
                                    .device
                                    .setClipboardText(sharedValue);
                                Navigator.pop(context);
                                showFlushbar(context,
                                    message: I18N.t(context,
                                        "text_was_copied_to_your_clipboard",
                                        translationParams: {"text": title}),
                                    duration: Duration(seconds: 4));
                              },
                            ),
                            IconButton(
                              padding: EdgeInsets.only(right: 8.0),
                              iconSize: 16.0,
                              color: this.userStyle.color ??
                                  Theme.of(context)
                                      .primaryTextTheme
                                      .button
                                      .color,
                              icon: Icon(Icons.share),
                              onPressed: () {
                                ShareExtend.share(sharedValue, "text");
                              },
                            ),
                          ],
                        )),
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
