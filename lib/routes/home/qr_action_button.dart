import 'dart:async';

import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/invoice/invoice_bloc.dart';
import 'package:clovrlabs_wallet/bloc/lnurl/lnurl_actions.dart';
import 'package:clovrlabs_wallet/bloc/lnurl/lnurl_bloc.dart';
import 'package:clovrlabs_wallet/handlers/lnurl_handler.dart';
import 'package:clovrlabs_wallet/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:clovrlabs_wallet/routes/withdraw_funds/reverse_swap_page.dart';
import 'package:clovrlabs_wallet/services/injector.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/utils/bip21.dart';
import 'package:clovrlabs_wallet/utils/btc_address.dart';
import 'package:clovrlabs_wallet/utils/lnurl.dart';
import 'package:clovrlabs_wallet/utils/node_id.dart';
import 'package:clovrlabs_wallet/widgets/error_dialog.dart';
import 'package:clovrlabs_wallet/widgets/flushbar.dart';
import 'package:clovrlabs_wallet/widgets/loader.dart';
import 'package:clovrlabs_wallet/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final texts = AppLocalizations.of(context);
    final invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    final lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Container(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          onPressed: () async {
            final scannedString = await Navigator.pushNamed<String>(
              context,
              "/qr_scan",
            );
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
                await _handleLNUrl(lnurlBloc, context, scannedString);
                return;
              }

              // lightning address
              final v = parseLightningAddress(scannedString);
              if (v != null) {
                lnurlBloc.lnurlInputSink.add(v);
                return;
              }

              // bip 121
              String lnInvoice = extractBolt11FromBip21(lower);
              if (lnInvoice != null) {
                lower = lnInvoice;
              }

              // regular lightning invoice.
              if (lower.startsWith("lightning:") || lower.startsWith("ln")) {
                invoiceBloc.decodeInvoiceSink.add(scannedString);
                return;
              }

              // bitcoin
              BTCAddressInfo btcInvoice = parseBTCAddress(scannedString);

              if (await _isBTCAddress(btcInvoice.address)) {
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
                _handleWebAddress(context, scannedString);
                return;
              }

              showFlushbar(
                context,
                message: texts.qr_action_button_error_code_not_processed,
              );
            }
          },
          child: SvgPicture.asset(
            "src/icon/qr_scan.svg",
            color: theme.ClovrLabsWalletColors.white[500],
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
    final texts = AppLocalizations.of(context);
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
    final texts = AppLocalizations.of(context);
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
            padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
            child: Text(
              texts.qr_action_button_open_link,
              style: dialogTheme.titleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          content: Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: Container(
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
                    SizedBox(
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
                style: themeData.primaryTextTheme.button,
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
                style: themeData.primaryTextTheme.button,
              ),
              onPressed: () async {
                await launchUrlString(url);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
