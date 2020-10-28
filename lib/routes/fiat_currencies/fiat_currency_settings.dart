import 'dart:math';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/fiat_currency_preferences.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:collection/collection.dart';
import 'package:dragable_flutter_list/dragable_flutter_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FiatCurrencySettings extends StatefulWidget {
  FiatCurrencySettings();

  @override
  FiatCurrencySettingsState createState() {
    return FiatCurrencySettingsState();
  }
}

class FiatCurrencySettingsState extends State<FiatCurrencySettings> {
  AccountBloc _accountBloc;
  AccountModel _accountModel;
  UserProfileBloc _userProfileBloc;
  List<String> _preferredFiatCurrencies;
  List<FiatConversion> _fiatConversionList;

  List<FiatConversion> _selectedFiatConversions;
  List<FiatConversion> _unselectedFiatConversions;

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      _getExchangeRates();
      _getUserFiatCurrencyPreferences();
      _initializeFiatCurrencyList();

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  void _getExchangeRates() {
    FetchRates fetchRatesAction = FetchRates();
    _accountBloc.userActionsSink.add(fetchRatesAction);
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

  void _getUserFiatCurrencyPreferences() {
    _userProfileBloc.userStream.firstWhere((user) => user != null).then((user) {
      _preferredFiatCurrencies =
          List.from(user.fiatCurrencyPreferences.preferredFiatCurrencies);
    });
  }

  void _initializeFiatCurrencyList() {
    _accountBloc.accountStream
        .firstWhere((account) => account.fiatConversionList.isNotEmpty)
        .then((account) {
      _fiatConversionList = List.from(account.fiatConversionList);
      _accountModel = account;
      _sortList();
    });
  }

  void _sortList() {
    _updateSelectedFiatConversions();
    _unselectedFiatConversions = List.from(_fiatConversionList.where(
        (fiatConversion) => !_preferredFiatCurrencies
            .contains(fiatConversion.currencyData.shortName)));
    _sortByOrder();
    _sortByAlphabet();
    _fiatConversionList = _selectedFiatConversions + _unselectedFiatConversions;
  }

  void _sortByOrder() {
    Map<String, int> order = new Map.fromIterable(_preferredFiatCurrencies,
        key: (key) => key,
        value: (key) => _preferredFiatCurrencies.indexOf(key));
    _selectedFiatConversions.sort((a, b) => order[a.currencyData.shortName]
        .compareTo(order[b.currencyData.shortName]));
  }

  void _sortByAlphabet() {
    _unselectedFiatConversions.sort((a, b) => a.currencyData.shortName
        .toString()
        .compareTo(b.currencyData.shortName.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(
          onPressed: () => _applyChanges(context),
        ),
        title: Text(
          "Fiat Currencies",
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        elevation: 0.0,
      ),
      body: StreamBuilder<AccountModel>(
          stream: _accountBloc.accountStream,
          builder: (context, snapshot) {
            AccountModel account = snapshot.data;
            if (!snapshot.hasData) {
              return Container();
            }

            if (account.fiatConversionList.isEmpty ||
                account.fiatCurrency == null) {
              return Loader();
            }

            return DragAndDropList(
              _fiatConversionList.length,
              itemBuilder: (BuildContext context, index) =>
                  _buildFiatCurrencyTile(_fiatConversionList[index], index),
              onDragFinish: _onReorder,
              canDrag: (index) => index < _selectedFiatConversions.length,
              canBeDraggedTo: (from, to) =>
                  to < _selectedFiatConversions.length,
              dragElevation: 8.0,
            );
          }),
    );
  }

  void _applyChanges(BuildContext context) {
    _userProfileBloc.userStream
        .firstWhere((user) => user != null)
        .then((user) async {
      List<String> preferredFiatCurrencies = _selectedFiatConversions
          .map((fiatConversion) => fiatConversion.currencyData.shortName)
          .toList();
      if (!ListEquality().equals(preferredFiatCurrencies,
          user.fiatCurrencyPreferences.preferredFiatCurrencies)) {
        _updateFiatCurrencyPreferences(user, preferredFiatCurrencies, context);
      } else {
        Navigator.pop(context);
      }
    });
  }

  void _updateFiatCurrencyPreferences(BreezUserModel user,
      List<String> preferredFiatCurrencies, BuildContext context) {
    var action = UpdateFiatCurrencyPreferences(FiatCurrencyPreferences(
        preferredFiatCurrencies: preferredFiatCurrencies));
    _userProfileBloc.userActionsSink.add(action);
    action.future.then((_) {
      isSelectedFiatConversionValid();
      Navigator.pop(context);
    }).catchError((err) {
      promptError(
          context,
          "Failed to save changes",
          Text(
            err.toString(),
            style: Theme.of(context).dialogTheme.contentTextStyle,
          ));
    });
  }

  isSelectedFiatConversionValid() {
    if (!_selectedFiatConversions.contains(_accountModel.fiatCurrency)) {
      for (var i = 0; i < _selectedFiatConversions.length; i++) {
        if (isAboveMinAmount(_selectedFiatConversions[i])) {
          _userProfileBloc.fiatConversionSink
              .add(_selectedFiatConversions[i].currencyData.shortName);
          break;
        }
      }
      // revert to first item on list if no fiat value is above minimum amount
      _userProfileBloc.fiatConversionSink
          .add(_selectedFiatConversions[0].currencyData.shortName);
    }
  }

  bool isAboveMinAmount(FiatConversion fiatConversion) {
    double fiatValue = fiatConversion.satToFiat(_accountModel.balance);
    int fractionSize = fiatConversion.currencyData.fractionSize;
    double minimumAmount = 1 / (pow(10, fractionSize));

    return fiatValue > minimumAmount;
  }

  CheckboxListTile _buildFiatCurrencyTile(
      FiatConversion fiatConversion, int index) {
    return CheckboxListTile(
      key: ValueKey(fiatConversion.currencyData.shortName),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.white,
      checkColor: Theme.of(context).canvasColor,
      value: _preferredFiatCurrencies
          .contains(fiatConversion.currencyData.shortName),
      onChanged: (bool checked) {
        setState(() {
          if (checked) {
            _preferredFiatCurrencies.add(fiatConversion.currencyData.shortName);
            _unselectedFiatConversions.remove(fiatConversion);
            _selectedFiatConversions.add(fiatConversion);
          } else {
            _preferredFiatCurrencies
                .remove(fiatConversion.currencyData.shortName);
            _selectedFiatConversions.remove(fiatConversion);
            _unselectedFiatConversions.add(fiatConversion);
          }
          _sortList();
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
        color: _preferredFiatCurrencies
                .contains(fiatConversion.currencyData.shortName)
            ? theme.BreezColors.white[200]
            : Colors.transparent,
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    setState(() {
      FiatConversion item = _fiatConversionList.removeAt(oldIndex);
      _fiatConversionList.insert(newIndex, item);
      _updateSelectedFiatConversions();
    });
  }

  _updateSelectedFiatConversions() {
    setState(() {
      _selectedFiatConversions = List.from(_fiatConversionList.where(
          (fiatConversion) => _preferredFiatCurrencies
              .contains(fiatConversion.currencyData.shortName)));
    });
  }
}
