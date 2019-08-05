import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/pin_code_widget.dart';
import 'package:flutter/material.dart';

const PIN_CODE_LENGTH = 6;

class RestorePinCode extends StatefulWidget {

  RestorePinCode({Key key}) : super(key: key);

  @override
  _RestorePinCodeState createState() => new _RestorePinCodeState();
}

class _RestorePinCodeState extends State<RestorePinCode> {  
  String _label = "Enter backup PIN";

  String _enteredPinCode = "";
  String _errorMessage = "";  

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

    if (_enteredPinCode.length < PIN_CODE_LENGTH) {
      _setPinCodeInput(_enteredPinCode + numberText);
    }
    if (_enteredPinCode.length == PIN_CODE_LENGTH) {        
        Navigator.pop(context, _enteredPinCode);
      }
  }

  void _setPinCodeInput(String enteredPinCode) {
    setState(() {
      _enteredPinCode = enteredPinCode;
    });
  }
}
