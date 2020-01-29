import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_fund_vendor_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/barcode_scanner_placeholder.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez/utils/qr_scan.dart' as QRScanner;

class FloatingActionsBar extends StatelessWidget {
  static const double EXPANDED_ACTIONS_WIDTH = 253.0;
  static const double COLLAPSED_ACTIONS_WIDTH = 147.0;
  static const double TEXT_ACTION_SIZE = 70.0;
  final AccountModel account;
  final double height;
  final double offsetFactor;

  FloatingActionsBar(this.account, this.height, this.offsetFactor);

  @override
  Widget build(BuildContext context) {
    bool isSmallView = height < 160;

    return Positioned(
      top: (height - 25.0),
      right: 16.0,
      child: AnimatedContainer(
        width: isSmallView ? COLLAPSED_ACTIONS_WIDTH : EXPANDED_ACTIONS_WIDTH,
        duration: Duration(milliseconds: 150),
        decoration: new BoxDecoration(
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
                            String decodedQr = await QRScanner.scan();
                            invoiceBloc.decodeInvoiceSink.add(decodedQr);
                          } on PlatformException catch (e) {
                            if (e.code == BarcodeScanner.CameraAccessDenied) {
                              Navigator.of(context).push(FadeInRoute(
                                  builder: (_) =>
                                      BarcodeScannerPlaceholder(invoiceBloc)));
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

  Future _showSendOptions(BuildContext context) {
    InvoiceBloc invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    return showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                enabled: account.connected,
                leading: _ActionImage(
                    iconAssetPath: "src/icon/paste.png",
                    enabled: account.connected),
                title: Text("PASTE INVOICE"),
                onTap: () async {
                  Navigator.of(context).pop();
                  var data = await Clipboard.getData(Clipboard.kTextPlain);
                  invoiceBloc.decodeInvoiceSink.add(data.text);
                },
              ),
              ListTile(
                  enabled: account.connected,
                  leading: _ActionImage(
                      iconAssetPath: "src/icon/connect_to_pay.png",
                      enabled: account.connected),
                  title: Text("CONNECT TO PAY"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("/connect_to_pay");
                  }),
              ListTile(
                  enabled: account.connected,
                  leading: _ActionImage(
                      iconAssetPath: "src/icon/bitcoin.png",
                      enabled: account.connected),
                  title: Text("SEND TO BTC ADDRESS"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("/withdraw_funds");
                  }),
            ],
          );
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
                      enabled: account.connected || !v.requireActiveChannel,
                      leading: _ActionImage(
                          iconAssetPath: v.icon,
                          enabled:
                              account.connected || !v.requireActiveChannel),
                      title: Text(v.name.toUpperCase()),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(v.route);
                      }) as Widget;
                }).toList();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        enabled: account.connected,
                        leading: _ActionImage(
                            iconAssetPath: "src/icon/paste.png",
                            enabled: account.connected),
                        title: Text("RECEIVE VIA INVOICE"),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed("/create_invoice");
                        }),
                    ...children,
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 36.0, left: 16.0, right: 16.0, bottom: 16.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                                color: Theme.of(context).errorColor)),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Breez requires you to keep\n${account.currency.format(account.warningMaxChanReserveAmount, fixedDecimals: false)} in your balance.",
                          style: Theme.of(context).textTheme.caption,
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
        child: AutoSizeText(
          text,
          group: group,
          textAlign: TextAlign.center,
          style: theme.addFundsBtnStyle,
          maxLines: 1,
          minFontSize: MinFontSize(context).minFontSize,
          stepGranularity: 0.1,
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
