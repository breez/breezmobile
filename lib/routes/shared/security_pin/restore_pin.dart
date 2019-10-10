import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/pin_code_widget.dart';
import 'package:flutter/material.dart';

const PIN_CODE_LENGTH = 6;

class RestorePinCode extends StatefulWidget {
  final Function(String phrase) onPinCodeSubmitted;

  RestorePinCode({Key key, @required this.onPinCodeSubmitted}) : super(key: key);

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
        ),
      ),
    );
  }

  Future _onPinEntered(String enteredPinCode) {
    widget.onPinCodeSubmitted(enteredPinCode);    
    return Future.value(null);
  }
}
