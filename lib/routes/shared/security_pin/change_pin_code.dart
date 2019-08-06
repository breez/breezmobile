import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/pin_code_widget.dart';
import 'package:flutter/material.dart';

const PIN_CODE_LENGTH = 6;

class ChangePinCode extends StatefulWidget {
  ChangePinCode({Key key}) : super(key: key);

  @override
  _ChangePinCodeState createState() => new _ChangePinCodeState();
}

class _ChangePinCodeState extends State<ChangePinCode> {  
  String _label = "Enter your new PIN";

  String _enteredPinCode = "";
  String _errorMessage = "";
  String _tmpPinCode = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: theme.BreezColors.blue[500],
          leading: backBtn.BackButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
          ),
          elevation: 0.0,
        ),
        body: PinCodeWidget(
          _label,
          _enteredPinCode,
          true,
          _errorMessage,
          (numberText) => _onNumButtonPressed(numberText),
          (enteredPinCode) => _setPinCodeInput(enteredPinCode),
        ),
      ),
    );
  }

  _onNumButtonPressed(String numberText) {
    _setErrorMessage("");
    if (_enteredPinCode.length < PIN_CODE_LENGTH) {
      _setPinCodeInput(_enteredPinCode + numberText);
    }
    if (_enteredPinCode.length == PIN_CODE_LENGTH) {
      Future.delayed(Duration(milliseconds: 200), () {
        if (_tmpPinCode.isEmpty) {
          setState(() {
            _tmpPinCode = _enteredPinCode;
            _label = "Re-enter your new PIN";
            _enteredPinCode = "";
          });
        } else {
          if (_enteredPinCode == _tmpPinCode) {
            Navigator.pop(context, _enteredPinCode);
          } else {
            setState(() {
              _tmpPinCode = "";
              _label = "Enter your new PIN";
              _enteredPinCode = "";
              _errorMessage = "PIN does not match";
            });
          }
        }
      });
    }
  }

  void _setPinCodeInput(String enteredPinCode) {
    setState(() {
      _enteredPinCode = enteredPinCode;
    });
  }

  void _setErrorMessage(String errorMessage) {
    setState(() {
      _errorMessage = errorMessage;
    });
  }
}
