import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
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

  //UserProfileBloc _userProfileBloc;

  Map<String, bool> values;
  List<FiatConversion> _fiatConversionList;

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      // _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
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
    // Temporary values
    // TODO: Move user fiat currency preferences to BreezUserModel
    values = {
      'USD': true,
      'EUR': true,
      'GBP': true,
      'JPY': true,
    };
  }

  void _initializeFiatCurrencyList() {
    _accountBloc.accountStream
        .firstWhere((account) => account.fiatConversionList.isNotEmpty)
        .then((account) {
      _fiatConversionList = account.fiatConversionList;
      _sortListByPreference();
      _sortListByAlphabet();
    });
  }

  void _sortListByPreference() {
    _fiatConversionList.sort((a, b) {
      if (values[a.currencyData.shortName] ==
          values[b.currencyData.shortName]) {
        return 0;
      } else if (values[b.currencyData.shortName]) {
        return 1;
      }
      return -1;
    });
  }

  void _sortListByAlphabet() {
    _fiatConversionList.sort((a, b) {
      if (!values[a.currencyData.shortName] &&
          !values[b.currencyData.shortName]) {
        return a.currencyData.shortName
            .toString()
            .compareTo(b.currencyData.shortName.toString());
      }
      return 0;
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
          onPressed: () => _applyChanges,
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
    _accountBloc.accountStream
        .firstWhere((account) => account.fiatConversionList.isNotEmpty)
        .then((account) {
      // Check for changes
      if (listEquals(_fiatConversionList, account.fiatConversionList)) {
        // Open confirmation dialog to save changes
      } else {
        Navigator.pop(context);
      }
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
      value: values[fiatConversion.currencyData.shortName] ?? false,
      onChanged: (bool value) {
        setState(() {
          values[fiatConversion.currencyData.shortName] = value;
          _sortListByPreference();
          _sortListByAlphabet();
        });
      },
      title: RichText(
        text: TextSpan(
            text: fiatConversion.currencyData.shortName,
            style: theme.fiatConversionTitleStyle,
            children: <TextSpan>[
              TextSpan(
                  text: " (${fiatConversion.currencyData.name})",
                  style: theme.fiatConversionDescriptionStyle),
            ]),
      ),
      secondary: Icon(
        Icons.drag_handle,
        color: values[fiatConversion.currencyData.shortName]
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
