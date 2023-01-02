import 'package:auto_size_text/auto_size_text.dart';
import 'package:clovrlabs_wallet/bloc/account/account_actions.dart';
import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/pos_catalog/actions.dart';
import 'package:clovrlabs_wallet/bloc/pos_catalog/bloc.dart';
import 'package:clovrlabs_wallet/bloc/pos_catalog/model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/currency.dart';
import 'package:clovrlabs_wallet/routes/charge/items/item_avatar.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/utils/min_font_size.dart';
import 'package:clovrlabs_wallet/widgets/InputDecorationWallet.dart';
import 'package:clovrlabs_wallet/widgets/back_button.dart' as backBtn;
import 'package:clovrlabs_wallet/widgets/flushbar.dart';
import 'package:clovrlabs_wallet/widgets/route.dart';
import 'package:clovrlabs_wallet/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../currency_wrapper.dart';
import 'item_avatar_picker.dart';

class ItemPage extends StatefulWidget {
  final Item item;
  final PosCatalogBloc _posCatalogBloc;

  ItemPage(
    this._posCatalogBloc, {
    this.item,
  });

  @override
  State<StatefulWidget> createState() {
    return ItemPageState();
  }
}

class ItemPageState extends State<ItemPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _skuController = TextEditingController();

  AccountBloc _accountBloc;
  bool _isInit = false;
  String _title = "";
  String _itemImage;
  CurrencyWrapper _selectedCurrency = CurrencyWrapper.fromBTC(Currency.SAT);

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final texts = AppLocalizations.of(context);
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);

      _title = texts.pos_invoice_item_management_title_add;
      FetchRates fetchRatesAction = FetchRates();
      _accountBloc.userActionsSink.add(fetchRatesAction);
      _accountBloc.accountStream.first.then((accountModel) {
        if (widget.item != null) {
          setState(() {
            _title = texts.pos_invoice_item_management_title_edit;
            _itemImage = widget.item.imageURL;
            _nameController.text = widget.item.name;
            _skuController.text = widget.item.sku;
            _selectedCurrency = CurrencyWrapper.fromShortName(
                  widget.item.currency,
                  accountModel,
                ) ??
                _selectedCurrency;
            _priceController.text = _formattedPrice(widget.item.price);
          });
        } else {
          widget._posCatalogBloc.selectedCurrencyStream.listen((currency) {
            setState(() {
              _selectedCurrency = CurrencyWrapper.fromShortName(
                    currency,
                    accountModel,
                  ) ??
                  _selectedCurrency;
            });
          });
        }
      });

      fetchRatesAction.future.catchError((err) {
        if (this.mounted) {
          setState(() {
            showFlushbar(
              context,
              message: texts.pos_invoice_item_management_error_btc_rate,
            );
          });
        }
      });
      _nameController.addListener(() => setState(() {}));
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return _buildScaffold(
      context,
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
                  _nameField(context),
                  Container(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: _priceField(context),
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Container(
                          width: 80,
                          child: Theme(
                            data: themeData.copyWith(
                              canvasColor: themeData.canvasColor,
                            ),
                            child: StreamBuilder<AccountModel>(
                              stream: _accountBloc.accountStream,
                              builder: (settingCtx, snapshot) {
                                AccountModel account = snapshot.data;
                                if (!snapshot.hasData) {
                                  return Container();
                                }

                                return _dropDown(context, account);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: _skuField(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nameField(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      controller: _nameController,
      decoration: InputDecorationWallet(
        labelText: texts.pos_invoice_item_management_field_name_label,
        hintText: texts.pos_invoice_item_management_field_name_hint,
      ),
      style: theme.FieldTextStyle.textStyle,
      validator: (value) {
        if (value.trim().length == 0) {
          return texts.pos_invoice_item_management_field_name_error;
        }
        return null;
      },
    );
  }

  Widget _priceField(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(
        decimal: true,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          _selectedCurrency.whitelistedPattern,
        ),
      ],
      controller: _priceController,
      decoration: InputDecorationWallet(
        labelText: texts.pos_invoice_item_management_field_price_label,
        hintText: texts.pos_invoice_item_management_field_price_hint,
      ),
      style: theme.FieldTextStyle.textStyle,
      validator: (value) {
        if (value.length == 0) {
          return texts.pos_invoice_item_management_field_price_error;
        }
        return null;
      },
    );
  }

  Widget _skuField(BuildContext context) {
    final texts = AppLocalizations.of(context);
    return TextFormField(
      controller: _skuController,
      decoration: InputDecorationWallet(
        labelText: texts.pos_invoice_item_management_field_sku_label,
        hintText: texts.pos_invoice_item_management_field_sku_hint,
      ),
      style: theme.FieldTextStyle.textStyle,
    );
  }

  Widget _dropDown(
    BuildContext context,
    AccountModel account,
  ) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final queryData = MediaQuery.of(this.context);

    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField(
        iconEnabledColor: Colors.white,
        isDense: true,
        decoration: InputDecoration(
          labelText: texts.pos_invoice_item_management_dd_currency_title,
          contentPadding: EdgeInsets.symmetric(
            vertical: 10.6 * queryData.textScaleFactor,
          ),
        ),
        value: _selectedCurrency.shortName,
        onChanged: (value) => _changeCurrency(account, value),
        items: Currency.currencies.map((Currency value) {
          return DropdownMenuItem<String>(
            value: value.tickerSymbol,
            child: Text(
              value.tickerSymbol,
              style: theme.FieldTextStyle.textStyle.copyWith(
                color: Colors.white,
              ),
            ),
          );
        }).toList()
          ..addAll(account.preferredFiatConversionList.map((fiat) {
            return new DropdownMenuItem<String>(
              value: fiat.currencyData.shortName,
              child: new Text(
                fiat.currencyData.shortName,
                style: theme.FieldTextStyle.textStyle.copyWith(
                  color: Colors.white,
                ),
              ),
            );
          }).toList()),
      ),
    );
  }

  Widget _buildItemAvatarPicker(BuildContext context) {
    final name = _nameController.text?.trim();
    final missingImage = _itemImage == null || _itemImage == "";
    final missingName = name == null || name == "";

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        FadeInRoute(
          builder: (_) => ItemAvatarPicker(
            _itemImage,
            (value) => _onImageSelected(value),
            itemName: name,
          ),
        ),
      ),
      child: (missingImage && missingName)
          ? _buildSelectImageButton(context)
          : ItemAvatar(
              _itemImage,
              itemName: name,
              radius: 48,
              useDecoration: true,
            ),
    );
  }

  Widget _buildSelectImageButton(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1.0,
          style: BorderStyle.solid,
        ),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            themeData.primaryColorLight,
            BlendMode.srcATop,
          ),
          image: AssetImage("src/images/avatarbg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.edit, size: 24),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: AutoSizeText(
              texts.pos_invoice_item_management_image_title,
              textAlign: TextAlign.center,
              maxLines: 2,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              style: TextStyle(
                fontSize: 12.3,
                color: Color.fromRGBO(255, 255, 255, 0.88),
                letterSpacing: 0.0,
                fontFamily: "IBMPlexSans",
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onImageSelected(String selectedImage) {
    setState(() {
      _itemImage = selectedImage;
    });
  }

  void _changeCurrency(AccountModel accountModel, value) {
    setState(() {
      _selectedCurrency = CurrencyWrapper.fromShortName(value, accountModel);
      if (_priceController.text.isNotEmpty) {
        _priceController.text = _formattedPrice(
          double.parse(_priceController.text),
        );
      }
    });
    widget._posCatalogBloc.actionsSink.add(
      UpdatePosItemAdditionCurrency(value),
    );
  }

  String _formattedPrice(double price) {
    return _selectedCurrency.format(
      price,
      userInput: true,
      removeTrailingZeros: true,
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    Widget body, [
    List<Widget> actions,
  ]) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: themeData.appBarTheme.iconTheme,
        textTheme: themeData.appBarTheme.textTheme,
        backgroundColor: themeData.canvasColor,
        leading: backBtn.BackButton(),
        title: Text(
          _title,
          // style: themeData.appBarTheme.textTheme.headline6,
        ),
        actions: actions == null ? <Widget>[] : actions,
        elevation: 0.0,
      ),
      body: body,
      bottomNavigationBar: SingleButtonBottomBar(
        text: widget.item != null
            ? texts.pos_invoice_item_management_title_save
            : _title.toUpperCase(),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            if (widget.item != null) {
              UpdateItem updateItem = UpdateItem(
                widget.item.copyWith(
                  imageURL: _itemImage != null && _itemImage.isNotEmpty
                      ? _itemImage
                      : null,
                  name: _nameController.text.trimRight(),
                  currency: _selectedCurrency.shortName,
                  price: double.parse(_priceController.text),
                  sku: _skuController.text,
                ),
              );
              widget._posCatalogBloc.actionsSink.add(updateItem);
              updateItem.future.then((_) {
                Navigator.pop(context);
              });
            } else {
              AddItem addItem = AddItem(
                Item(
                  imageURL: _itemImage,
                  name: _nameController.text.trimRight(),
                  currency: _selectedCurrency.shortName,
                  price: double.parse(_priceController.text),
                  sku: _skuController.text,
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
