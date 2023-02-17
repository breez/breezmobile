import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/utils/external_browser.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareablePaymentRow extends StatelessWidget {
  final String title;
  final String sharedValue;
  final AutoSizeGroup labelAutoSizeGroup;
  final AutoSizeGroup valueAutoSizeGroup;
  final bool isTxID;

  const ShareablePaymentRow({
    Key key,
    this.title,
    this.sharedValue,
    this.labelAutoSizeGroup,
    this.valueAutoSizeGroup,
    this.isTxID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Theme(
      data: themeData.copyWith(
        dividerColor: themeData.colorScheme.background,
      ),
      child: ExpansionTile(
        iconColor: themeData.primaryTextTheme.labelLarge.color,
        collapsedIconColor: themeData.primaryTextTheme.labelLarge.color,
        title: AutoSizeText(
          title,
          style: themeData.primaryTextTheme.headlineMedium,
          maxLines: 1,
          group: labelAutoSizeGroup,
        ),
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 0.0),
                  child: GestureDetector(
                    onTap: () => isTxID
                        ? launchLinkOnExternalBrowser(
                            "https://blockstream.info/tx/$sharedValue")
                        : null,
                    child: Text(
                      sharedValue,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      maxLines: 4,
                      style: themeData.primaryTextTheme.displaySmall
                          .copyWith(fontSize: 10),
                    ),
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
                        tooltip:
                            texts.payment_details_dialog_copy_action(title),
                        iconSize: 16.0,
                        color: themeData.primaryTextTheme.labelLarge.color,
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
                            message: texts.payment_details_dialog_copied(title),
                            duration: const Duration(seconds: 4),
                          );
                        },
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(right: 8.0),
                        tooltip: texts.payment_details_dialog_share_transaction,
                        iconSize: 16.0,
                        color: themeData.primaryTextTheme.labelLarge.color,
                        icon: const Icon(Icons.share),
                        onPressed: () => Share.share(sharedValue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
