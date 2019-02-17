import 'dart:async';
import 'dart:convert';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/transparent_page_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/fastbitcoins/fastbitcoins_bloc.dart';
import 'package:breez/bloc/fastbitcoins/fastbitcoins_model.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:url_launcher/url_launcher.dart';

class FastbitcoinsPage extends StatefulWidget {
  @override
  FastbitcoinsPageState createState() {
    return FastbitcoinsPageState();
  }
}

class FastbitcoinsPageState extends State<FastbitcoinsPage> {
  final String _title = "FastBitcoins.com";
  String _currency = "USD";
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _valueController = TextEditingController();
  final _emailController = TextEditingController();

  FastbitcoinsBloc _fastBitcoinsBloc;
  StreamSubscription _validatedRequestsSubscription;
  StreamSubscription _redeemedRequestsSubscription;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _fastBitcoinsBloc = AppBlocsProvider.of<FastbitcoinsBloc>(context);
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
                      new Container(
                        padding: new EdgeInsets.only(top: 8.0),
                        child: new TextFormField(
                          controller: _codeController,
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
                        padding: new EdgeInsets.only(top: 8.0),
                        child: new TextFormField(
                          controller: _emailController,
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
                      new Container(
                          padding: new EdgeInsets.only(top: 8.0),
                          child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 10,
                                  child: TextFormField(
                                    controller: _valueController,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter(
                                          RegExp(r'\d+\.?\d*'))
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: new InputDecoration(
                                        // contentPadding:
                                        //           new EdgeInsets.only(
                                        //               bottom: 10.74*5),
                                        labelText: "Voucher Value",
                                        hintText:
                                            "Provide the redeemable value of your voucher",
                                        hintStyle: TextStyle(fontSize: 14.0)),
                                    style: theme.FieldTextStyle.textStyle,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter a voucher value";
                                      }
                                      if (double.tryParse(value) == null) {
                                        return "Please enter a valid number";
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: new FormField(
                                    builder: (FormFieldState state) {
                                      return InputDecorator(
                                        decoration: InputDecoration(
                                          labelText: 'Currency',
                                        ),
                                        child: Container(
                                          height: 21.3,
                                          child: DropdownButtonHideUnderline(
                                            child: new DropdownButton(
                                              value: _currency,
                                              isDense: true,                                              
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  _currency = newValue;
                                                  state.didChange(newValue);
                                                });
                                              },
                                              items: [
                                                "USD",
                                                "GBP",
                                                "EUR",
                                                "CAD",
                                                "AUD"
                                              ].map((String value) {
                                                return new DropdownMenuItem(
                                                  value: value,
                                                  child: new Text(value,
                                                      style: theme
                                                          .FieldTextStyle
                                                          .textStyle),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ])),
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
                        var _request = new ValidateRequestModel(
                            _emailController.text.trim(),
                            _codeController.text.trim(),
                            double.parse(_valueController.text),
                            _currency);
                        Navigator.of(context).push(TransparentPageRoute(
                            (context) => new RedeemVoucherRoute(
                                _fastBitcoinsBloc, _request)));
                      }
                    },
                  ))
            ],
          )),
    );
  }
}

class RedeemVoucherRoute extends StatefulWidget {
  final FastbitcoinsBloc _fbBloc;
  final ValidateRequestModel _voucherRequest;

  const RedeemVoucherRoute(this._fbBloc, this._voucherRequest);

  @override
  State<StatefulWidget> createState() {
    return RedeemVoucherRouteState();
  }
}

class RedeemVoucherRouteState extends State<RedeemVoucherRoute> {
  bool _loading = true;
  StreamSubscription<ValidateResponseModel> _validateSubscription;
  StreamSubscription<RedeemResponseModel> _redeemSubscription;

  @override
  void initState() {
    super.initState();
    widget._fbBloc.validateRequestSink.add(widget._voucherRequest);

    _validateSubscription =
        widget._fbBloc.validateResponseStream.listen((res) async {
      showLoading(false);
      if (res.kycRequired == 1) {
        showKYCRequiredMessage();
        return;
      }

      Text content = Text(
          'Are you sure you want to redeem ${res.value} ${widget._voucherRequest.currency}?',
          style: theme.dialogBlackStye);
      bool sure = await promptAreYouSure(context, "Redeem Voucher", content,
          textStyle: theme.dialogBlackStye);
      if (sure == true) {
        showLoading(true);
        _redeemRequest(res);
        return;
      }
      popToForm();
    }, onError: (err) {
      promptError(
              context,
              "Redeem Voucher",
              Text("Failed to redeem voucher: " + err.toString(),
                  style: theme.alertStyle))
          .whenComplete(() => popToForm());
    });

    _redeemSubscription = widget._fbBloc.redeemResponseStream.listen((vm) {
      showLoading(false);
      Navigator.popUntil(
          context, ModalRoute.withName(Navigator.defaultRouteName));
      showFlushbar(context, message: "Voucher was successfully redeemed!");
    }, onError: (err) {
      promptError(
              context,
              "Redeem Voucher",
              Text("Failed to redeem voucher: " + err.toString(),
                  style: theme.dialogBlackStye))
          .whenComplete(() => popToForm());
    });
  }

  @override
  void dispose() {
    _validateSubscription.cancel();
    _redeemSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return FullScreenLoader();
    }
    return SizedBox();
  }

  void popToForm() {
    Navigator.popUntil(context, ModalRoute.withName("/fastbitcoins"));
  }

  void showLoading(bool enabled) {
    if (_loading != enabled) {
      setState(() {
        _loading = enabled;
      });
    }
  }

  void _redeemRequest(ValidateResponseModel validateRes) {
    var redeemRequest = new RedeemRequestModel(
        widget._voucherRequest.emailAddress,
        widget._voucherRequest.code,
        widget._voucherRequest.value,
        widget._voucherRequest.currency,
        validateRes.quotationId,
        validateRes.quotationSecret);
    redeemRequest.validateResponse = validateRes;
    widget._fbBloc.redeemRequestSink.add(redeemRequest);
  }

  void showKYCRequiredMessage() {
    promptError(
        context,
        "Redeem Voucher",
        RichText(
            text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: "This voucher can be redeemed only in ",
              style: theme.dialogBlackStye),
          _LinkTextSpan(
              text: "fastbitcoins.com ",
              url: "https://fastbitcoins.com",
              style: theme.blueLinkStyle),
          TextSpan(text: "site.", style: theme.dialogBlackStye)
        ]))).whenComplete(() => popToForm());
  }
}

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(url, forceSafariVC: false);
              });
}
