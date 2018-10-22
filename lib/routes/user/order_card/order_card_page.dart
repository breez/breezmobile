import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/services/injector.dart';
import 'package:breez/services/breez_server/server.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;

class _CustomerData {
  String fullName = '';
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
  ScrollController _scrollController = new ScrollController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _zipController = TextEditingController();
  final FocusNode _cityFocusNode = new FocusNode();
  final FocusNode _stateFocusNode = new FocusNode();
  final FocusNode _countryFocusNode = new FocusNode();
  final FocusNode _zipFocusNode = new FocusNode();

  String _userCountryShort = "";
  Map _countriesJSON = new Map();
  Map _statesJSON = new Map();
  List<String> _specialCountriesShort = new List();
  List<String> _states = new List();
  List<String> _statesShow = new List();
  List<String> _countriesShow = new List();
  bool _showStatesList = false;
  bool _showCountriesList = false;
  bool _autoValidateState = false;
  bool _autoValidateCountry = false;
  bool _autoValidateZip = false;

  _CustomerData _data = new _CustomerData();

  BreezServer _breezServer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _breezServer = new ServiceInjector().breezServer;
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
    final response = await http.get(
        'http://api.ipstack.com/check?access_key=025a14ce39e8588578966edfe7e7d70a&output=json&fields=country_code');
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

  Widget _getFutureWidgetStates() {
    List<InkWell> list = new List();
    int number = _statesShow.length > 2 ? 3 : _statesShow.length;
    for (int i = 0; i < number; i++) {
      list.add(new InkWell(
        child: new Container(
            padding: new EdgeInsets.only(left: 10.0),
            alignment: Alignment.centerLeft,
            height: 35.0,
            child: new Text(_statesShow[i],
                overflow: TextOverflow.ellipsis,
                style: theme.autoCompleteStyle)),
        onTap: () {
          _stateController.text = _statesShow[i];
        },
      ));
    }

    return new Container(
        height: list.length * 35.0,
        width: MediaQuery.of(context).size.width,
        child: new ListView(children: list));
  }

  Widget _getFutureWidgetCountries() {
    List<InkWell> list = new List();
    int number = _countriesShow.length > 2 ? 3 : _countriesShow.length;
    for (int i = 0; i < number; i++) {
      list.add(new InkWell(
        child: new Container(
            padding: new EdgeInsets.only(left: 10.0),
            alignment: Alignment.centerLeft,
            height: 35.0,
            child: new Text(_countriesShow[i],
                overflow: TextOverflow.ellipsis,
                style: theme.autoCompleteStyle)),
        onTap: () {
          _countryController.text = _countriesShow[i];
        },
      ));
    }

    return new Container(
        height: list.length * 35.0,
        width: MediaQuery.of(context).size.width,
        child: new ListView(children: list));
  }

  List<Widget> _showSkipButton(showSkip) {
    if (showSkip) {
      return <Widget>[
        new InkWell(
            child: new Container(
                margin: new EdgeInsets.only(right: 16.5),
                alignment: Alignment.center,
                child: new Text("SKIP", style: theme.skipStyle)),
            onTap: () {
              Navigator.of(context).pushNamed('/home');
            })
      ];
    } else {
      return <Widget>[];
    }
  }

  void _showAlertDialog() {
    AlertDialog dialog = new AlertDialog(
      content: new Text(
          "Name and address are required for sending you a Breez card. Any information provided will be deleted from our systems after card has been sent. You may skip this step and continue using Breez without a card.",
          style: theme.alertStyle),
      actions: <Widget>[
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: new Text("OK", style: theme.buttonStyle))
      ],
    );
    showDialog(context: context,  builder: (_) => dialog);
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
    return new Scaffold(
      appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
          automaticallyImplyLeading: false,
          leading: _showLeadingButton(_showSkip),
          title: new Text(
            _title,
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0,
          actions: _showSkipButton(_showSkip)),
      body: new Padding(
          padding: new EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Form(
              key: _formKey,
              child: new ListView(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.only(top: 8.0),
                        child: new TextFormField(
                          decoration:
                          new InputDecoration(labelText: "Full Name"),
                          style: theme.FieldTextStyle.textStyle,
                          textCapitalization: TextCapitalization.words,
                          onSaved: (String value) {
                            this._data.fullName = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your full name";
                            }
                          },
                        ),
                      ),
                      new Container(
                        padding: new EdgeInsets.only(top: 19.0),
                        child: new TextFormField(
                          decoration: new InputDecoration(labelText: "Address"),
                          style: theme.FieldTextStyle.textStyle,
                          textCapitalization: TextCapitalization.words,
                          onSaved: (String value) {
                            this._data.address = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your address";
                            }
                          },
                        ),
                      ),
                      new Stack(children: <Widget>[
                        new Column(
                          children: <Widget>[
                            new Container(
                              padding: new EdgeInsets.only(top: 19.0),
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Expanded(
                                    flex: 200,
                                    child: new Container(
                                      child: new TextFormField(
                                        focusNode: _cityFocusNode,
                                        decoration: new InputDecoration(
                                            labelText: "City"),
                                        style: theme.FieldTextStyle.textStyle,
                                        textCapitalization: TextCapitalization.words,
                                        onSaved: (String value) {
                                          this._data.city = value;
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Please enter your city";
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                    flex: 128,
                                    child: new Container(
                                      margin: new EdgeInsets.only(left: 8.0),
                                      child: new TextFormField(
                                        autovalidate: _autoValidateState,
                                        controller: _stateController,
                                        focusNode: _stateFocusNode,
                                        decoration: new InputDecoration(
                                            labelText: "State"),
                                        style: theme.FieldTextStyle.textStyle,
                                        textCapitalization: TextCapitalization.words,
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
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            new Stack(children: <Widget>[
                              new Column(children: <Widget>[
                                new Container(
                                  padding: new EdgeInsets.only(top: 19.0),
                                  child: new Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      new Expanded(
                                        flex: 200,
                                        child: new Container(
                                          child: new TextFormField(
                                            autovalidate: _autoValidateCountry,
                                            controller: _countryController,
                                            focusNode: _countryFocusNode,
                                            decoration: new InputDecoration(
                                                labelText: "Country"),
                                            style: theme.FieldTextStyle.textStyle,
                                            textCapitalization: TextCapitalization.words,
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
                                            },
                                          ),
                                        ),
                                      ),
                                      new Expanded(
                                        flex: 128,
                                        child: new Container(
                                          margin: new EdgeInsets.only(left: 8.0),
                                          child: new TextFormField(
                                            autovalidate: _autoValidateZip,
                                            controller: _zipController,
                                            focusNode: _zipFocusNode,
                                            decoration: new InputDecoration(labelText: "Zip"),
                                            style: theme.FieldTextStyle.textStyle,
                                            keyboardType: TextInputType.number,
                                            onSaved: (String value) {
                                              this._data.zip = value;
                                            },
                                            validator: (value) {
                                              RegExp regExp = new RegExp(
                                                  r"^(?!0{3})[0-9]{3,10}$");
                                              if (!regExp.hasMatch(value) &&
                                                  value.isNotEmpty) {
                                                return "Invalid zip code";
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                new Padding(
                                  padding: new EdgeInsets.only(top: 40.0),
                                  child: new InkWell(
                                      child: new Text(
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
                                  ? new Container(
                                  padding: new EdgeInsets.only(top: 77.5),
                                  child: new Row(
                                    children: <Widget>[
                                      new Expanded(
                                          flex: 200,
                                          child: new Container(
                                              decoration: theme
                                                  .autoCompleteBoxDecoration,
                                              child:
                                              _getFutureWidgetCountries())),
                                      new Expanded(
                                          flex: 128, child: new Container())
                                    ],
                                  ))
                                  : new Container()
                            ]),
                          ],
                        ),
                        _showStatesList
                            ? new Container(
                            padding: new EdgeInsets.only(top: 77.5),
                            child: new Row(
                              children: <Widget>[
                                new Expanded(
                                    flex: 208, child: new Container()),
                                new Expanded(
                                    flex: 120,
                                    child: new Container(
                                        decoration:
                                        theme.autoCompleteBoxDecoration,
                                        child: _getFutureWidgetStates()))
                              ],
                            ))
                            : new Container(),
                      ]),
                    ],
                  ),
                ],
              ))),
      bottomNavigationBar: new Padding(
          padding: new EdgeInsets.only(bottom: 40.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new SizedBox(
                  height: 48.0,
                  width: 168.0,
                  child: new RaisedButton(
                    child: new Text(
                      "ORDER",
                      style: theme.buttonStyle,
                    ),
                    color: theme.BreezColors.white[500],
                    elevation: 0.0,
                    shape: const StadiumBorder(),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _breezServer
                            .orderCard(
                            _data.fullName,
                            _data.address,
                            _data.city,
                            _data.state,
                            _data.zip,
                            _data.country)
                            .then((reply) {
                          Navigator.pop(context,
                              "Breez card will be sent shortly to the address you have specified.");
                        }).catchError((error) {
                          print(error.toString());
                          Scaffold.of(context).showSnackBar(new SnackBar(
                              content: new Text(error.toString())));
                        });
                      } else {}
                    },
                  ))
            ],
          )),
    );
  }
}
