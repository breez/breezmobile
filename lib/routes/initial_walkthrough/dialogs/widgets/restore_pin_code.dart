import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/pin_code_widget.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class RestorePinCode extends StatefulWidget {
  const RestorePinCode({
    Key key,
  }) : super(key: key);

  @override
  State<RestorePinCode> createState() => _RestorePinCodeState();
}

class _RestorePinCodeState extends State<RestorePinCode> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          leading: backBtn.BackButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
          ),
        ),
        body: PinCodeWidget(
          texts.restore_pin_title,
          (enteredPinCode) => _onPinEntered(enteredPinCode),
        ),
      ),
    );
  }

  Future _onPinEntered(String enteredPinCode) {
    Navigator.pop(context, enteredPinCode);
    return Future.value(enteredPinCode);
  }
}
