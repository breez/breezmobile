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

  String _tmpPinCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
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
        ));
  }

  _onPinEntered(String enteredPinCode) async {
    if (_tmpPinCode.isEmpty) {
      setState(() {
        _tmpPinCode = enteredPinCode;
        _label = "Re-enter your new PIN";
      });
    } else {
      if (enteredPinCode == _tmpPinCode) {
        Navigator.pop(context, enteredPinCode);
      } else {
        setState(() {
          _tmpPinCode = "";
          _label = "Enter your new PIN";
        });
        throw Exception("PIN does not match");
      }
    }
  }
}
