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
  final GlobalKey<PinCodeWidgetState> _key = GlobalKey();
  String _label = "Enter your new PIN";

  String _tmpPinCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          true,
          (enteredPinCode) => _onPinEntered(enteredPinCode),
          key: _key,
        ));
  }

  _onPinEntered(String enteredPinCode) {
    if (_tmpPinCode.isEmpty) {
      setState(() {
        _tmpPinCode = enteredPinCode;
        _key.currentState.setLabel("Re-enter your new PIN");
        _key.currentState.setPinCodeInput("");
      });
    } else {
      if (enteredPinCode == _tmpPinCode) {
        Navigator.pop(context, enteredPinCode);
      } else {
        setState(() {
          _tmpPinCode = "";
          _key.currentState.setLabel("Enter your new PIN");
          _key.currentState.setPinCodeInput("");
          _key.currentState.setErrorMessage("PIN does not match");
        });
      }
    }
  }
}
