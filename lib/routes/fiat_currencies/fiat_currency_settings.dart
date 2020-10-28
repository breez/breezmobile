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
  UserProfileBloc _userProfileBloc;
  List<String> _preferredFiatCurrencies;
  List<FiatConversion> _fiatConversionList;

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
      _fiatConversionList = account.fiatConversionList;
      _sortListByAlphabet();
    });
  }

  void _sortListByAlphabet() {
    _fiatConversionList.sort((a, b) {
      return a.currencyData.shortName
          .toString()
          .compareTo(b.currencyData.shortName.toString());
    });
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

            return ReorderableListView(
              padding: EdgeInsets.only(top: 16),
              children: _getListItems(_fiatConversionList),
              onReorder: _onReorder,
            );
          }),
    );
  }

  void _applyChanges(BuildContext context) {
    _userProfileBloc.userStream
        .firstWhere((user) => user != null)
        .then((user) async {
      if (!listEquals(_preferredFiatCurrencies,
          user.fiatCurrencyPreferences.preferredFiatCurrencies)) {
        _updateFiatCurrencyPreferences(user, context);
      }
      Navigator.pop(context);
    });
  }

  void _updateFiatCurrencyPreferences(
      BreezUserModel user, BuildContext context) {
    var action = UpdateFiatCurrencyPreferences(FiatCurrencyPreferences(
        preferredFiatCurrencies: _preferredFiatCurrencies));
    _userProfileBloc.userActionsSink.add(action);
    action.future.then((_) {
      if (listEquals(_preferredFiatCurrencies,
          user.fiatCurrencyPreferences.preferredFiatCurrencies)) {
        Navigator.pop(context);
      }
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

  List<CheckboxListTile> _getListItems(List list) => list
      .asMap()
      .map((i, item) => MapEntry(i, _buildFiatCurrencyTile(item, i)))
      .values
      .toList();

  CheckboxListTile _buildFiatCurrencyTile(
      FiatConversion fiatConversion, int index) {
    // TODO: Disable drag for unchecked items
    return CheckboxListTile(
      key: ValueKey(fiatConversion.currencyData.shortName),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.white,
      checkColor: Theme.of(context).canvasColor,
      value: _preferredFiatCurrencies
          .contains(fiatConversion.currencyData.shortName),
      onChanged: (bool checked) {
        setState(() {
          checked
              ? _preferredFiatCurrencies
                  .add(fiatConversion.currencyData.shortName)
              : _preferredFiatCurrencies
                  .remove(fiatConversion.currencyData.shortName);
          _sortListByAlphabet();
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
    });
  }
}
