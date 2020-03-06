import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateItemPage extends StatefulWidget {
  final PosCatalogBloc _posCatalogBloc;

  CreateItemPage(this._posCatalogBloc);

  @override
  State<StatefulWidget> createState() {
    return CreateItemPageState();
  }
}

class CreateItemPageState extends State<CreateItemPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  AccountBloc _accountBloc;
  bool _isInit = false;
  bool _isFiat = false;
  Currency _selectedCurrency = Currency.BTC;
  FiatConversion _selectedFiatCurrency;
  String currency;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      FetchRates fetchRatesAction = FetchRates();
      _accountBloc.userActionsSink.add(fetchRatesAction);

      fetchRatesAction.future.catchError((err) {
        if (this.mounted) {
          setState(() {
            showFlushbar(context,
                message: "Failed to retrieve BTC exchange rate.");
          });
        }
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return _buildScaffold(
      ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16.0, right: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: _nameController,
                      decoration: InputDecoration(
                          labelText: "Item Name",
                          hintText: "Enter an item name",
                          border: UnderlineInputBorder()),
                      validator: (value) {
                        if (value.length == 0) {
                          return "Item Name is required";
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 10,
                          child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: _isFiat
                                  ? [
                                      WhitelistingTextInputFormatter(
                                          _selectedFiatCurrency.currencyData
                                                      .fractionSize ==
                                                  0
                                              ? RegExp(r'\d+')
                                              : RegExp(
                                                  "^\\d+\\.?\\d{0,${_selectedFiatCurrency.currencyData.fractionSize ?? 2}}"))
                                    ]
                                  : _selectedCurrency != Currency.SAT
                                      ? [
                                          WhitelistingTextInputFormatter(
                                              RegExp(r'\d+\.?\d*'))
                                        ]
                                      : [
                                          WhitelistingTextInputFormatter
                                              .digitsOnly
                                        ],
                              controller: _priceController,
                              decoration: InputDecoration(
                                  labelText: "Item Price",
                                  hintText: "Enter an item price",
                                  border: UnderlineInputBorder()),
                              validator: (value) {
                                if (value.length == 0) {
                                  return "Item Price is required";
                                }
                              }),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Theme(
                            data: Theme.of(context).copyWith(
                                canvasColor: Theme.of(context).canvasColor),
                            child: new StreamBuilder<AccountSettings>(
                                stream: _accountBloc.accountSettingsStream,
                                builder: (settingCtx, settingSnapshot) {
                                  return StreamBuilder<AccountModel>(
                                      stream: _accountBloc.accountStream,
                                      builder: (context, snapshot) {
                                        AccountModel account = snapshot.data;
                                        if (!snapshot.hasData) {
                                          return Container();
                                        }

                                        return Expanded(
                                          flex: 4,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButtonFormField(
                                              isDense: true,
                                              decoration: InputDecoration(
                                                labelText: 'Currency',
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10.6),
                                              ),
                                              value: _currencySymbol(),
                                              onChanged: (value) =>
                                                  _changeCurrency(
                                                      account, value),
                                              items: Currency.currencies.map(
                                                  (Currency value) {
                                                return DropdownMenuItem<String>(
                                                  value: value.symbol,
                                                  child: Text(
                                                    value.displayName,
                                                    style: theme.FieldTextStyle
                                                        .textStyle
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor),
                                                  ),
                                                );
                                              }).toList()
                                                ..addAll(account
                                                    .fiatConversionList
                                                    .map((FiatConversion fiat) {
                                                  return new DropdownMenuItem<
                                                      String>(
                                                    value: fiat
                                                        .currencyData.shortName,
                                                    child: new Text(
                                                      fiat.currencyData
                                                          .shortName,
                                                      style: theme
                                                          .FieldTextStyle
                                                          .textStyle
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor),
                                                    ),
                                                  );
                                                }).toList()),
                                            ),
                                          ),
                                        );
                                      });
                                })),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _currencySymbol({bool showDisplayName = false}) {
    return _isFiat
        ? _selectedFiatCurrency.currencyData.shortName
        : _selectedCurrency.symbol;
  }

  _changeCurrency(AccountModel accountModel, value) {
    setState(() {
      Currency currency = Currency.fromSymbol(value);
      _isFiat = (currency == null);
      _selectedFiatCurrency =
          _isFiat ? accountModel.getFiatCurrencyByShortName(value) : null;
      _selectedCurrency = !_isFiat ? currency : null;
      if (_priceController.text.isNotEmpty) {
        _priceController.text = _formattedPrice();
      }
    });
  }

  String _formattedPrice() {
    return _isFiat
        ? _selectedFiatCurrency.formatFiat(double.parse(_priceController.text),
            addCurrencyPrefix: false)
        : _selectedCurrency.format(
            _selectedCurrency.parse(_priceController.text),
            includeDisplayName: false,
            userInput: true);
  }

  Widget _buildScaffold(Widget body, [List<Widget> actions]) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(),
        title: Text(
          "Add Item",
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
        actions: actions == null ? <Widget>[] : actions,
        elevation: 0.0,
      ),
      body: body,
      bottomNavigationBar: SingleButtonBottomBar(
        text: "Add Item",
        onPressed: () {
          {
            if (_formKey.currentState.validate()) {
              AddItem addItem = AddItem(
                Item(
                  name: _nameController.text.trimRight(),
                  currency: _currencySymbol(),
                  price: double.parse(_formattedPrice()),
                ),
              );
              widget._posCatalogBloc.actionsSink.add(addItem);
              addItem.future.then((_) {
                Navigator.pop(context);
              });
            }
          }
        },
      ),
    );
  }
}
