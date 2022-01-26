import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/pin_code_widget.dart';
import 'package:flutter/material.dart';
import 'package:breez/l10n/locales.dart';

const PIN_CODE_LENGTH = 6;

class ChangePinCode extends StatefulWidget {
  const ChangePinCode({
    Key key,
  }) : super(key: key);

  @override
  _ChangePinCodeState createState() => _ChangePinCodeState();
}

class _ChangePinCodeState extends State<ChangePinCode> {
  String _label;
  String _tmpPinCode = "";

  @override
  Widget build(BuildContext context) {
    if (_label == null) {
      _label = context.l10n.security_and_backup_new_pin;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(
          onPressed: () => Navigator.pop(context, null),
        ),
        elevation: 0.0,
      ),
      body: PinCodeWidget(
        _label,
        (enteredPinCode) => _onPinEntered(enteredPinCode),
      ),
    );
  }

  Future _onPinEntered(
    String enteredPinCode,
  ) async {
    if (_tmpPinCode.isEmpty) {
      setState(() {
        _tmpPinCode = enteredPinCode;
        _label = context.l10n.security_and_backup_new_pin_second_time;
      });
    } else {
      if (enteredPinCode == _tmpPinCode) {
        Navigator.pop(context, enteredPinCode);
      } else {
        setState(() {
          _tmpPinCode = "";
          _label = context.l10n.security_and_backup_new_pin;
        });
        throw Exception(context.l10n.security_and_backup_new_pin_do_not_match);
      }
    }
  }
}
