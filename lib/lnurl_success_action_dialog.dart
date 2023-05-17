import 'package:breez/services/breezlib/data/rpc.pbgrpc.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/utils/external_browser.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void showLNURLSuccessAction(BuildContext context, SuccessAction sa) {
  final texts = context.texts();

  promptMessage(
    context,
    texts.ln_url_success_action_title,
    SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          sa.description.isNotEmpty !=
                  true // TODO : Null Safety - SuccessAction fields may be null
              ? const SizedBox(
                  height: 0,
                )
              : _TextMessage(
                  description: sa.description,
                ),
          sa.message.isNotEmpty != true
              ? const SizedBox(
                  height: 0,
                )
              : _TextMessage(
                  description: sa.message,
                ),
          sa.url.isNotEmpty != true
              ? const SizedBox(
                  height: 0,
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _URLRow(sharedValue: sa.url),
                ),
        ],
      ),
    ),
  );
}

class _TextMessage extends StatelessWidget {
  final String description;

  const _TextMessage({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        description,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}

class _URLRow extends StatelessWidget {
  final String sharedValue;

  const _URLRow({
    Key? key,
    required this.sharedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    final expansionTileTheme = themeData.copyWith(
      unselectedWidgetColor: themeData.primaryTextTheme.labelLarge!.color,
      colorScheme: ColorScheme.dark(
        secondary: themeData.primaryTextTheme.labelLarge!.color!,
      ),
      dividerColor: themeData.colorScheme.background,
    );
    return Theme(
      data: expansionTileTheme,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.zero,
              child: GestureDetector(
                onTap: () => launchLinkOnExternalBrowser(sharedValue),
                child: Text(
                  sharedValue,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  maxLines: 4,
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 12,
                        color: Colors.blue,
                      ),
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
                    padding: EdgeInsets.zero,
                    iconSize: 16.0,
                    color: themeData.primaryTextTheme.labelLarge!.color,
                    icon: const Icon(
                      IconData(0xe90b, fontFamily: 'icomoon'),
                    ),
                    onPressed: () {
                      ServiceInjector().device.setClipboardText(sharedValue);
                      showFlushbar(
                        context,
                        message: texts.ln_url_success_action_link_copied,
                        duration: const Duration(seconds: 4),
                      );
                    },
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 16.0,
                    color: themeData.primaryTextTheme.labelLarge!.color,
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
    );
  }
}
