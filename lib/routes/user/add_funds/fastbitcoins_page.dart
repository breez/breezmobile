import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/fastbitcoins/fastbitcoins_bloc.dart';
import 'package:breez/bloc/fastbitcoins/fastbitcoins_model.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;

class FastbitcoinsPage extends StatefulWidget {
  @override
  FastbitcoinsPageState createState() {
    return FastbitcoinsPageState();
  }
}

class FastbitcoinsPageState extends State<FastbitcoinsPage> {
  final String _title = "Fastbitcoins";
  final String _currency = "USD";
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _valueController = TextEditingController();
  final _emailController = TextEditingController();

  FastbitcoinsBloc _fastBitcoinsBloc;
  StreamSubscription _validatedRequestsSubscription;
  StreamSubscription _redeemedRequestsSubscription;
  bool _isInit = false;
  bool _isValidating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*
    // Testing purposes
    _codeController.text = "a";
    _valueController.text = "1";
    _emailController.text = "a@a.com";
    */
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _fastBitcoinsBloc = AppBlocsProvider.of<FastbitcoinsBloc>(context);
      _validatedRequestsSubscription =
          _fastBitcoinsBloc.validateResponseStream.listen((res) async {
        int _error = int.parse(jsonEncode(res.toJson()['error']));
        int _kycRequired = int.parse(jsonEncode(res.toJson()['kyc_required']));
        if (_error == 1) {
          _showAlertDialog(jsonEncode(res.toJson()['error_message']));
          _isValidating = false;
        } else if (_kycRequired == 1) {
          _showAlertDialog("KYC Required.\nBreez does not support ...");
          _isValidating = false;
        } else {
          print("Validation Successful.");
          Text content = Text(
              'Are you sure you want to redeem ${res.toJson()['value']} ${res.toJson()['currency']} ... ?',
              style: theme.textStyle);
          bool sure = await promptAreYouSure(context, null, content,
              textStyle: theme.buttonStyle);
          if (sure) {
            _redeemRequest();
          }
        }
      });
      _redeemedRequestsSubscription =
          _fastBitcoinsBloc.redeemResponseStream.listen((res) {
        //Todo
        print(jsonEncode(res.toJson()));
        //_isValidating = false;
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _validatedRequestsSubscription?.cancel();
    _redeemedRequestsSubscription?.cancel();
    super.dispose();
  }

  bool _validateEmail(String value) {
    return RegExp(
            r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value);
  }

  Future _validateRequest() async {
    var _request = new ValidateRequestModel(_emailController.text,
        _codeController.text, double.parse(_valueController.text), _currency);
    _fastBitcoinsBloc.validateRequestSink.add(_request);
  }

  void _showAlertDialog(String message) {
    AlertDialog dialog = new AlertDialog(
      title: Text("Error", style: theme.alertTitleStyle),
      content: new Text(message, style: theme.alertStyle),
      actions: <Widget>[
        new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: new Text("OK", style: theme.buttonStyle))
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  void _redeemRequest() {
    var redeemRequest = new RedeemRequestModel(
        _emailController.text,
        _codeController.text,
        double.parse(_valueController.text),
        _currency,
        0,
        "");
    _fastBitcoinsBloc.redeemRequestSink.add(redeemRequest);
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
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      /*
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFff7c10),
                            border: Border.all(
                                color: Colors.white,
                                style: BorderStyle.solid,
                                width: 1.0),
                            borderRadius: BorderRadius.circular(14.0)),
                        width: 330.0,
                        height: 96.0,
                        child: Image(
                          image: AssetImage(
                              "src/icon/vendors/fastbitcoins-logo-lg.png"),
                          color: Color(0xFF1f2a44),
                        ),
                      ),
                      */
                      new Container(
                        padding: new EdgeInsets.only(top: 8.0),
                        child: new TextFormField(
                          controller: _codeController,
                          enabled: !_isValidating,
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
                          controller: _valueController,
                          enabled: !_isValidating,
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
                          controller: _emailController,
                          enabled: !_isValidating,
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
                        _isValidating = true;
                        _validateRequest();
                      }
                    },
                  ))
            ],
          )),
    );
  }
}
