import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/compact_qr_image.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_extend/share_extend.dart';

class AddressWidget extends StatelessWidget {
  final String address;
  final String backupJson;

  AddressWidget(
    this.address,
    this.backupJson,
  );

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                texts.invoice_btc_address_deposit_address,
                style: theme.FieldTextStyle.labelStyle,
              ),
              Container(
                child: Row(
                  children: _buildShareAndCopyIcons(context),
                ),
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
                        data: "bitcoin:" + address,
                        size: 180.0,
                      ),
                    ),
                    onLongPress: () => _showAlertDialog(context),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        ServiceInjector().device.setClipboardText(address);
                        showFlushbar(
                          context,
                          message:
                              texts.invoice_btc_address_deposit_address_copied,
                        );
                      },
                      child: Text(
                        address,
                        style: themeData.primaryTextTheme.subtitle2,
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildQRPlaceholder() {
    return Container(
      width: 188.6,
      height: 188.6,
      margin: const EdgeInsets.only(top: 32.0, bottom: 16.0),
      padding: const EdgeInsets.all(8.6),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  List<Widget> _buildShareAndCopyIcons(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    List<Widget> _icons = [];
    if (address == null) {
      _icons.add(SizedBox(
        height: 48.0,
      ));
      return _icons;
    }
    Widget _shareIcon = IconButton(
      icon: Icon(IconData(0xe917, fontFamily: 'icomoon')),
      onPressed: () {
        final RenderBox box = context.findRenderObject();
        ShareExtend.share(
          address,
          "text",
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
        );
      },
    );
    Widget _copyIcon = IconButton(
      icon: Icon(IconData(0xe90b, fontFamily: 'icomoon')),
      onPressed: () {
        ServiceInjector().device.setClipboardText(address);
        showFlushbar(
          context,
          message: texts.invoice_btc_address_deposit_address_copied,
        );
      },
    );
    _icons.add(_shareIcon);
    _icons.add(_copyIcon);
    return _icons;
  }

  void _showAlertDialog(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    AlertDialog dialog = AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 4.0),
      content: RichText(
        text: TextSpan(
          style: themeData.dialogTheme.contentTextStyle,
          text: texts.invoice_btc_address_on_chain_begin,
          children: [
            TextSpan(
              text: texts.invoice_btc_address_on_chain_here,
              style: TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  final RenderBox box = context.findRenderObject();
                  ShareExtend.share(
                    backupJson,
                    "text",
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size,
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
            style: themeData.primaryTextTheme.button,
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
