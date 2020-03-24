import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/charge/items/item_avatar.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../currency_wrapper.dart';
import 'item_avatar_picker.dart';

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
  String _itemImage;
  CurrencyWrapper _selectedCurrency = CurrencyWrapper.fromBTC(Currency.SAT);

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
            _itemImage = widget.item.imageURL ?? "";
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
      _nameController.addListener(() => setState(() {}));
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
                  _buildItemAvatarPicker(context),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: "Name",
                        hintText: "Enter a name",
                        border: UnderlineInputBorder()),
                    style: theme.FieldTextStyle.textStyle,
                    validator: (value) {
                      if (value.trim().length == 0) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                WhitelistingTextInputFormatter(
                                    _selectedCurrency.whitelistedPattern)
                              ],
                              controller: _priceController,
                              decoration: InputDecoration(
                                  labelText: "Price",
                                  hintText: "Enter a price",
                                  border: UnderlineInputBorder()),
                              style: theme.FieldTextStyle.textStyle,
                              validator: (value) {
                                if (value.length == 0) {
                                  return "Price is required";
                                }
                                return null;
                              }),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Container(
                          width: 80,
                          child: Theme(
                              data: Theme.of(context).copyWith(
                                  canvasColor: Theme.of(context).canvasColor),
                              child: StreamBuilder<AccountModel>(
                                  stream: _accountBloc.accountStream,
                                  builder: (settingCtx, snapshot) {
                                    AccountModel account = snapshot.data;
                                    if (!snapshot.hasData) {
                                      return Container();
                                    }

                                    return DropdownButtonHideUnderline(
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
                                    );
                                  })),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: _skuController,
                      decoration: InputDecoration(
                          labelText: "SKU",
                          hintText: "Enter a SKU",
                          border: UnderlineInputBorder()),
                      style: theme.FieldTextStyle.textStyle,
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

  _buildItemAvatarPicker(BuildContext context) {
    return GestureDetector(
        onTap: () {
          var avatarPickerRoute = FadeInRoute(
              builder: (_) => ItemAvatarPicker(
                    _itemImage,
                    (value) => _onImageSelected(value),
                    itemName: _nameController.text,
                  ));
          Navigator.of(context).push(avatarPickerRoute);
        },
        child:
            (_nameController.text == null || _nameController.text.trim() == "")
                ? _buildSelectImageButton(context)
                : ItemAvatar(
                    _itemImage,
                    itemName: _nameController.text,
                    radius: 48,
                    useDecoration: true,
                  ));
  }

  Container _buildSelectImageButton(BuildContext context) {
    return Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                          style: BorderStyle.solid),
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).primaryColorLight,
                              BlendMode.srcATop),
                          image: AssetImage("src/images/avatarbg.png"),
                          fit: BoxFit.cover)),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.edit, size: 24),
                      Text(
                        "Select Image",
                        style: TextStyle(
                            fontSize: 12.3,
                            color: Color.fromRGBO(255, 255, 255, 0.88),
                            letterSpacing: 0.0,
                            fontFamily: "IBMPlexSans"),
                      ),
                    ],
                  ),
                );
  }

  _onImageSelected(String selectedImage) {
    setState(() {
      _itemImage = selectedImage;
    });
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
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        actions: actions == null ? <Widget>[] : actions,
        elevation: 0.0,
      ),
      body: body,
      bottomNavigationBar: SingleButtonBottomBar(
        text: widget.item != null ? "SAVE" : _title.toUpperCase(),
        onPressed: () {
          {
            if (_formKey.currentState.validate()) {
              if (widget.item != null) {
                UpdateItem updateItem = UpdateItem(widget.item.copyWith(
                    imageURL: _itemImage,
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
                      imageURL: _itemImage != null && _itemImage.isNotEmpty
                          ? _itemImage
                          : null,
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
