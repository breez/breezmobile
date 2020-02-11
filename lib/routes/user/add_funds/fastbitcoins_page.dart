import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/fastbitcoins/fastbitcoins_bloc.dart';
import 'package:breez/bloc/fastbitcoins/fastbitcoins_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/user/add_funds/fastbitcoins_confirm.dart';
import 'package:breez/utils/qr_scan.dart' as QRScanner;
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/transparent_page_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class FastbitcoinsPage extends StatefulWidget {
  final String fastBitcoinUrl;

  const FastbitcoinsPage({Key key, this.fastBitcoinUrl}) : super(key: key);

  @override
  FastbitcoinsPageState createState() {
    return FastbitcoinsPageState();
  }
}

class FastbitcoinsPageState extends State<FastbitcoinsPage> {
  final String _title = "FastBitcoins.com";
  String _currency = "USD";
  final _formKey = GlobalKey<FormState>();
  String _scannerErrorMessage = "";
  final _codeController = TextEditingController();
  final _valueController = TextEditingController();
  final _emailController = TextEditingController();

  FastbitcoinsBloc _fastBitcoinsBloc;
  UserProfileBloc _userProfileBloc;
  StreamSubscription _validatedRequestsSubscription;
  StreamSubscription _redeemedRequestsSubscription;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _fastBitcoinsBloc = AppBlocsProvider.of<FastbitcoinsBloc>(context);
      _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      if (widget.fastBitcoinUrl != null) {
        String voucherCode = widget.fastBitcoinUrl.split("/").last;
        _codeController.text = voucherCode;
      }
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

  Future _scanBarcode() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      String barcode = await QRScanner.scan();
      String _voucherCode = barcode.substring(barcode.lastIndexOf("/") + 1);
      setState(() {
        _codeController.text = _voucherCode;
        _scannerErrorMessage = "";
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this._scannerErrorMessage =
              'Please grant Breez camera permission to scan QR codes.';
        });
      } else {
        setState(() => this._scannerErrorMessage = '');
      }
    } on FormatException {
      setState(() => this._scannerErrorMessage = '');
    } catch (e) {
      setState(() => this._scannerErrorMessage = '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          automaticallyImplyLeading: false,
          leading: backBtn.BackButton(),
          title: Text(
            _title,
            style: Theme.of(context).appBarTheme.textTheme.title,
          ),
          elevation: 0.0),
      body: Padding(
          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            labelText: "Voucher Code",
                            hintText: "Enter your voucher code",
                            suffixIcon: IconButton(
                              padding: EdgeInsets.only(top: 21.0),
                              alignment: Alignment.bottomRight,
                              icon: Image(
                                image: AssetImage("src/icon/qr_scan.png"),
                                color: theme.BreezColors.white[500],
                                fit: BoxFit.contain,
                                width: 24.0,
                                height: 24.0,
                              ),
                              tooltip: 'Scan Barcode',
                              onPressed: _scanBarcode,
                            ),
                          ),
                          style: theme.FieldTextStyle.textStyle,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter a voucher code";
                            }
                          },
                        ),
                      ),
                      _scannerErrorMessage.length > 0
                          ? Text(
                              _scannerErrorMessage,
                              style: theme.validatorStyle,
                            )
                          : SizedBox(),
                      Container(
                        padding: EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          controller: _emailController,
                          decoration:
                              InputDecoration(labelText: "E-mail Address"),
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
                      Container(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Row(
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
                                    decoration: InputDecoration(
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
                                  child: FormField(
                                    builder: (FormFieldState state) {
                                      return DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField(
                                          isDense: true,
                                          decoration: InputDecoration(
                                            labelText: 'Currency',
                                            contentPadding: EdgeInsets.symmetric(vertical: 10.6),
                                          ),
                                          value: _currency,
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
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(value,
                                                  style: theme
                                                      .FieldTextStyle
                                                      .textStyle),
                                            );
                                          }).toList(),
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
      bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                  height: 48.0,
                  width: 168.0,
                  child: RaisedButton(
                    child: Text(
                      "CALCULATE",
                      style: Theme.of(context).textTheme.button,
                    ),
                    color: Theme.of(context).buttonColor,
                    elevation: 0.0,
                    shape: const StadiumBorder(),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        var _request = ValidateRequestModel(
                            _emailController.text.trim(),
                            _codeController.text.trim(),
                            double.parse(_valueController.text),
                            _currency);
                        Navigator.of(context).push(TransparentPageRoute(
                            (context) => RedeemVoucherRoute(_userProfileBloc,
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
  final UserProfileBloc _userProfileBloc;
  final ValidateRequestModel _voucherRequest;

  const RedeemVoucherRoute(
      this._userProfileBloc, this._fbBloc, this._voucherRequest);

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
    widget._userProfileBloc.userStream.first.then((user) {
      widget._fbBloc.validateRequestSink.add(widget._voucherRequest);

      _validateSubscription =
          widget._fbBloc.validateResponseStream.listen((res) async {
        showLoading(false);
        if (res.kycRequired == 1) {
          showKYCRequiredMessage();
          return;
        }

        Widget content = FastBitcoinsConfirmWidget(
            request: widget._voucherRequest, response: res, user: user);
        bool sure = await promptAreYouSure(context, "Confirm Order", content,
            textStyle: Theme.of(context).dialogTheme.contentTextStyle,
            okText: "CONFIRM",
            cancelText: "CANCEL",
            wideTitle: true,
            contentPadding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0));
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
                    style: Theme.of(context).dialogTheme.contentTextStyle))
            .whenComplete(() => popToForm());
      });
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
                  style: Theme.of(context).dialogTheme.contentTextStyle))
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
    var redeemRequest = RedeemRequestModel(
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
              style: Theme.of(context).dialogTheme.contentTextStyle),
          _LinkTextSpan(
              text: "fastbitcoins.com ",
              url: "https://fastbitcoins.com",
              style: theme.blueLinkStyle),
          TextSpan(
              text: "site.",
              style: Theme.of(context).dialogTheme.contentTextStyle)
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
