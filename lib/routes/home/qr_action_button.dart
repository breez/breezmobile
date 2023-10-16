import 'dart:async';

import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/handlers/lnurl_handler.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:breez/routes/withdraw_funds/reverse_swap_page.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/bip21.dart';
import 'package:breez/utils/btc_address.dart';
import 'package:breez/utils/external_browser.dart';
import 'package:breez/utils/lnurl.dart';
import 'package:breez/utils/node_id.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:validators/validators.dart';

final _log = Logger("QrActionButton");

class QrActionButton extends StatefulWidget {
  final GlobalKey firstPaymentItemKey;

  const QrActionButton(
    this.firstPaymentItemKey,
  );

  @override
  State<QrActionButton> createState() => _QrActionButtonState();
}

class _QrActionButtonState extends State<QrActionButton> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    final lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);
    final profileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          onPressed: () async {
            _log.finest("Start qr code scan");
            final navigator = Navigator.of(context);
            navigator.pushNamed<String>("/qr_scan").then(
              (scannedString) async {
                _log.finest("Scanned string: '$scannedString'");
                if (scannedString != null) {
                  if (scannedString.isEmpty) {
                    showFlushbar(
                      context,
                      message: texts.qr_action_button_error_code_not_detected,
                    );
                    return;
                  }
                  String lower = scannedString.toLowerCase();

                  // lnurl string
                  if (isLNURL(lower)) {
                    _log.finest("Scanned string is a lnurl");
                    await _handleLNUrl(lnurlBloc, scannedString);
                    return;
                  }

                  // lightning address
                  final v = parseLightningAddress(scannedString);
                  if (v != null) {
                    _log.finest("Scanned string is a lightning address");
                    lnurlBloc.lnurlInputSink.add(v);
                    return;
                  }

                  // bip 21
                  String lnInvoice = extractBolt11FromBip21(lower);
                  if (lnInvoice != null) {
                    _log.finest(
                      "Scanned string is a bolt11 extract from bip 21",
                    );
                    lower = lnInvoice;
                  }

                  // regular lightning invoice.
                  if (lower.startsWith("lightning:") ||
                      lower.startsWith("ln")) {
                    _log.finest("Scanned string is a regular lightning invoice");
                    invoiceBloc.decodeInvoiceSink.add(scannedString);
                    return;
                  }

                  // bitcoin
                  BTCAddressInfo btcInvoice = parseBTCAddress(scannedString);

                  if (await _isBTCAddress(btcInvoice.address)) {
                    _log.finest("Scanned string is a bitcoin address");
                    String requestAmount;
                    if (btcInvoice.satAmount != null) {
                      final account =
                          await profileBloc.userStream.take(1).first;
                      requestAmount = account.currency.format(
                        btcInvoice.satAmount,
                        userInput: true,
                        includeDisplayName: false,
                      );
                    }
                    navigator.push(
                      FadeInRoute(
                        builder: (_) => ReverseSwapPage(
                          userAddress: btcInvoice.address,
                          requestAmount: requestAmount,
                        ),
                      ),
                    );
                    return;
                  }

                  var nodeID = parseNodeId(scannedString);
                  if (nodeID != null) {
                    _log.finest("Scanned string is a node id");
                    navigator.push(
                      FadeInRoute(
                        builder: (_) => SpontaneousPaymentPage(
                          nodeID,
                          widget.firstPaymentItemKey,
                        ),
                      ),
                    );
                    return;
                  }

                  // Open on whenever app the system links to
                  if (await canLaunchUrlString(scannedString)) {
                    _log.finest("Scanned string is a launchable url");
                    _handleWebAddress(scannedString);
                    return;
                  }

                  // Open on browser
                  final validUrl = isURL(
                    scannedString,
                    requireProtocol: true,
                    allowUnderscore: true,
                  );
                  if (validUrl) {
                    _log.finest("Scanned string is a valid url");
                    _handleWebAddress(scannedString);
                    return;
                  }

                  _log.finest("Scanned string is unrecognized");
                  showFlushbar(
                    context,
                    message: texts.qr_action_button_error_code_not_processed,
                  );
                }
              },
            );
          },
          child: SvgPicture.asset(
            "src/icon/qr_scan.svg",
            colorFilter: ColorFilter.mode(
              theme.BreezColors.white[500],
              BlendMode.srcATop,
            ),
            fit: BoxFit.contain,
            width: 24.0,
            height: 24.0,
          ),
        ),
      ),
    );
  }

  Future<bool> _isBTCAddress(String scannedString) {
    return ServiceInjector()
        .breezBridge
        .validateAddress(scannedString)
        .then((_) => true)
        .catchError((err) => false);
  }

  Future _handleLNUrl(
    LNUrlBloc lnurlBloc,
    String lnurl,
  ) async {
    final texts = context.texts();
    final fetchAction = Fetch(lnurl);
    final cancelCompleter = Completer();
    final loaderRoute = createLoaderRoute(context, onClose: () {
      cancelCompleter.complete();
    });
    Navigator.of(context).push(loaderRoute);

    lnurlBloc.actionsSink.add(fetchAction);
    await Future.any([
      cancelCompleter.future,
      fetchAction.future,
    ]).then((response) {
      Navigator.of(context).removeRoute(loaderRoute);
      if (cancelCompleter.isCompleted) {
        return;
      }

      LNURLHandler(context, lnurlBloc).executeLNURLResponse(
        context,
        lnurlBloc,
        response,
      );
    }).catchError((err) {
      Navigator.of(context).removeRoute(loaderRoute);
      promptError(
        context,
        texts.qr_action_button_error_link_title,
        Text(
          texts.qr_action_button_error_link_message(err.toString()),
          style: Theme.of(context).dialogTheme.contentTextStyle,
        ),
      );
    });
  }

  void _handleWebAddress(String url) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final dialogTheme = themeData.dialogTheme;
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Container(
            height: 64.0,
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
            child: Text(
              texts.qr_action_button_open_link,
              style: dialogTheme.titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: SizedBox(
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    url,
                    style: dialogTheme.contentTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 0.0,
                    height: 16.0,
                  ),
                  Text(
                    texts.qr_action_button_open_link_confirmation,
                    style: dialogTheme.contentTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>((set) {
                  if (set.contains(MaterialState.pressed)) {
                    return Colors.transparent;
                  }
                  return null;
                }),
              ),
              child: Text(
                texts.qr_action_button_open_link_confirmation_no,
                style: themeData.primaryTextTheme.labelLarge,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>((set) {
                  if (set.contains(MaterialState.pressed)) {
                    return Colors.transparent;
                  }
                  return null;
                }),
              ),
              child: Text(
                texts.qr_action_button_open_link_confirmation_yes,
                style: themeData.primaryTextTheme.labelLarge,
              ),
              onPressed: () async {
                final navigator = Navigator.of(context);
                await launchLinkOnExternalBrowser(url);
                navigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}
