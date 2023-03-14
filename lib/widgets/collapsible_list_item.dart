import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:share_plus/share_plus.dart';

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
    final themeData = Theme.of(context);
    final texts = context.texts();
    final textTheme = themeData.primaryTextTheme;

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
            style: textTheme.headlineMedium.merge(userStyle),
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
                    padding: const EdgeInsets.only(left: 16.0, right: 0.0),
                    child: Text(
                      sharedValue ?? texts.collapsible_list_default_value,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      maxLines: 4,
                      style: textTheme.displaySmall
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
                          padding: const EdgeInsets.only(right: 8.0),
                          tooltip: texts.collapsible_list_action_copy(title),
                          iconSize: 16.0,
                          color: userStyle.color ?? textTheme.labelLarge.color,
                          icon: const Icon(
                            IconData(0xe90b, fontFamily: 'icomoon'),
                          ),
                          onPressed: () {
                            ServiceInjector()
                                .device
                                .setClipboardText(sharedValue);
                            Navigator.pop(context);
                            showFlushbar(
                              context,
                              message: texts.collapsible_list_copied(title),
                              duration: const Duration(seconds: 4),
                            );
                          },
                        ),
                        IconButton(
                          padding: const EdgeInsets.only(right: 8.0),
                          iconSize: 16.0,
                          color: userStyle.color ?? textTheme.labelLarge.color,
                          icon: const Icon(Icons.share),
                          onPressed: () {
                            Share.share(sharedValue);
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
