import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/pin_code_widget.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class RestorePinCode extends StatelessWidget {
  final Function(String phrase) onPinCodeSubmitted;

  const RestorePinCode({
    Key key,
    @required this.onPinCodeSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: themeData.appBarTheme.iconTheme,
          textTheme: themeData.appBarTheme.textTheme,
          backgroundColor: themeData.canvasColor,
          leading: backBtn.BackButton(
            onPressed: () {
              Navigator.pop(context, null);
            },
          ),
          elevation: 0.0,
        ),
        body: PinCodeWidget(
          texts.restore_pin_title,
          (enteredPinCode) => _onPinEntered(enteredPinCode),
        ),
      ),
    );
  }

  Future _onPinEntered(String enteredPinCode) {
    onPinCodeSubmitted(enteredPinCode);
    return Future.value(null);
  }
}
