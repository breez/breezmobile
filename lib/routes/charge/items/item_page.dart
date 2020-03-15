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

import '../currency_wrapper.dart';

class ItemPage extends StatefulWidget {
  final Item item;
  final AccountModel accountModel;
  final PosCatalogBloc _posCatalogBloc;

  ItemPage(this._posCatalogBloc, {this.item, this.accountModel});

  @override
  State<StatefulWidget> createState() {
    return ItemPageState();
  }
}

class ItemPageState extends State<ItemPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _skuController = TextEditingController();
  AccountBloc _accountBloc;
  bool _isInit = false;
  bool _inEditMode = false;
  String _titlePrefix = "Add";
  CurrencyWrapper _selectedCurrency = CurrencyWrapper.fromBTC(Currency.BTC);

  @override
  void initState() {
    super.initState();
    _inEditMode = widget.item != null;
    if (_inEditMode) _initializeFields();
  }

  _initializeFields() {
    _titlePrefix = "Edit";
    _nameController.text = widget.item.name;
    _skuController.text = widget.item.sku;
    _getCurrency();
  }

  _getCurrency() {
    _selectedCurrency = CurrencyWrapper.fromShortName(
        widget.item.currency, widget.accountModel);
    _priceController.text = _formattedPrice(widget.item.price);
  }

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
                    style: theme.FieldTextStyle.textStyle,
                    validator: (value) {
                      if (value.length == 0) {
                        return "Item Name is required";
                      }
                    },
                  ),
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
                              inputFormatters: _selectedCurrency.chargeSuffix ==
                                      "BTC"
                                  ? [
                                      WhitelistingTextInputFormatter(
                                          RegExp("^\\d+\\.?\\d{0,8}"))
                                    ]
                                  : [
                                      WhitelistingTextInputFormatter(
                                          _selectedCurrency.fractionSize == 0
                                              ? RegExp(r'\d+')
                                              : RegExp(
                                                  "^\\d+\\.?\\d{0,${_selectedCurrency.fractionSize ?? 2}}"))
                                    ],
                              controller: _priceController,
                              decoration: InputDecoration(
                                  labelText: "Item Price",
                                  hintText: "Enter an item price",
                                  border: UnderlineInputBorder()),
                              style: theme.FieldTextStyle.textStyle,
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
                                              value:
                                                  _selectedCurrency.shortName,
                                              onChanged: (value) =>
                                                  _changeCurrency(
                                                      account, value),
                                              items: Currency.currencies.map(
                                                  (Currency value) {
                                                return DropdownMenuItem<String>(
                                                  value: value.tickerSymbol,
                                                  child: Text(
                                                    value.tickerSymbol,
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
                  TextFormField(
                    controller: _skuController,
                    decoration: InputDecoration(
                        labelText: "Item SKU",
                        hintText: "Enter a SKU",
                        border: UnderlineInputBorder()),
                    style: theme.FieldTextStyle.textStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _changeCurrency(AccountModel accountModel, value) {
    setState(() {
      _selectedCurrency = CurrencyWrapper.fromShortName(value, accountModel);
      if (_priceController.text.isNotEmpty) {
        _priceController.text =
            _formattedPrice(double.parse(_priceController.text));
      }
    });
  }

  String _formattedPrice(double price) {
    return _selectedCurrency.format(price,
        userInput: true, removeTrailingZeros: true);
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
          "$_titlePrefix Item",
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
        actions: actions == null ? <Widget>[] : actions,
        elevation: 0.0,
      ),
      body: body,
      bottomNavigationBar: SingleButtonBottomBar(
        text: "$_titlePrefix Item",
        onPressed: () {
          {
            if (_formKey.currentState.validate()) {
              if (_inEditMode) {
                UpdateItem updateItem = UpdateItem(
                  Item(
                      id: widget.item.id,
                      name: _nameController.text.trimRight(),
                      currency: _selectedCurrency.shortName,
                      price: double.parse(
                          _formattedPrice(double.parse(_priceController.text))),
                      sku: _skuController.text.isNotEmpty
                          ? _skuController.text
                          : null),
                );
                widget._posCatalogBloc.actionsSink.add(updateItem);
                updateItem.future.then((_) {
                  Navigator.pop(context);
                });
              } else {
                AddItem addItem = AddItem(
                  Item(
                      name: _nameController.text.trimRight(),
                      currency: _selectedCurrency.shortName,
                      price: double.parse(
                          _formattedPrice(double.parse(_priceController.text))),
                      sku: _skuController.text.isNotEmpty
                          ? _skuController.text
                          : null),
                );
                widget._posCatalogBloc.actionsSink.add(addItem);
                addItem.future.then((_) {
                  Navigator.pop(context);
                });
              }
            }
          }
        },
      ),
    );
  }
}
