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
  final PosCatalogBloc _posCatalogBloc;

  ItemPage(this._posCatalogBloc, {this.item});

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
  String _title = "Add Item";
  CurrencyWrapper _selectedCurrency = CurrencyWrapper.fromBTC(Currency.BTC);

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      FetchRates fetchRatesAction = FetchRates();
      _accountBloc.userActionsSink.add(fetchRatesAction);
      if (widget.item != null) {
        _accountBloc.accountStream.first.then((accountModel) {
          setState(() {
            _title = "Edit Item";
            _nameController.text = widget.item.name;
            _skuController.text = widget.item.sku;
            _selectedCurrency = CurrencyWrapper.fromShortName(
                widget.item.currency, accountModel);
            _priceController.text = _formattedPrice(widget.item.price);
          });
        });
      }

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
                              inputFormatters:
                                  _selectedCurrency.inputFormatters,
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
                            child: StreamBuilder<AccountModel>(
                                stream: _accountBloc.accountStream,
                                builder: (settingCtx, snapshot) {
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
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.6),
                                        ),
                                        value: _selectedCurrency.shortName,
                                        onChanged: (value) =>
                                            _changeCurrency(account, value),
                                        items: Currency.currencies.map(
                                            (Currency value) {
                                          return DropdownMenuItem<String>(
                                            value: value.tickerSymbol,
                                            child: Text(
                                              value.tickerSymbol,
                                              style: theme
                                                  .FieldTextStyle.textStyle
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .accentColor),
                                            ),
                                          );
                                        }).toList()
                                          ..addAll(account.fiatConversionList
                                              .map((FiatConversion fiat) {
                                            return new DropdownMenuItem<String>(
                                              value:
                                                  fiat.currencyData.shortName,
                                              child: new Text(
                                                fiat.currencyData.shortName,
                                                style: theme
                                                    .FieldTextStyle.textStyle
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .accentColor),
                                              ),
                                            );
                                          }).toList()),
                                      ),
                                    ),
                                  );
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
          _title,
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
        actions: actions == null ? <Widget>[] : actions,
        elevation: 0.0,
      ),
      body: body,
      bottomNavigationBar: SingleButtonBottomBar(
        text: widget.item != null ? "SAVE" : _title,
        onPressed: () {
          {
            if (_formKey.currentState.validate()) {
              if (widget.item != null) {
                UpdateItem updateItem = UpdateItem(widget.item.copyWith(
                    name: _nameController.text.trimRight(),
                    currency: _selectedCurrency.shortName,
                    price: double.parse(_priceController.text),
                    sku: _skuController.text.isNotEmpty
                        ? _skuController.text
                        : null));
                widget._posCatalogBloc.actionsSink.add(updateItem);
                updateItem.future.then((_) {
                  Navigator.pop(context);
                });
              } else {
                AddItem addItem = AddItem(
                  Item(
                      name: _nameController.text.trimRight(),
                      currency: _selectedCurrency.shortName,
                      price: double.parse(_priceController.text),
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
