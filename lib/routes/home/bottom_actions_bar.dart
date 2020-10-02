import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_fund_vendor_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/enter_payment_info_dialog.dart';
import 'package:breez/widgets/escher_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

class BottomActionsBar extends StatelessWidget {
  final AccountModel account;
  final GlobalKey firstPaymentItemKey;

  BottomActionsBar(this.account, this.firstPaymentItemKey);

  @override
  Widget build(BuildContext context) {
    AutoSizeGroup actionsGroup = AutoSizeGroup();
    return BottomAppBar(
      child: Container(
        height: 60,
        color: theme.themeId == "BLUE" ? Color(0xff0085FB) : Color(0xff4D88EC),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _Action(
              onPress: () => _showSendOptions(context),
              group: actionsGroup,
              text: "SEND",
              iconAssetPath: "src/icon/send-action.png",
            ),
            Container(
              width: 64,
            ),
            _Action(
              onPress: () => _showReceiveOptions(context),
              group: actionsGroup,
              text: "RECEIVE",
              iconAssetPath: "src/icon/receive-action.png",
            ),
          ],
        ),
      ),
    );
  }

  Future _showSendOptions(BuildContext context) async {
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    AccountBloc accBloc = AppBlocsProvider.of<AccountBloc>(context);

    await showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return StreamBuilder<Future<DecodedClipboardData>>(
              stream: invoiceBloc.decodedClipboardStream,
              builder: (context, snapshot) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 8.0),
                    ListTile(
                      enabled: account.connected,
                      leading: _ActionImage(
                          iconAssetPath: "src/icon/paste.png",
                          enabled: account.connected),
                      title: Text("Paste Invoice or Node ID"),
                      onTap: () async {
                        Navigator.of(context).pop();
                        DecodedClipboardData clipboardData =
                            await snapshot.data;
                        if (clipboardData != null) {
                          if (clipboardData.type == "invoice") {
                            invoiceBloc.decodeInvoiceSink
                                .add(clipboardData.data);
                          } else if (clipboardData.type == "nodeID") {
                            Navigator.of(context).push(FadeInRoute(
                              builder: (_) => SpontaneousPaymentPage(
                                  clipboardData.data, firstPaymentItemKey),
                            ));
                          }
                        } else {
                          return showDialog(
                              useRootNavigator: false,
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => EnterPaymentInfoDialog(
                                  context, invoiceBloc, firstPaymentItemKey));
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
                                onTap: () {
                                  Navigator.pop(context);
                                  return showDialog(
                                      useRootNavigator: false,
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) =>
                                          EscherDialog(context, accBloc));
                                });
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

class _Action extends StatelessWidget {
  final String text;
  final AutoSizeGroup group;
  final String iconAssetPath;
  final Function() onPress;
  final Alignment minimizedAlignment;

  const _Action({
    Key key,
    this.text,
    this.group,
    this.iconAssetPath,
    this.onPress,
    this.minimizedAlignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        height: 60,
        padding: EdgeInsets.zero,
        onPressed: this.onPress,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.bottomAppBarBtnStyle.copyWith(
              fontSize: 13.5 / MediaQuery.of(context).textScaleFactor),
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
