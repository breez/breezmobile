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
          true,
          (enteredPinCode) => _onPinEntered(enteredPinCode),
        ),
      ),
    );
  }

  _onPinEntered(String enteredPinCode) {
    return Navigator.pop(context, enteredPinCode);
  }
}
