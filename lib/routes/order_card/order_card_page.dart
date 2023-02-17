import 'dart:async';
import 'dart:convert';

import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class _CustomerData {
  String fullName = '';
  String email = '';
  String address = '';
  String city = '';
  String state = '';
  String zip = '';
  String country = '';
}

class OrderCardPage extends StatefulWidget {
  final bool showSkip;

  const OrderCardPage({
    Key key,
    this.showSkip,
  }) : super(key: key);

  @override
  OrderCardPageState createState() {
    return OrderCardPageState();
  }
}

class OrderCardPageState extends State<OrderCardPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _zipController = TextEditingController();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _zipFocusNode = FocusNode();

  String _userCountryShort = "";
  Map _countriesJSON = {};
  Map _statesJSON = {};
  final List<String> _specialCountriesShort = [];
  List<String> _states = [];
  final List<String> _statesShow = [];
  final List<String> _countriesShow = [];
  bool _showStatesList = false;
  bool _showCountriesList = false;
  AutovalidateMode _autoValidateState = AutovalidateMode.disabled;
  AutovalidateMode _autoValidateCountry = AutovalidateMode.disabled;
  AutovalidateMode _autoValidateZip = AutovalidateMode.disabled;

  final _CustomerData _data = _CustomerData();

  BreezServer _breezServer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _breezServer = ServiceInjector().breezServer;
    _stateController.addListener(_onChangeState);
    _countryController.addListener(_onChangeCountry);
    _zipController.addListener(_onChangeZip);

    _cityFocusNode.addListener(_onFocusCityStateRow);
    _stateFocusNode.addListener(_onFocusCityStateRow);
    _countryFocusNode.addListener(_onFocusCountryZipRow);
    _zipFocusNode.addListener(_onFocusCountryZipRow);
  }

  void _scroll(double value) {
    setState(() {
      _scrollController.animateTo(
        value,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void _onFocusCityStateRow() {
    if (_cityFocusNode.hasFocus || _stateFocusNode.hasFocus) {
      _scroll(40.0);
    }
  }

  void _onFocusCountryZipRow() {
    if (_countryFocusNode.hasFocus || _zipFocusNode.hasFocus) {
      _scroll(115.0);
    }
  }

  void _onChangeState() {
    String inputText = _stateController.text;
    if (inputText.isNotEmpty) {
      _statesShow.clear();
      for (int i = 0; i < _states.length; i++) {
        if (_states[i].length >= inputText.length &&
            _states[i].toLowerCase().startsWith(inputText.toLowerCase())) {
          _statesShow.add(_states[i]);
        }
      }

      if (_statesShow.isNotEmpty &&
          !_statesShow.contains(inputText) &&
          _stateFocusNode.hasFocus) {
        _statesShow.sort();
        setState(() {
          _autoValidateState = AutovalidateMode.disabled;
          _showStatesList = true;
          _scroll(40.0);
        });
      } else {
        setState(() {
          _autoValidateState = AutovalidateMode.always;
          _showStatesList = false;
        });
      }
    } else {
      setState(() {
        _autoValidateState = AutovalidateMode.disabled;
        _showStatesList = false;
      });
    }
  }

  void _onChangeCountry() {
    String inputText = _countryController.text;
    if (inputText.isNotEmpty) {
      _countriesJSON.forEach(_iterateMapEntryGetCountryShort);
      _changeStatesList();

      _countriesShow.clear();
      _countriesJSON.forEach(_iterateMapEntryGetCountriesShow);

      if (_countriesShow.isNotEmpty &&
          !_countriesShow.contains(inputText) &&
          _countryFocusNode.hasFocus) {
        _countriesShow.sort();
        setState(() {
          _autoValidateCountry = AutovalidateMode.disabled;
          _showCountriesList = true;
          _scroll(115.0);
        });
      } else {
        setState(() {
          _autoValidateCountry = AutovalidateMode.always;
          _showCountriesList = false;
        });
      }
    } else {
      _states.clear();
      _countriesShow.clear();

      setState(() {
        _autoValidateCountry = AutovalidateMode.disabled;
        _showCountriesList = false;
      });
    }
  }

  void _onChangeZip() {
    setState(() {
      _autoValidateZip =
          (_zipController.text.isNotEmpty && !_zipFocusNode.hasFocus)
              ? AutovalidateMode.always
              : AutovalidateMode.disabled;
    });
  }

  void _iterateMapEntryGetCountriesShow(key, value) {
    String inputText = _countryController.text;
    if (value.length >= inputText.length &&
        value.toLowerCase().startsWith(inputText.toLowerCase())) {
      _countriesShow.add(value);
    }
  }

  void _iterateMapEntryGetCountryShort(key, value) {
    if (value.toString().toLowerCase() ==
        _countryController.text.toLowerCase()) {
      _userCountryShort = key;
    }
  }

  void _loadData() async {
    _specialCountriesShort.add("US");
    _specialCountriesShort.add("CA");
    Uri uri = Uri.http(
      "api.ipstack.com",
      "check",
      {
        "access_key": "025a14ce39e8588578966edfe7e7d70a",
        "output": "json",
        "fields": "country_code"
      },
    );
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Map data = json.decode(response.body);
      _userCountryShort = data["country_code"];
    } else {
      Locale myLocale = Localizations.localeOf(context);
      _userCountryShort = myLocale.countryCode;
    }
    await _loadCountries();
    await _loadStates();
    _changeStatesList();
  }

  Future _loadCountries() async {
    _countriesJSON = json.decode(
      await rootBundle.loadString('src/json/countries.json'),
    );
    _countryController.text = _countriesJSON[_userCountryShort];
  }

  Future _loadStates() async {
    String jsonStates = await rootBundle.loadString('src/json/states.json');
    _statesJSON = json.decode(jsonStates);
  }

  void _changeStatesList() {
    _states.clear();
    if (_statesJSON.isNotEmpty) {
      _states = (_statesJSON["states"] as List)
          .where((state) => state["country"] == _userCountryShort)
          .map<String>((state) => state["english"] ?? state["name"])
          .toList();
    }
  }

  bool _checkStates(String value) {
    for (int i = 0; i < _states.length; i++) {
      if (_states[i].toLowerCase() == value.toLowerCase()) {
        return false;
      }
    }
    return true;
  }

  bool _checkCountry(String value) {
    final firstCountry = _countriesJSON.values.firstWhere(
      (val) => val.toLowerCase() == _countryController.text.toLowerCase(),
      orElse: () => null,
    );
    return firstCountry != null;
  }

  bool _validateEmail(String value) {
    return RegExp(
            r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value);
  }

  bool _validateZip(String value) {
    return RegExp(r"^(?!0{3})[0-9]{3,10}$").hasMatch(value);
  }

  Widget _getFutureWidgetStates() {
    List<InkWell> list = [];
    int number = _statesShow.length > 2 ? 3 : _statesShow.length;
    for (int i = 0; i < number; i++) {
      list.add(InkWell(
        child: Container(
          padding: const EdgeInsets.only(left: 10.0),
          alignment: Alignment.centerLeft,
          height: 35.0,
          child: Text(
            _statesShow[i],
            overflow: TextOverflow.ellipsis,
            style: theme.autoCompleteStyle,
          ),
        ),
        onTap: () {
          _stateController.text = _statesShow[i];
        },
      ));
    }

    return SizedBox(
      height: list.length * 35.0,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: list,
      ),
    );
  }

  Widget _getFutureWidgetCountries() {
    List<InkWell> list = [];
    int number = _countriesShow.length > 2 ? 3 : _countriesShow.length;
    for (int i = 0; i < number; i++) {
      list.add(InkWell(
        child: Container(
          padding: const EdgeInsets.only(left: 10.0),
          alignment: Alignment.centerLeft,
          height: 35.0,
          child: Text(
            _countriesShow[i],
            overflow: TextOverflow.ellipsis,
            style: theme.autoCompleteStyle,
          ),
        ),
        onTap: () {
          _countryController.text = _countriesShow[i];
        },
      ));
    }

    return SizedBox(
      height: list.length * 35.0,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: list,
      ),
    );
  }

  List<Widget> _showSkipButton(BuildContext context, bool showSkip) {
    final texts = context.texts();

    if (showSkip) {
      return [
        InkWell(
          child: Container(
            margin: const EdgeInsets.only(right: 16.5),
            alignment: Alignment.center,
            child: Text(
              texts.order_card_action_skip,
              style: theme.skipStyle,
            ),
          ),
          onTap: () => Navigator.of(context).pushNamed('/'),
        ),
      ];
    } else {
      return [];
    }
  }

  void _showAlertDialog(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    showDialog(
      useRootNavigator: false,
      context: context,
      builder: (_) => AlertDialog(
        content: Text(
          texts.order_card_action_error_name_address_missing,
          style: themeData.dialogTheme.contentTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              texts.order_card_action_ok,
              style: themeData.primaryTextTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _showLeadingButton(bool showSkip) {
    if (!showSkip) {
      return const backBtn.BackButton();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    bool showSkip = widget.showSkip ?? false;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: _showLeadingButton(showSkip),
        title: Text(
          showSkip
              ? texts.order_card_action_order_breez_card
              : texts.order_card_action_order_card,
        ),
        actions: _showSkipButton(context, showSkip),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            children: [
              Column(
                children: [
                  _fullName(context),
                  _email(context),
                  _address(context),
                  Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 19.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _city(context),
                                _state(context),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 19.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _country(context),
                                        _zipCode(context),
                                      ],
                                    ),
                                  ),
                                  _disclaimer(context),
                                ],
                              ),
                              _countriesList(),
                            ],
                          ),
                        ],
                      ),
                      _statesList(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SingleButtonBottomBar(
        text: texts.order_card_action_order,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            _breezServer
                .orderCard(
                  _data.fullName,
                  _data.email,
                  _data.address,
                  _data.city,
                  _data.state,
                  _data.zip,
                  _data.country,
                )
                .then(
                  (reply) => Navigator.pop(context, texts.order_card_success),
                )
                .catchError(
                  (error) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error.toString()),
                    ),
                  ),
                );
          }
        },
      ),
    );
  }

  Widget _fullName(BuildContext context) {
    final texts = context.texts();
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: texts.order_card_full_name_label,
        ),
        style: theme.FieldTextStyle.textStyle,
        textCapitalization: TextCapitalization.words,
        onSaved: (String value) {
          _data.fullName = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return texts.order_card_full_name_error;
          }
          return null;
        },
      ),
    );
  }

  Widget _email(BuildContext context) {
    final texts = context.texts();
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: texts.order_card_email_label,
        ),
        style: theme.FieldTextStyle.textStyle,
        textCapitalization: TextCapitalization.none,
        onSaved: (String value) {
          _data.email = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return texts.order_card_country_email_empty;
          } else if (!_validateEmail(value)) {
            return texts.order_card_country_email_invalid;
          }
          return null;
        },
      ),
    );
  }

  Widget _address(BuildContext context) {
    final texts = context.texts();
    return Container(
      padding: const EdgeInsets.only(top: 19.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: texts.order_card_address_label,
        ),
        style: theme.FieldTextStyle.textStyle,
        textCapitalization: TextCapitalization.words,
        onSaved: (String value) {
          _data.address = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return texts.order_card_address_error;
          }
          return null;
        },
      ),
    );
  }

  Widget _city(BuildContext context) {
    final texts = context.texts();
    return Expanded(
      flex: 200,
      child: TextFormField(
        focusNode: _cityFocusNode,
        decoration: InputDecoration(
          labelText: texts.order_card_city_label,
        ),
        style: theme.FieldTextStyle.textStyle,
        textCapitalization: TextCapitalization.words,
        onSaved: (String value) {
          _data.city = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return texts.order_card_city_error;
          }
          return null;
        },
      ),
    );
  }

  Widget _state(BuildContext context) {
    final texts = context.texts();
    return Expanded(
      flex: 128,
      child: Container(
        margin: const EdgeInsets.only(left: 8.0),
        child: TextFormField(
          autovalidateMode: _autoValidateState,
          controller: _stateController,
          focusNode: _stateFocusNode,
          decoration: InputDecoration(
            labelText: texts.order_card_state_label,
          ),
          style: theme.FieldTextStyle.textStyle,
          textCapitalization: TextCapitalization.words,
          onSaved: (String value) {
            _data.state = value;
          },
          validator: (value) {
            if (value.isEmpty &&
                _specialCountriesShort.contains(_userCountryShort)) {
              return texts.order_card_country_state_empty;
            } else if (_specialCountriesShort.contains(_userCountryShort) &&
                _checkStates(value)) {
              return texts.order_card_country_state_invalid;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _country(BuildContext context) {
    final texts = context.texts();
    return Expanded(
      flex: 200,
      child: TextFormField(
        autovalidateMode: _autoValidateCountry,
        controller: _countryController,
        focusNode: _countryFocusNode,
        decoration: InputDecoration(
          labelText: texts.order_card_country_label,
        ),
        style: theme.FieldTextStyle.textStyle,
        textCapitalization: TextCapitalization.words,
        onSaved: (String value) {
          _data.country = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return texts.order_card_country_error_empty;
          } else if (!_checkCountry(value)) {
            return texts.order_card_country_error_invalid;
          }
          return null;
        },
      ),
    );
  }

  Widget _zipCode(BuildContext context) {
    final texts = context.texts();
    return Expanded(
      flex: 128,
      child: Container(
        margin: const EdgeInsets.only(left: 8.0),
        child: TextFormField(
          autovalidateMode: _autoValidateZip,
          controller: _zipController,
          focusNode: _zipFocusNode,
          decoration: InputDecoration(
            labelText: texts.order_card_zip_code_label,
          ),
          style: theme.FieldTextStyle.textStyle,
          keyboardType: TextInputType.number,
          onSaved: (String value) {
            _data.zip = value;
          },
          validator: (value) {
            if (value.isNotEmpty && !_validateZip(value)) {
              return texts.order_card_zip_code_error;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _disclaimer(BuildContext context) {
    final texts = context.texts();
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: InkWell(
        child: Text(
          texts.order_card_info_disclaimer,
          textAlign: TextAlign.center,
          style: theme.linkStyle,
        ),
        onTap: () => _showAlertDialog(context),
      ),
    );
  }

  Widget _countriesList() {
    return _showCountriesList
        ? Container(
            padding: const EdgeInsets.only(top: 77.5),
            child: Row(
              children: [
                Expanded(
                  flex: 200,
                  child: Container(
                    decoration: theme.autoCompleteBoxDecoration,
                    child: _getFutureWidgetCountries(),
                  ),
                ),
                Expanded(
                  flex: 128,
                  child: Container(),
                )
              ],
            ),
          )
        : Container();
  }

  Widget _statesList() {
    return _showStatesList
        ? Container(
            padding: const EdgeInsets.only(top: 77.5),
            child: Row(
              children: [
                Expanded(
                  flex: 208,
                  child: Container(),
                ),
                Expanded(
                  flex: 120,
                  child: Container(
                    decoration: theme.autoCompleteBoxDecoration,
                    child: _getFutureWidgetStates(),
                  ),
                )
              ],
            ),
          )
        : Container();
  }
}
