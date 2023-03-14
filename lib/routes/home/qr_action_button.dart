import 'dart:async';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
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
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:validators/validators.dart';

class QrActionButton extends StatelessWidget {
  final AccountModel account;
  final GlobalKey firstPaymentItemKey;

  const QrActionButton(
    this.account,
    this.firstPaymentItemKey,
  );

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    final lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          onPressed: () async {
            log.finest("Start qr code scan");
            final scannedString = await Navigator.pushNamed<String>(
              context,
              "/qr_scan",
            );
            log.finest("Scanned string: '$scannedString'");
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
                log.finest("Scanned string is a lnurl");
                await _handleLNUrl(lnurlBloc, context, scannedString);
                return;
              }

              // lightning address
              final v = parseLightningAddress(scannedString);
              if (v != null) {
                log.finest("Scanned string is a lightning address");
                lnurlBloc.lnurlInputSink.add(v);
                return;
              }

              // bip 121
              String lnInvoice = extractBolt11FromBip21(lower);
              if (lnInvoice != null) {
                log.finest("Scanned string is a bolt11 extract from bip 21");
                lower = lnInvoice;
              }

              // regular lightning invoice.
              if (lower.startsWith("lightning:") || lower.startsWith("ln")) {
                log.finest("Scanned string is a regular lightning invoice");
                invoiceBloc.decodeInvoiceSink.add(scannedString);
                return;
              }

              // bitcoin
              BTCAddressInfo btcInvoice = parseBTCAddress(scannedString);

              if (await _isBTCAddress(btcInvoice.address)) {
                log.finest("Scanned string is a bitcoin address");
                String requestAmount;
                if (btcInvoice.satAmount != null) {
                  requestAmount = account.currency.format(
                    btcInvoice.satAmount,
                    userInput: true,
                    includeDisplayName: false,
                    removeTrailingZeros: true,
                  );
                }
                Navigator.of(context).push(FadeInRoute(
                  builder: (_) => ReverseSwapPage(
                    userAddress: btcInvoice.address,
                    requestAmount: requestAmount,
                  ),
                ));
                return;
              }

              var nodeID = parseNodeId(scannedString);
              if (nodeID != null) {
                log.finest("Scanned string is a node id");
                Navigator.of(context).push(FadeInRoute(
                  builder: (_) => SpontaneousPaymentPage(
                    nodeID,
                    firstPaymentItemKey,
                  ),
                ));
                return;
              }

              // Open on whenever app the system links to
              if (await canLaunchUrlString(scannedString)) {
                log.finest("Scanned string is a launchable url");
                _handleWebAddress(context, scannedString);
                return;
              }

              // Open on browser
              final validUrl = isURL(
                scannedString,
                requireProtocol: true,
                allowUnderscore: true,
              );
              if (validUrl) {
                log.finest("Scanned string is a valid url");
                _handleWebAddress(context, scannedString);
                return;
              }

              log.finest("Scanned string is unrecognized");
              showFlushbar(
                context,
                message: texts.qr_action_button_error_code_not_processed,
              );
            }
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
    BuildContext context,
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

  void _handleWebAddress(BuildContext context, String url) {
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
                await launchLinkOnExternalBrowser(url);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
