import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/pin_code_widget.dart';
import 'package:flutter/material.dart';

const PIN_CODE_LENGTH = 6;

class AppLockScreen extends StatefulWidget {

  final SecurityModel securityModel;
  final bool canCancel;
  final Function onUnlock;

  AppLockScreen(this.securityModel, {Key key, this.canCancel = false, this.onUnlock}) : super(key: key);

  @override
  _AppLockScreenState createState() => new _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {  
  String _label = "Enter your PIN";

  String _enteredPinCode = "";
  String _errorMessage = "";  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { 
        return Future.value(widget.canCancel);
      },      
      child: Scaffold(
        appBar: widget.canCancel == true
            ? new AppBar(
                iconTheme: theme.appBarIconTheme,
                textTheme: theme.appBarTextTheme,
                backgroundColor: theme.BreezColors.blue[500],
                leading: backBtn.BackButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                elevation: 0.0,
              )
            : null, 
        body: PinCodeWidget(
          _label,
          _enteredPinCode,
          widget.canCancel,
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
        if (_enteredPinCode == widget.securityModel.pinCode) {
          if (widget.onUnlock != null) {
            widget.onUnlock();
            return;
          }
          Navigator.pop(context, true);
        } else {
          _setPinCodeInput("");
          _setErrorMessage("Incorrect PIN");
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
