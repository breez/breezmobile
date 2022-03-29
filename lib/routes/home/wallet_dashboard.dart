import 'dart:math';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WalletDashboard extends StatefulWidget {
  final AccountModel _accountModel;
  final BreezUserModel _userModel;
  final double _height;
  final double _offsetFactor;
  final Function(Currency currency) _onCurrencyChange;
  final Function(String fiatConversion) _onFiatCurrencyChange;
  final Function(bool hideBalance) _onPrivacyChange;

  const WalletDashboard(
    this._userModel,
    this._accountModel,
    this._height,
    this._offsetFactor,
    this._onCurrencyChange,
    this._onFiatCurrencyChange,
    this._onPrivacyChange,
  );

  @override
  State<StatefulWidget> createState() {
    return WalletDashboardState();
  }
}

class WalletDashboardState extends State<WalletDashboard> {
  static const BALANCE_OFFSET_TRANSITION = 60.0;
  bool _showFiatCurrency = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final headline4 = themeData.accentTextTheme.headline4;

    double startHeaderSize = headline4.fontSize;
    double endHeaderFontSize = headline4.fontSize - 8.0;

    return GestureDetector(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: widget._height,
            decoration: BoxDecoration(
              color: theme.customData[theme.themeId].dashboardBgColor,
            ),
          ),
          Positioned(
            top: 60 - BALANCE_OFFSET_TRANSITION * widget._offsetFactor,
            child: Center(
              child:
                  widget._accountModel != null && !widget._accountModel.initial
                      ? TextButton(
                          style: _balanceStyle(),
                          onPressed: () {
                            if (widget._userModel.hideBalance) {
                              widget._onPrivacyChange(false);
                              return;
                            }
                            final list = Currency.currencies;
                            final index = list.indexOf(
                              widget._accountModel.currency,
                            );
                            final nextCurrencyIndex = (index + 1) % list.length;
                            if (nextCurrencyIndex == 1) {
                              widget._onPrivacyChange(true);
                            }
                            widget._onCurrencyChange(
                              list[nextCurrencyIndex],
                            );
                          },
                          child: widget._userModel.hideBalance
                              ? _balanceHide(
                                  context,
                                  startHeaderSize,
                                  endHeaderFontSize,
                                )
                              : (widget._offsetFactor > 0.8 &&
                                      _showFiatCurrency &&
                                      widget._accountModel.fiatCurrency != null)
                                  ? _balanceText(
                                      context,
                                      startHeaderSize,
                                      endHeaderFontSize,
                                    )
                                  : _balanceRichText(
                                      context,
                                      startHeaderSize,
                                      endHeaderFontSize,
                                    ),
                        )
                      : SizedBox(),
            ),
          ),
          Positioned(
            top: 100 - BALANCE_OFFSET_TRANSITION * widget._offsetFactor,
            child: Center(
              child: widget._accountModel != null &&
                      !widget._accountModel.initial &&
                      widget._accountModel.fiatConversionList.isNotEmpty &&
                      isAboveMinAmount(widget._accountModel?.fiatCurrency) &&
                      !widget._userModel.hideBalance
                  ? _fiatButton(context)
                  : SizedBox(),
            ),
          ),
        ],
      ),
      behavior: HitTestBehavior.translucent,
      onLongPressStart: (_) {
        setState(() {
          _showFiatCurrency = true;
        });
      },
      onLongPressEnd: (_) {
        setState(() {
          _showFiatCurrency = false;
        });
      },
    );
  }

  ButtonStyle _balanceStyle() {
    return ButtonStyle(
      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        final customData = theme.customData[theme.themeId];
        if (states.contains(MaterialState.focused)) {
          return customData.paymentListBgColor;
        }
        if (states.contains(MaterialState.hovered)) {
          return customData.paymentListBgColor;
        }
        return null;
      }),
    );
  }

  Widget _balanceText(
    BuildContext context,
    double startHeaderSize,
    double endHeaderFontSize,
  ) {
    final themeData = Theme.of(context);

    return Text(
      "${widget._accountModel.formattedFiatBalance}",
      style: themeData.accentTextTheme.headline4.copyWith(
        fontSize: startHeaderSize -
            (startHeaderSize - endHeaderFontSize) * widget._offsetFactor,
      ),
    );
  }

  Widget _balanceRichText(
    BuildContext context,
    double startHeaderSize,
    double endHeaderFontSize,
  ) {
    final themeData = Theme.of(context);
    final headline4 = themeData.accentTextTheme.headline4;

    return RichText(
      text: TextSpan(
        style: headline4.copyWith(
          fontSize: startHeaderSize -
              (startHeaderSize - endHeaderFontSize) * widget._offsetFactor,
        ),
        text: widget._accountModel.currency.format(
          widget._accountModel.balance,
          removeTrailingZeros: true,
          includeDisplayName: false,
        ),
        children: [
          TextSpan(
            text: widget._accountModel.currency.displayName,
            style: headline4.copyWith(
              fontSize: startHeaderSize * 0.6 -
                  (startHeaderSize * 0.6 - endHeaderFontSize) *
                      widget._offsetFactor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _balanceHide(
    BuildContext context,
    double startHeaderSize,
    double endHeaderFontSize,
  ) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    return Text(
      texts.wallet_dashboard_balance_hide,
      style: themeData.accentTextTheme.headline4.copyWith(
        fontSize: startHeaderSize -
            (startHeaderSize - endHeaderFontSize) * widget._offsetFactor,
      ),
    );
  }

  Widget _fiatButton(BuildContext context) {
    final themeData = Theme.of(context);
    final subtitle1 = themeData.accentTextTheme.subtitle1;

    return TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
          final customData = theme.customData[theme.themeId];
          if (states.contains(MaterialState.focused)) {
            return customData.paymentListBgColor;
          }
          if (states.contains(MaterialState.hovered)) {
            return customData.paymentListBgColor;
          }
          return null;
        }),
      ),
      onPressed: () {
        final newFiatConversion = nextValidFiatConversion();
        if (newFiatConversion != null) {
          widget._onFiatCurrencyChange(
            newFiatConversion.currencyData.shortName,
          );
        }
      },
      child: Text(
        "${widget._accountModel.formattedFiatBalance}",
        style: subtitle1.copyWith(
          color: subtitle1.color.withOpacity(
            pow(1.00 - widget._offsetFactor, 2),
          ),
        ),
      ),
    );
  }

  FiatConversion nextValidFiatConversion() {
    final fiatConversions = widget._accountModel.preferredFiatConversionList;
    final currentIndex = fiatConversions.indexOf(
      widget._accountModel.fiatCurrency,
    );
    for (var i = 1; i < fiatConversions.length; i++) {
      var nextIndex = (i + currentIndex) % fiatConversions.length;
      if (isAboveMinAmount(fiatConversions[nextIndex])) {
        return fiatConversions[nextIndex];
      }
    }
    return null;
  }

  bool isAboveMinAmount(FiatConversion fiatConversion) {
    double fiatValue = fiatConversion.satToFiat(widget._accountModel.balance);
    int fractionSize = fiatConversion.currencyData.fractionSize;
    double minimumAmount = 1 / (pow(10, fractionSize));

    return fiatValue > minimumAmount;
  }
}
