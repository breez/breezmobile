import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/pin_code_widget.dart';
import 'package:flutter/material.dart';

class RestorePinCode extends StatelessWidget {
  final Function(String phrase) onPinCodeSubmitted;

  const RestorePinCode({
    Key key,
    @required this.onPinCodeSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = context.theme;
    AppBarTheme appBarTheme = theme.appBarTheme;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: appBarTheme.iconTheme,
          toolbarTextStyle: appBarTheme.toolbarTextStyle,
          titleTextStyle: appBarTheme.titleTextStyle,
          backgroundColor: theme.canvasColor,
          leading: backBtn.BackButton(
            onPressed: () {
              context.pop(null);
            },
          ),
          elevation: 0.0,
        ),
        body: PinCodeWidget(
          context.l10n.restore_pin_title,
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
