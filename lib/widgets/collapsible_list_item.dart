import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/utils/build_context.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

import 'flushbar.dart';

class CollapsibleListItem extends StatelessWidget {
  final String title;
  final String sharedValue;
  final AutoSizeGroup labelGroup;
  final TextStyle userStyle;

  const CollapsibleListItem({
    Key key,
    this.title,
    this.sharedValue,
    this.labelGroup,
    this.userStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    TextTheme textTheme = context.textTheme;

    return ListTileTheme(
      contentPadding: EdgeInsets.zero,
      textColor: userStyle.color,
      iconColor: userStyle.color,
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: userStyle.color,
          collapsedIconColor: userStyle.color,
          title: AutoSizeText(
            title,
            style: textTheme.headline4.merge(userStyle),
            maxLines: 1,
            group: labelGroup,
          ),
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 0.0),
                    child: Text(
                      sharedValue ?? l10n.collapsible_list_default_value,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      maxLines: 4,
                      style: textTheme.headline3
                          .copyWith(fontSize: 10)
                          .merge(userStyle),
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 8.0),
                          tooltip: l10n.collapsible_list_action_copy(title),
                          iconSize: 16.0,
                          color: userStyle.color ?? textTheme.button.color,
                          icon: Icon(
                            IconData(0xe90b, fontFamily: 'icomoon'),
                          ),
                          onPressed: () {
                            ServiceInjector()
                                .device
                                .setClipboardText(sharedValue);
                            context.pop();
                            showFlushbar(
                              context,
                              message: l10n.collapsible_list_copied(title),
                              duration: Duration(seconds: 4),
                            );
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.only(right: 8.0),
                          iconSize: 16.0,
                          color: userStyle.color ?? textTheme.button.color,
                          icon: Icon(Icons.share),
                          onPressed: () {
                            ShareExtend.share(sharedValue, "text");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
