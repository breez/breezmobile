import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/pin_code_widget.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

const PIN_CODE_LENGTH = 6;

class ChangePinCode extends StatefulWidget {
  const ChangePinCode({
    Key key,
  }) : super(key: key);

  @override
  ChangePinCodeState createState() => ChangePinCodeState();
}

class ChangePinCodeState extends State<ChangePinCode> {
  String _label;
  String _tmpPinCode = "";

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    _label ??= texts.security_and_backup_new_pin;

    return Scaffold(
      appBar: AppBar(
        leading: backBtn.BackButton(
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
      body: PinCodeWidget(
        _label,
        (enteredPinCode) => _onPinEntered(texts, enteredPinCode),
      ),
    );
  }

  Future _onPinEntered(
    BreezTranslations texts,
    String enteredPinCode,
  ) async {
    if (_tmpPinCode.isEmpty) {
      setState(() {
        _tmpPinCode = enteredPinCode;
        _label = texts.security_and_backup_new_pin_second_time;
      });
    } else {
      if (enteredPinCode == _tmpPinCode) {
        Navigator.pop(context, enteredPinCode);
      } else {
        setState(() {
          _tmpPinCode = "";
          _label = texts.security_and_backup_new_pin;
        });
        throw Exception(texts.security_and_backup_new_pin_do_not_match);
      }
    }
  }
}
