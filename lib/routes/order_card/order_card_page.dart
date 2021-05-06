import 'dart:async';
import 'dart:convert';

import 'package:breez/services/breez_server/server.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/single_button_bottom_bar.dart';
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

  OrderCardPage({Key key, this.showSkip}) : super(key: key);

  @override
  OrderCardPageState createState() {
    return OrderCardPageState();
  }
}

class OrderCardPageState extends State<OrderCardPage> {
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _zipController = TextEditingController();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _zipFocusNode = FocusNode();

  String _userCountryShort = "";
  Map _countriesJSON = Map();
  Map _statesJSON = Map();
  List<String> _specialCountriesShort = [];
  List<String> _states = [];
  List<String> _statesShow = [];
  List<String> _countriesShow = [];
  bool _showStatesList = false;
  bool _showCountriesList = false;
  bool _autoValidateState = false;
  bool _autoValidateCountry = false;
  bool _autoValidateZip = false;

  _CustomerData _data = _CustomerData();

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
    if (inputText.length > 0) {
      _statesShow.clear();
      for (int i = 0; i < _states.length; i++) {
        if (_states[i].length >= inputText.length &&
            _states[i].toLowerCase().startsWith(inputText.toLowerCase())) {
          _statesShow.add(_states[i]);
        }
      }

      if (_statesShow.length > 0 &&
          !_statesShow.contains(inputText) &&
          _stateFocusNode.hasFocus) {
        _statesShow.sort();
        setState(() {
          _autoValidateState = false;
          _showStatesList = true;
          _scroll(40.0);
        });
      } else {
        setState(() {
          _autoValidateState = true;
          _showStatesList = false;
        });
      }
    } else {
      setState(() {
        _autoValidateState = false;
        _showStatesList = false;
      });
    }
  }

  void _onChangeCountry() {
    String inputText = _countryController.text;
    if (inputText.length > 0) {
      _countriesJSON.forEach(_iterateMapEntryGetCountryShort);
      _changeStatesList();

      _countriesShow.clear();
      _countriesJSON.forEach(_iterateMapEntryGetCountriesShow);

      if (_countriesShow.length > 0 &&
          !_countriesShow.contains(inputText) &&
          _countryFocusNode.hasFocus) {
        _countriesShow.sort();
        setState(() {
          _autoValidateCountry = false;
          _showCountriesList = true;
          _scroll(115.0);
        });
      } else {
        setState(() {
          _autoValidateCountry = true;
          _showCountriesList = false;
        });
      }
    } else {
      _states.clear();
      _countriesShow.clear();

      setState(() {
        _autoValidateCountry = false;
        _showCountriesList = false;
      });
    }
  }

  void _onChangeZip() {
    setState(() {
      _autoValidateZip =
          (_zipController.text.length > 0 && !_zipFocusNode.hasFocus);
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
    Uri uri = Uri.http("api.ipstack.com",
        "check?access_key=025a14ce39e8588578966edfe7e7d70a&output=json&fields=country_code");
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
    String jsonCountries =
        await rootBundle.loadString('src/json/countries.json');
    _countriesJSON = json.decode(jsonCountries);
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
    return _countriesJSON.values.firstWhere(
            (val) => val.toLowerCase() == _countryController.text.toLowerCase(),
            orElse: () => null) !=
        null;
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
            padding: EdgeInsets.only(left: 10.0),
            alignment: Alignment.centerLeft,
            height: 35.0,
            child: Text(_statesShow[i],
                overflow: TextOverflow.ellipsis,
                style: theme.autoCompleteStyle)),
        onTap: () {
          _stateController.text = _statesShow[i];
        },
      ));
    }

    return Container(
        height: list.length * 35.0,
        width: MediaQuery.of(context).size.width,
        child: ListView(children: list));
  }

  Widget _getFutureWidgetCountries() {
    List<InkWell> list = [];
    int number = _countriesShow.length > 2 ? 3 : _countriesShow.length;
    for (int i = 0; i < number; i++) {
      list.add(InkWell(
        child: Container(
            padding: EdgeInsets.only(left: 10.0),
            alignment: Alignment.centerLeft,
            height: 35.0,
            child: Text(_countriesShow[i],
                overflow: TextOverflow.ellipsis,
                style: theme.autoCompleteStyle)),
        onTap: () {
          _countryController.text = _countriesShow[i];
        },
      ));
    }

    return Container(
        height: list.length * 35.0,
        width: MediaQuery.of(context).size.width,
        child: ListView(children: list));
  }

  List<Widget> _showSkipButton(showSkip) {
    if (showSkip) {
      return <Widget>[
        InkWell(
            child: Container(
                margin: EdgeInsets.only(right: 16.5),
                alignment: Alignment.center,
                child: Text("SKIP", style: theme.skipStyle)),
            onTap: () {
              Navigator.of(context).pushNamed('/');
            })
      ];
    } else {
      return <Widget>[];
    }
  }

  void _showAlertDialog() {
    AlertDialog dialog = AlertDialog(
      content: Text(
          "Name and address are required for sending you a Breez card. Any information provided will be deleted from our systems after card has been sent. You may skip this step and continue using Breez without a card.",
          style: Theme.of(context).dialogTheme.contentTextStyle),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: Theme.of(context).primaryTextTheme.button))
      ],
    );
    showDialog(
        useRootNavigator: false, context: context, builder: (_) => dialog);
  }

  Widget _showLeadingButton(showSkip) {
    if (!showSkip) {
      return backBtn.BackButton();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _showSkip = widget.showSkip == null ? false : widget.showSkip;
    String _title = _showSkip ? "Order a Breez Card" : "Order Card";
    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          automaticallyImplyLeading: false,
          leading: _showLeadingButton(_showSkip),
          title: Text(
            _title,
            style: Theme.of(context).appBarTheme.textTheme.headline6,
          ),
          elevation: 0.0,
          actions: _showSkipButton(_showSkip)),
      body: Padding(
          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Full Name"),
                          style: theme.FieldTextStyle.textStyle,
                          textCapitalization: TextCapitalization.words,
                          onSaved: (String value) {
                            this._data.fullName = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your full name";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          decoration:
                              InputDecoration(labelText: "E-mail Address"),
                          style: theme.FieldTextStyle.textStyle,
                          textCapitalization: TextCapitalization.none,
                          onSaved: (String value) {
                            this._data.email = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your e-mail address";
                            } else if (!_validateEmail(value)) {
                              return "Invalid e-mail";
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 19.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: "Address"),
                          style: theme.FieldTextStyle.textStyle,
                          textCapitalization: TextCapitalization.words,
                          onSaved: (String value) {
                            this._data.address = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your address";
                            }
                            return null;
                          },
                        ),
                      ),
                      Stack(children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 19.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 200,
                                    child: Container(
                                      child: TextFormField(
                                        focusNode: _cityFocusNode,
                                        decoration:
                                            InputDecoration(labelText: "City"),
                                        style: theme.FieldTextStyle.textStyle,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        onSaved: (String value) {
                                          this._data.city = value;
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Please enter your city";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 128,
                                    child: Container(
                                      margin: EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        autovalidate: _autoValidateState,
                                        controller: _stateController,
                                        focusNode: _stateFocusNode,
                                        decoration:
                                            InputDecoration(labelText: "State"),
                                        style: theme.FieldTextStyle.textStyle,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        onSaved: (String value) {
                                          this._data.state = value;
                                        },
                                        validator: (value) {
                                          if (value.isEmpty &&
                                              _specialCountriesShort.contains(
                                                  _userCountryShort)) {
                                            return "Enter your state";
                                          } else if (_specialCountriesShort
                                                  .contains(
                                                      _userCountryShort) &&
                                              _checkStates(value)) {
                                            return "Invalid state";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Stack(children: <Widget>[
                              Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 19.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 200,
                                        child: Container(
                                          child: TextFormField(
                                            autovalidate: _autoValidateCountry,
                                            controller: _countryController,
                                            focusNode: _countryFocusNode,
                                            decoration: InputDecoration(
                                                labelText: "Country"),
                                            style:
                                                theme.FieldTextStyle.textStyle,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            onSaved: (String value) {
                                              this._data.country = value;
                                            },
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Please enter your country";
                                              } else if (!_checkCountry(
                                                  value)) {
                                                return "Invalid country";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 128,
                                        child: Container(
                                          margin: EdgeInsets.only(left: 8.0),
                                          child: TextFormField(
                                            autovalidate: _autoValidateZip,
                                            controller: _zipController,
                                            focusNode: _zipFocusNode,
                                            decoration: InputDecoration(
                                                labelText: "Zip"),
                                            style:
                                                theme.FieldTextStyle.textStyle,
                                            keyboardType: TextInputType.number,
                                            onSaved: (String value) {
                                              this._data.zip = value;
                                            },
                                            validator: (value) {
                                              if (value.isNotEmpty &&
                                                  !_validateZip(value)) {
                                                return "Invalid zip code";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 40.0),
                                  child: InkWell(
                                      child: Text(
                                        "Why do I need to provide\nthis information?",
                                        textAlign: TextAlign.center,
                                        style: theme.linkStyle,
                                      ),
                                      onTap: () {
                                        _showAlertDialog();
                                      }),
                                ),
                              ]),
                              _showCountriesList
                                  ? Container(
                                      padding: EdgeInsets.only(top: 77.5),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              flex: 200,
                                              child: Container(
                                                  decoration: theme
                                                      .autoCompleteBoxDecoration,
                                                  child:
                                                      _getFutureWidgetCountries())),
                                          Expanded(
                                              flex: 128, child: Container())
                                        ],
                                      ))
                                  : Container()
                            ]),
                          ],
                        ),
                        _showStatesList
                            ? Container(
                                padding: EdgeInsets.only(top: 77.5),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(flex: 208, child: Container()),
                                    Expanded(
                                        flex: 120,
                                        child: Container(
                                            decoration:
                                                theme.autoCompleteBoxDecoration,
                                            child: _getFutureWidgetStates()))
                                  ],
                                ))
                            : Container(),
                      ]),
                    ],
                  ),
                ],
              ))),
      bottomNavigationBar: SingleButtonBottomBar(
        text: "ORDER",
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            _breezServer
                .orderCard(_data.fullName, _data.email, _data.address,
                    _data.city, _data.state, _data.zip, _data.country)
                .then((reply) {
              Navigator.pop(context,
                  "Breez card will be sent shortly to the address you have specified.");
            }).catchError((error) {
              print(error.toString());
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error.toString())));
            });
          } else {}
        },
      ),
    );
  }
}
