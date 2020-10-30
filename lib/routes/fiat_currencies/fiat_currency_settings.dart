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
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double ITEM_HEIGHT = 72.0;

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
  ScrollController _scrollController = new ScrollController();
  bool _isInit = false;
  List<String> _preferredFiatCurrencies;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _getExchangeRates();
      widget.userProfileBloc.userStream
          .firstWhere((u) => u != null)
          .then((user) {
        _preferredFiatCurrencies =
            List.from(user.fiatCurrencyPreferences.preferredFiatCurrencies);
      });
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
                      style: Theme.of(context).appBarTheme.textTheme.headline6,
                    ),
                    elevation: 0.0,
                  ),
                  body: DragAndDropLists(
                    children: [_buildList(account, user, _fiatConversionList)],
                    scrollController: _scrollController,
                    lastListTargetSize: 0,
                    lastItemTargetHeight: 8,
                    onItemReorder: (from, oldListIndex, to, newListIndex) =>
                        _onReorder(account, user, from, to),
                    dragHandle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.drag_handle,
                          color: theme.BreezColors.white[200]),
                    ),
                  ),
                );
              });
        });
  }

  DragAndDropList _buildList(AccountModel account, BreezUserModel user,
      List<FiatConversion> fiatConversionList) {
    return DragAndDropList(
      canDrag: false,
      children: List.generate(
        fiatConversionList.length,
        (index) {
          return DragAndDropItem(
              child: _buildFiatCurrencyTile(account, user,
                  fiatConversionList[index], _preferredFiatCurrencies, index),
              canDrag: _preferredFiatCurrencies
                  .contains(fiatConversionList[index].currencyData.shortName));
        },
      ),
    );
  }

  bool _isSelectedFiatConversionValid(AccountModel account,
      FiatCurrencyPreferences newFiatCurrencyPreferences) {
    return newFiatCurrencyPreferences.preferredFiatCurrencies
        .contains(account.fiatCurrency.currencyData.shortName);
  }

  _changeFiatCurrency(AccountModel account,
      FiatCurrencyPreferences newFiatCurrencyPreferences) {
    List<FiatConversion> preferredFiatConversionList = List.from(
        account.fiatConversionList.where((fiatConversion) =>
            newFiatCurrencyPreferences.preferredFiatCurrencies
                .contains(fiatConversion.currencyData.shortName)));
    for (var i = 0; i < preferredFiatConversionList.length; i++) {
      if (isAboveMinAmount(account, i)) {
        widget.userProfileBloc.fiatConversionSink
            .add(preferredFiatConversionList[i].currencyData.shortName);
        break;
      }
    }
    // revert to first item on list if no fiat value is above minimum amount
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

  CheckboxListTile _buildFiatCurrencyTile(
      AccountModel account,
      BreezUserModel user,
      FiatConversion fiatConversion,
      List<String> preferredFiatCurrencies,
      int index) {
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
            // center item in viewport
            if (_scrollController.offset >=
                (ITEM_HEIGHT * (preferredFiatCurrencies.length - 1))) {
              _scrollController.animateTo(
                ((2 * preferredFiatCurrencies.length - 1) * ITEM_HEIGHT -
                        _scrollController.position.viewportDimension) /
                    2,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 400),
              );
            }
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
    );
  }

  void _onReorder(
      AccountModel account, BreezUserModel user, int oldIndex, int newIndex) {
    if (newIndex >= _preferredFiatCurrencies.length) {
      newIndex = _preferredFiatCurrencies.length - 1;
    }
    String item = _preferredFiatCurrencies.removeAt(oldIndex);
    _preferredFiatCurrencies.insert(newIndex, item);
    _updateFiatCurrencyPreferences(account, _preferredFiatCurrencies);
  }

  void _updateFiatCurrencyPreferences(
      AccountModel account, List<String> preferredFiatCurrencies) {
    var action = UpdateFiatCurrencyPreferences(FiatCurrencyPreferences(
        preferredFiatCurrencies: preferredFiatCurrencies));
    widget.userProfileBloc.userActionsSink.add(action);
    action.future.then((newFiatCurrencyPreferences) {
      if (!_isSelectedFiatConversionValid(
          account, newFiatCurrencyPreferences)) {
        _changeFiatCurrency(account, newFiatCurrencyPreferences);
      }
    }).catchError((err) {
      showFlushbar(context, message: "Failed to save changes.");
    });
  }
}
