import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/pin_code_widget.dart';
import 'package:flutter/material.dart';

const PIN_CODE_LENGTH = 6;

class AppLockScreen extends StatefulWidget {  
  final bool canCancel;
  final Future Function(String pinCode) onPinEntered;

  AppLockScreen(this.onPinEntered, {Key key, this.canCancel = false}) : super(key: key);

  @override
  _AppLockScreenState createState() => new _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  String _label = "Enter your PIN";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(widget.canCancel);
      },
      child: Scaffold(
        appBar: widget.canCancel == true
            ? new AppBar(
                iconTheme: Theme.of(context).appBarTheme.iconTheme,
                textTheme: Theme.of(context).appBarTheme.textTheme,
                backgroundColor: Theme.of(context).canvasColor,
                leading: backBtn.BackButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                elevation: 0.0,
              )
            : null,
        body: PinCodeWidget(
          _label,
          widget.canCancel,
          widget.onPinEntered,
        ),
      ),
    );
  }
}
