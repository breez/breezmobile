import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;

class FastbitcoinsPage extends StatefulWidget {
  @override
  FastbitcoinsPageState createState() {
    return FastbitcoinsPageState();
  }
}

class FastbitcoinsPageState extends State<FastbitcoinsPage> {
  String _title = "Fastbitcoins";
  final _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = new ScrollController();
  final _codeController = TextEditingController();
  final _valueController = TextEditingController();
  final _emailController = TextEditingController();
  final FocusNode _codeFocusNode = new FocusNode();
  final FocusNode _valueFocusNode = new FocusNode();
  final FocusNode _emailFocusNode = new FocusNode();

  bool _autoValidateCode = false;
  bool _autoValidateValue = false;
  bool _autoValidateEmail = false;

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_onChangeCode);
    _valueController.addListener(_onChangeValue);
    _emailController.addListener(_onChangeEmail);

    _codeFocusNode.addListener(_onFocusCodeRow);
    _valueFocusNode.addListener(_onFocusValueRow);
    _emailFocusNode.addListener(_onFocusEmailRow);
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

  void _onFocusCodeRow() {}

  void _onFocusValueRow() {}

  void _onFocusEmailRow() {}

  void _onChangeCode() {}

  void _onChangeValue() {}

  void _onChangeEmail() {}

  bool _validateEmail(String value) {
    return RegExp(
            r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value);
  }

  void _showAlertDialog() {
    AlertDialog dialog = new AlertDialog(
      content: new Text("Test", style: theme.alertStyle),
      actions: <Widget>[
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: new Text("OK", style: theme.buttonStyle))
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: theme.BreezColors.blue[500],
          automaticallyImplyLeading: false,
          leading: backBtn.BackButton(),
          title: new Text(
            _title,
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0),
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
                          autovalidate: _autoValidateCode,
                          controller: _codeController,
                          focusNode: _codeFocusNode,
                          decoration: new InputDecoration(
                              labelText: "Voucher Code",
                              hintText: "Enter your voucher code"),
                          style: theme.FieldTextStyle.textStyle,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter a voucher code";
                            }
                          },
                        ),
                      ),
                      new Container(
                        padding: new EdgeInsets.only(top: 19.0),
                        child: new TextFormField(
                          autovalidate: _autoValidateValue,
                          controller: _valueController,
                          focusNode: _valueFocusNode,
                          decoration: new InputDecoration(
                              labelText: "Voucher Value",
                              hintText:
                                  "Provide the redeemable value of your voucher",
                              hintStyle: TextStyle(fontSize: 14.0)),
                          style: theme.FieldTextStyle.textStyle,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter a voucher value";
                            }
                          },
                        ),
                      ),
                      new Container(
                        padding: new EdgeInsets.only(top: 8.0),
                        child: new TextFormField(
                          autovalidate: _autoValidateEmail,
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          decoration:
                              new InputDecoration(labelText: "E-mail Address"),
                          style: theme.FieldTextStyle.textStyle,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter your e-mail address";
                            } else if (!_validateEmail(value)) {
                              return "Invalid e-mail";
                            }
                          },
                        ),
                      ),
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
                      "CALCULATE",
                      style: theme.buttonStyle,
                    ),
                    color: theme.BreezColors.white[500],
                    elevation: 0.0,
                    shape: const StadiumBorder(),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _showAlertDialog();
                      }
                    },
                  ))
            ],
          )),
    );
  }
}
