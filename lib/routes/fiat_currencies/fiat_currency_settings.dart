import 'dart:math';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/fiat_currency_preferences.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:dragable_flutter_list/dragable_flutter_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FiatCurrencySettings extends StatefulWidget {
  final AccountBloc accountBloc;
  final UserProfileBloc userProfileBloc;

  FiatCurrencySettings(this.accountBloc, this.userProfileBloc);

  @override
  FiatCurrencySettingsState createState() {
    return FiatCurrencySettingsState();
  }
}

class FiatCurrencySettingsState extends State<FiatCurrencySettings> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _getExchangeRates();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  void _getExchangeRates() {
    FetchRates fetchRatesAction = FetchRates();
    widget.accountBloc.userActionsSink.add(fetchRatesAction);
    fetchRatesAction.future.catchError((err) {
      if (this.mounted) {
        setState(() {
          Navigator.pop(context);
          showFlushbar(context,
              message: "Failed to retrieve BTC exchange rate.");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BreezUserModel>(
        stream: widget.userProfileBloc.userStream,
        builder: (context, userSnapshot) {
          var user = userSnapshot.data;

          if (!userSnapshot.hasData) {
            return Container();
          }

          return StreamBuilder<AccountModel>(
              stream: widget.accountBloc.accountStream,
              builder: (context, snapshot) {
                AccountModel account = snapshot.data;
                if (!snapshot.hasData) {
                  return Container();
                }

                if (account.fiatConversionList.isEmpty ||
                    account.fiatCurrency == null) {
                  return Loader();
                }
                List<FiatConversion> _fiatConversionList =
                    List.from(account.fiatConversionList);
                return Scaffold(
                    appBar: AppBar(
                      iconTheme: Theme.of(context).appBarTheme.iconTheme,
                      textTheme: Theme.of(context).appBarTheme.textTheme,
                      backgroundColor: Theme.of(context).canvasColor,
                      leading: backBtn.BackButton(),
                      title: Text(
                        "Fiat Currencies",
                        style:
                            Theme.of(context).appBarTheme.textTheme.headline6,
                      ),
                      elevation: 0.0,
                    ),
                    body: DragAndDropList(
                      _fiatConversionList.length,
                      itemBuilder: (BuildContext context, index) =>
                          _buildFiatCurrencyTile(
                              account, user, _fiatConversionList[index], index),
                      onDragFinish: (from, to) =>
                          _onReorder(account, user, from, to),
                      canDrag: (index) =>
                          index <= account.preferredFiatConversionList.length,
                      canBeDraggedTo: (from, to) =>
                          to <= account.preferredFiatConversionList.length,
                      dragElevation: 8.0,
                    ));
              });
        });
  }

  bool _isSelectedFiatConversionValid(AccountModel account,
      FiatCurrencyPreferences newFiatCurrencyPreferences) {
    return newFiatCurrencyPreferences.preferredFiatCurrencies
        .contains(account.fiatCurrency.currencyData.shortName);
  }

  _changeFiatCurrency(AccountModel account) {
    for (var i = 0; i < account.preferredFiatConversionList.length; i++) {
      if (isAboveMinAmount(account, i)) {
        widget.userProfileBloc.fiatConversionSink
            .add(account.preferredFiatConversionList[i].currencyData.shortName);
        break;
      }
    }
    widget.userProfileBloc.fiatConversionSink
        .add(account.preferredFiatConversionList[0].currencyData.shortName);
  }

  bool isAboveMinAmount(AccountModel accountModel, int index) {
    double fiatValue = accountModel.preferredFiatConversionList[index]
        .satToFiat(accountModel.balance);
    int fractionSize = accountModel
        .preferredFiatConversionList[index].currencyData.fractionSize;
    double minimumAmount = 1 / (pow(10, fractionSize));

    return fiatValue > minimumAmount;
  }

  CheckboxListTile _buildFiatCurrencyTile(AccountModel account,
      BreezUserModel user, FiatConversion fiatConversion, int index) {
    List<String> preferredFiatCurrencies =
        List.from(user.fiatCurrencyPreferences.preferredFiatCurrencies);
    return CheckboxListTile(
      key: ValueKey(fiatConversion.currencyData.shortName),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.white,
      checkColor: Theme.of(context).canvasColor,
      value: preferredFiatCurrencies
          .contains(fiatConversion.currencyData.shortName),
      onChanged: (bool checked) {
        setState(() {
          if (checked) {
            preferredFiatCurrencies.add(fiatConversion.currencyData.shortName);
          } else if (account.preferredFiatConversionList.length != 1) {
            preferredFiatCurrencies
                .remove(fiatConversion.currencyData.shortName);
          }
          _updateFiatCurrencyPreferences(account, preferredFiatCurrencies);
        });
      },
      subtitle: Text(fiatConversion.currencyData.name,
          style: theme.fiatConversionDescriptionStyle),
      title: RichText(
        text: TextSpan(
            text: fiatConversion.currencyData.shortName,
            style: theme.fiatConversionTitleStyle,
            children: <TextSpan>[
              TextSpan(
                  text: " (${fiatConversion.currencyData.symbol})",
                  style: theme.fiatConversionDescriptionStyle),
            ]),
      ),
      secondary: Icon(
        Icons.drag_handle,
        color: preferredFiatCurrencies
                .contains(fiatConversion.currencyData.shortName)
            ? theme.BreezColors.white[200]
            : Colors.transparent,
      ),
    );
  }

  void _onReorder(
      AccountModel account, BreezUserModel user, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    List<String> preferredFiatCurrencies =
        List.from(user.fiatCurrencyPreferences.preferredFiatCurrencies);
    String item = preferredFiatCurrencies.removeAt(oldIndex);
    preferredFiatCurrencies.insert(newIndex, item);
    _updateFiatCurrencyPreferences(account, preferredFiatCurrencies);
  }

  void _updateFiatCurrencyPreferences(
      AccountModel account, List<String> preferredFiatCurrencies) {
    var action = UpdateFiatCurrencyPreferences(FiatCurrencyPreferences(
        preferredFiatCurrencies: preferredFiatCurrencies));
    widget.userProfileBloc.userActionsSink.add(action);
    action.future.then((newFiatCurrencyPreferences) {
      bool isSelectedFiatConversionValid =
          _isSelectedFiatConversionValid(account, newFiatCurrencyPreferences);
      if (!isSelectedFiatConversionValid) _changeFiatCurrency(account);
    }).catchError((err) {
      showFlushbar(context, message: "Failed to save changes.");
    });
  }
}
