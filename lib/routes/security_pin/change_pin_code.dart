import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/pin_code_widget.dart';
import 'package:flutter/material.dart';

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
    ThemeData theme = context.theme;
    AppBarTheme appBarTheme = theme.appBarTheme;

    return Scaffold(
      appBar: AppBar(
        iconTheme: appBarTheme.iconTheme,
        toolbarTextStyle: appBarTheme.toolbarTextStyle,
        titleTextStyle: appBarTheme.titleTextStyle,
        backgroundColor: context.canvasColor,
        leading: backBtn.BackButton(
          onPressed: () => context.pop(null),
        ),
        elevation: 0.0,
      ),
      body: PinCodeWidget(
        _label,
            (enteredPinCode) => _onPinEntered(enteredPinCode),
      ),
    );
  }

  Future _onPinEntered(String enteredPinCode,) async {
    var l10n = context.l10n;
    if (_tmpPinCode.isEmpty) {
      setState(() {
        _tmpPinCode = enteredPinCode;
        _label = l10n.security_and_backup_new_pin_second_time;
      });
    } else {
      if (enteredPinCode == _tmpPinCode) {
        context.pop(enteredPinCode);
      } else {
        setState(() {
          _tmpPinCode = "";
          _label = l10n.security_and_backup_new_pin;
        });
        throw Exception(l10n.security_and_backup_new_pin_do_not_match);
      }
    }
  }
}
