import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_fund_vendor_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/handlers/lnurl_handler.dart';
import 'package:breez/routes/add_funds/fastbitcoins_page.dart';
import 'package:breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:breez/routes/withdraw_funds/reverse_swap_page.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/bip21.dart';
import 'package:breez/utils/fastbitcoin.dart';
import 'package:breez/utils/node_id.dart';
import 'package:breez/utils/qr_scan.dart' as QRScanner;
import 'package:breez/widgets/barcode_scanner_placeholder.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class FloatingActionsBar extends StatelessWidget {
  static const double EXPANDED_ACTIONS_WIDTH = 253.0;
  static const double COLLAPSED_ACTIONS_WIDTH = 147.0;
  static const double TEXT_ACTION_SIZE = 70.0;
  final AccountModel account;
  final double height;
  final double offsetFactor;
  final GlobalKey firstPaymentItemKey;

  FloatingActionsBar(
      this.account, this.height, this.offsetFactor, this.firstPaymentItemKey);

  @override
  Widget build(BuildContext context) {
    bool isSmallView = height < 160;

    return Positioned(
      top: (height - 25.0),
      right: 16.0,
      child: AnimatedContainer(
        width: isSmallView ? COLLAPSED_ACTIONS_WIDTH : EXPANDED_ACTIONS_WIDTH,
        duration: Duration(milliseconds: 150),
        decoration: BoxDecoration(
            color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            borderRadius: BorderRadius.circular(24.0)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 48,
              width: isSmallView
                  ? COLLAPSED_ACTIONS_WIDTH
                  : EXPANDED_ACTIONS_WIDTH,
              child: _buildActionsBar(context, isSmallView),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsBar(BuildContext context, bool minimized) {
    AutoSizeGroup actionsGroup = AutoSizeGroup();
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    LNUrlBloc lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _Action(
                  onPress: () => _showSendOptions(context),
                  group: actionsGroup,
                  text: "SEND",
                  iconAssetPath: "src/icon/send-action.png",
                  minimized: minimized),
              Container(
                alignment: Alignment.center,
                width: minimized ? 50.0 : 75.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _ActionSeparator(),
                    _Action(
                        onPress: () async {
                          try {
                            String scannedString = await QRScanner.scan();
                            if (scannedString != null) {
                              String lower = scannedString.toLowerCase();

                              // lnurl string
                              if (lower.startsWith("lightning:lnurl") ||
                                  lower.startsWith("lnurl")) {
                                await _handleLNUrl(
                                    lnurlBloc, context, scannedString);
                                return;
                              }

                              // bip 121
                              String lnInvoice = extractBolt11FromBip21(lower);
                              if (lnInvoice != null) {
                                lower = lnInvoice;
                              }

                              // regular lightning invoice.
                              if (lower.startsWith("lightning:") ||
                                  lower.startsWith("ln")) {
                                invoiceBloc.decodeInvoiceSink
                                    .add(scannedString);
                                return;
                              }

                              // fast bitcoin
                              if (isFastBitcoinURL(lower)) {
                                Navigator.of(context).push(FadeInRoute(
                                  builder: (_) =>
                                      FastbitcoinsPage(fastBitcoinUrl: lower),
                                ));
                                return;
                              }
                              if (await _isBTCAddress(scannedString)) {
                                Navigator.of(context).push(FadeInRoute(
                                  builder: (_) => ReverseSwapPage(
                                    userAddress: scannedString,
                                  ),
                                ));
                                return;
                              }
                              if (isValidNodeId(scannedString)) {
                                Navigator.of(context).push(FadeInRoute(
                                  builder: (_) => SpontaneousPaymentPage(
                                      scannedString, firstPaymentItemKey),
                                ));
                                return;
                              }
                              showFlushbar(context,
                                  message: "QR code cannot be processed.");
                            }
                          } on PlatformException catch (e) {
                            if (e.code == BarcodeScanner.CameraAccessDenied) {
                              Navigator.of(context).push(FadeInRoute(
                                  builder: (_) => BarcodeScannerPlaceholder(
                                      invoiceBloc, firstPaymentItemKey)));
                            }
                          }
                        },
                        iconAssetPath: "src/icon/qr_scan.png",
                        minimized: minimized),
                    _ActionSeparator(),
                  ],
                ),
              ),
              _Action(
                  onPress: () => _showReceiveOptions(context),
                  group: actionsGroup,
                  text: "RECEIVE",
                  iconAssetPath: "src/icon/receive-action.png",
                  minimized: minimized),
            ]),
      ],
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
      LNUrlBloc lnurlBloc, BuildContext context, String lnurl) async {
    Fetch fetchAction = Fetch(lnurl);
    var cancelCompleter = Completer();
    var loaderRoute = createLoaderRoute(context, onClose: () {
      cancelCompleter.complete();
    });
    Navigator.of(context).push(loaderRoute);

    lnurlBloc.actionsSink.add(fetchAction);
    await Future.any([cancelCompleter.future, fetchAction.future]).then(
      (response) {
        Navigator.of(context).removeRoute(loaderRoute);
        if (cancelCompleter.isCompleted) {
          return;
        }

        executeLNURLResponse(context, lnurlBloc, response);
      },
    ).catchError((err) {
      Navigator.of(context).removeRoute(loaderRoute);
      promptError(
          context,
          "Link Error",
          Text("Failed to process link: " + err.toString(),
              style: Theme.of(context).dialogTheme.contentTextStyle));
    });
  }

  Future _showSendOptions(BuildContext context) async {
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    AccountBloc accBloc = AppBlocsProvider.of<AccountBloc>(context);

    await showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return StreamBuilder<String>(
              stream: Observable.merge([
                invoiceBloc.clipboardInvoiceStream,
                invoiceBloc.clipboardNodeIdStream
              ]),
              builder: (context, snapshot) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 8.0),
                    ListTile(
                      enabled: account.connected && snapshot.data != null,
                      leading: _ActionImage(
                          iconAssetPath: "src/icon/paste.png",
                          enabled: account.connected && snapshot.data != null),
                      title: Text("Paste Invoice or Node ID"),
                      onTap: () async {
                        Navigator.of(context).pop();
                        if (!isValidNodeId(snapshot.data)) {
                          invoiceBloc.decodeInvoiceSink.add(snapshot.data);
                        } else {
                          Navigator.of(context).push(FadeInRoute(
                            builder: (_) => SpontaneousPaymentPage(
                                snapshot.data, firstPaymentItemKey),
                          ));
                        }
                      },
                    ),
                    ListTile(
                        enabled: account.connected,
                        leading: _ActionImage(
                            iconAssetPath: "src/icon/connect_to_pay.png",
                            enabled: account.connected),
                        title: Text("Connect to Pay"),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed("/connect_to_pay");
                        }),
                    ListTile(
                        enabled: account.connected,
                        leading: _ActionImage(
                            iconAssetPath: "src/icon/bitcoin.png",
                            enabled: account.connected),
                        title: Text("Send to BTC Address"),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed("/withdraw_funds");
                        }),
                    StreamBuilder(
                        stream: accBloc.accountSettingsStream,
                        builder: (context, settingsSnapshot) {
                          if (!settingsSnapshot.hasData) {
                            return SizedBox();
                          }
                          AccountSettings settings = settingsSnapshot.data;
                          if (settings.isEscherEnabled) {
                            return ListTile(
                                enabled: account.connected,
                                leading: _ActionImage(
                                    iconAssetPath: "src/icon/escher.png",
                                    enabled: account.connected),
                                title: Text("Cash-Out via Escher"),
                                onTap: () {});
                          } else {
                            return SizedBox();
                          }
                        }),
                    SizedBox(height: 8.0)
                  ],
                );
              });
        });
  }

  Future _showReceiveOptions(BuildContext context) {
    AddFundsBloc addFundsBloc = BlocProvider.of<AddFundsBloc>(context);

    return showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return StreamBuilder<List<AddFundVendorModel>>(
              stream: addFundsBloc.availableVendorsStream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return SizedBox();
                }

                List<Widget> children =
                    snapshot.data.where((v) => v.isAllowed).map((v) {
                  return ListTile(
                      enabled: v.enabled &&
                          (account.connected || !v.requireActiveChannel),
                      leading: _ActionImage(
                          iconAssetPath: v.icon,
                          enabled:
                              account.connected || !v.requireActiveChannel),
                      title: Text(v.shortName ?? v.name),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(v.route);
                      });
                }).toList();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 8.0),
                    ListTile(
                        enabled: account.connected,
                        leading: _ActionImage(
                            iconAssetPath: "src/icon/paste.png",
                            enabled: account.connected),
                        title: Text("Receive via Invoice"),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed("/create_invoice");
                        }),
                    ...children,
                    !account.connected
                        ? SizedBox(height: 8.0)
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0,
                                left: 16.0,
                                right: 16.0,
                                bottom: 16.0),
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 8.0, right: 8.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  border: Border.all(
                                      color: Theme.of(context).errorColor)),
                              child: AutoSizeText(
                                "Breez requires you to keep ${account.currency.format(account.warningMaxChanReserveAmount, removeTrailingZeros: true)} in your balance.",
                                maxLines: 1,
                                maxFontSize: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .fontSize,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .fontSize),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                  ],
                );
              });
        });
  }
}

class _ActionSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 32.0, width: 1.0, color: Colors.white.withOpacity(0.4));
  }
}

class _Action extends StatelessWidget {
  final String text;
  final AutoSizeGroup group;
  final String iconAssetPath;
  final bool minimized;
  final Function() onPress;
  final Alignment minimizedAlignment;

  const _Action({
    Key key,
    this.text,
    this.group,
    this.iconAssetPath,
    this.minimized,
    this.onPress,
    this.minimizedAlignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (minimized || text == null) {
      return IconButton(
        alignment: minimizedAlignment,
        onPressed: this.onPress,
        padding: EdgeInsets.zero,
        icon: Image(
          image: AssetImage(iconAssetPath),
          color: theme.BreezColors.white[500],
          fit: BoxFit.contain,
          width: 24.0,
          height: 24.0,
        ),
      );
    }

    return Container(
      width: FloatingActionsBar.TEXT_ACTION_SIZE,
      //decoration: BoxDecoration(color: Colors.red),
      child: FlatButton(
        padding: EdgeInsets.zero,
        onPressed: this.onPress,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.addFundsBtnStyle.copyWith(
              fontSize: 12.3 / MediaQuery.of(context).textScaleFactor),
          maxLines: 1,
        ),
      ),
    );
  }
}

class _ActionImage extends StatelessWidget {
  final String iconAssetPath;
  final bool enabled;

  const _ActionImage({Key key, this.iconAssetPath, this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(iconAssetPath),
      color: enabled
          ? DefaultTextStyle.of(context).style.color
          : Theme.of(context).disabledColor,
      fit: BoxFit.contain,
      width: 24.0,
      height: 24.0,
    );
  }
}
