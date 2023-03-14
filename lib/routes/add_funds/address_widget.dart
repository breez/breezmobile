import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/compact_qr_image.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:share_plus/share_plus.dart';

class AddressWidget extends StatelessWidget {
  final String address;
  final String backupJson;

  const AddressWidget(
    this.address,
    this.backupJson,
  );

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  texts.invoice_btc_address_deposit_address,
                  style: theme.FieldTextStyle.labelStyle,
                ),
                Row(
                  children: _buildShareAndCopyIcons(context),
                ),
              ],
            ),
          ),
          address == null
              ? _buildQRPlaceholder()
              : Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        margin: const EdgeInsets.only(top: 32.0, bottom: 16.0),
                        padding: const EdgeInsets.all(8.6),
                        child: CompactQRImage(
                          data: "bitcoin:$address",
                          size: 180.0,
                        ),
                      ),
                      onLongPress: () => _showAlertDialog(context),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          ServiceInjector().device.setClipboardText(address);
                          showFlushbar(
                            context,
                            message: texts
                                .invoice_btc_address_deposit_address_copied,
                          );
                        },
                        child: Text(
                          address,
                          style: themeData.primaryTextTheme.titleSmall,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildQRPlaceholder() {
    return Container(
      width: 188.6,
      height: 188.6,
      margin: const EdgeInsets.only(top: 32.0, bottom: 16.0),
      padding: const EdgeInsets.all(8.6),
      child: const Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  List<Widget> _buildShareAndCopyIcons(BuildContext context) {
    final texts = context.texts();

    List<Widget> icons = [];
    if (address == null) {
      icons.add(const SizedBox(
        height: 48.0,
      ));
      return icons;
    }
    Widget shareIcon = IconButton(
      icon: const Icon(IconData(0xe917, fontFamily: 'icomoon')),
      onPressed: () {
        final RenderBox box = context.findRenderObject();
        final offset = box.localToGlobal(Offset.zero) & box.size;
        final rect = Rect.fromPoints(
          offset.topLeft,
          offset.bottomRight,
        );
        Share.share(
          address,
          sharePositionOrigin: rect,
        );
      },
    );
    Widget copyIcon = IconButton(
      icon: const Icon(IconData(0xe90b, fontFamily: 'icomoon')),
      onPressed: () {
        ServiceInjector().device.setClipboardText(address);
        showFlushbar(
          context,
          message: texts.invoice_btc_address_deposit_address_copied,
        );
      },
    );
    icons.add(shareIcon);
    icons.add(copyIcon);
    return icons;
  }

  void _showAlertDialog(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    AlertDialog dialog = AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 4.0),
      content: RichText(
        text: TextSpan(
          style: themeData.dialogTheme.contentTextStyle,
          text: texts.invoice_btc_address_on_chain_begin,
          children: [
            TextSpan(
              text: texts.invoice_btc_address_on_chain_here,
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  final RenderBox box = context.findRenderObject();
                  final offset = box.localToGlobal(Offset.zero) & box.size;
                  final rect = Rect.fromPoints(
                    offset.topLeft,
                    offset.bottomRight,
                  );
                  Share.share(
                    backupJson,
                    sharePositionOrigin: rect,
                  );
                },
            ),
            TextSpan(
              text: texts.invoice_btc_address_on_chain_end,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            texts.invoice_btc_address_on_chain_action_ok,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
      ],
    );
    showDialog(
      useRootNavigator: false,
      context: context,
      builder: (_) => dialog,
    );
  }
}
