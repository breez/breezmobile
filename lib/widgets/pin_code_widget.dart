import 'dart:math';

import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';

const PIN_CODE_LENGTH = 6;

class PinCodeWidget extends StatefulWidget {
  final String label;
  final bool dismissible;
  final Future Function(String pinEntered) onPinEntered;
  final Function(bool isValid) onFingerprintEntered;
  final UserProfileBloc userProfileBloc;
  final String localizedReason;

  PinCodeWidget(this.label, this.dismissible, this.onPinEntered,
      {this.onFingerprintEntered, this.userProfileBloc, this.localizedReason});

  @override
  State<StatefulWidget> createState() {
    return PinCodeWidgetState();
  }
}

class PinCodeWidgetState extends State<PinCodeWidget> {
  String _enteredPinCode;
  String _errorMessage;

  @override
  initState() {
    super.initState();
    _enteredPinCode = "";
    _errorMessage = "";
    if (widget.onFingerprintEntered != null) {
      widget.userProfileBloc.userStream.first.then(
        (user) async {
          if (user.securityModel.enrolledBiometrics != "") {
            await Future.delayed(Duration(milliseconds: 240));
            if (this.mounted) _validateBiometrics();
          }
        },
      );
    }
  }

  Future _validateBiometrics() async {
    var validateBiometricsAction =
        ValidateBiometrics(localizedReason: widget.localizedReason);
    widget.userProfileBloc.userActionsSink.add(validateBiometricsAction);
    validateBiometricsAction.future.then((isValid) async {
      setState(() => _enteredPinCode = (isValid) ? "123456" : "");
      Future.delayed(Duration(milliseconds: 160), () {
        return widget.onFingerprintEntered(isValid);
      });
    }, onError: (error) {
      setState(() => _enteredPinCode = "");
      showFlushbar(context, message: error);
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
              child: Center(
                child: _buildBreezLogo(context),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.label),
                    _buildPinCircles(),
                    _buildErrorMessage()
                  ]),
            ),
          ),
          Flexible(flex: 2, child: Container(child: _numPad(context)))
        ],
      ),
    );
  }

  Image _buildBreezLogo(BuildContext context) {
    return Image.asset(
      "src/images/logo-color.png",
      width: (MediaQuery.of(context).size.width) / 3,
      color: Colors.white,
    );
  }

  Container _buildPinCircles() {
    return Container(
      margin: const EdgeInsets.only(
        left: 64,
        right: 64,
      ),
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _buildCircles(),
      ),
    );
  }

  List<Widget> _buildCircles() {
    var list = <Widget>[];
    for (int i = 0; i < PIN_CODE_LENGTH; i++) {
      list.add(AnimatedContainer(
        duration: Duration(milliseconds: 150),
        padding: EdgeInsets.only(top: 24.0),
        margin: EdgeInsets.only(bottom: 0),
        width: _enteredPinCode.length == PIN_CODE_LENGTH ? 28 : 24,
        height: _enteredPinCode.length == PIN_CODE_LENGTH ? 28 : 24,
        decoration: BoxDecoration(
            color:
                i < _enteredPinCode.length ? Colors.white : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.0)),
      ));
    }
    return list;
  }

  Text _buildErrorMessage() {
    return _errorMessage.isNotEmpty
        ? Text(
            _errorMessage,
            style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
          )
        : Text(
            "",
            style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
          );
  }

  Widget _numPad(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: List<Widget>.generate(
              3, (i) => _numberButton((i + 1).toString())),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: List<Widget>.generate(
              3, (i) => _numberButton((i + 4).toString())),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: List<Widget>.generate(
              3, (i) => _numberButton((i + 7).toString())),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                onPressed: () => _setPinCodeInput(""),
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                ),
              ),
              _numberButton("0"),
              widget.onFingerprintEntered == null ||
                      ((widget.onFingerprintEntered != null) &&
                          _enteredPinCode.length > 0)
                  ? _buildEraseButton()
                  : StreamBuilder<BreezUserModel>(
                      stream: widget.userProfileBloc.userStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data.securityModel.enrolledBiometrics ==
                                "") {
                          return _buildEraseButton();
                        } else {
                          return _buildBiometricsButton(snapshot, context);
                        }
                      },
                    )
            ])
      ],
    );
  }

  Container _buildBiometricsButton(
      AsyncSnapshot<BreezUserModel> snapshot, BuildContext context) {
    return Container(
      child: IconButton(
        onPressed: () => _validateBiometrics(),
        icon: Icon(
          snapshot.data.securityModel.enrolledBiometrics.contains("Face")
              ? Icons.face
              : Icons.fingerprint,
          color: Theme.of(context).errorColor,
        ),
      ),
    );
  }

  Container _buildEraseButton() {
    return Container(
      child: IconButton(
        onPressed: () => _setPinCodeInput(
            _enteredPinCode.substring(0, max(_enteredPinCode.length, 1) - 1)),
        icon: Icon(
          Icons.backspace,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _numberButton(String number) {
    return FlatButton(
      onPressed: () => _onNumButtonPressed(number),
      child: Text(number,
          textAlign: TextAlign.center, style: theme.numPadNumberStyle),
    );
  }

  _onNumButtonPressed(String numberText) {
    _errorMessage = "";
    if (_enteredPinCode.length < PIN_CODE_LENGTH) {
      _setPinCodeInput(_enteredPinCode + numberText);
    }
    if (_enteredPinCode.length == PIN_CODE_LENGTH) {
      Future.delayed(Duration(milliseconds: 200), () {
        widget
            .onPinEntered(_enteredPinCode)
            .catchError((err) => _errorMessage = err.toString().substring(10))
            .whenComplete(() => _setPinCodeInput(""));
      });
    }
  }

  void _setPinCodeInput(String enteredPinCode) {
    setState(() {
      _enteredPinCode = enteredPinCode;
    });
  }
}
