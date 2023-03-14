import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/close_popup.dart';
import 'package:breez/widgets/pin_code_widget.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

const PIN_CODE_LENGTH = 6;

class AppLockScreen extends StatelessWidget {
  final bool canCancel;
  final Future Function(String pinCode) onPinEntered;
  final Function(bool isValid) onFingerprintEntered;
  final UserProfileBloc userProfileBloc;
  final String localizedReason;

  const AppLockScreen(
    this.onPinEntered, {
    Key key,
    this.canCancel = false,
    this.onFingerprintEntered,
    this.userProfileBloc,
    this.localizedReason,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return WillPopScope(
      onWillPop: willPopCallback(
        context,
        immediateExit: !canCancel,
        canCancel: () => canCancel,
      ),
      child: Scaffold(
        appBar: canCancel == true
            ? AppBar(
                leading: backBtn.BackButton(
                  onPressed: () => Navigator.pop(context, false),
                ),
              )
            : null,
        body: PinCodeWidget(
          texts.lock_screen_enter_pin,
          onPinEntered,
          onFingerprintEntered: onFingerprintEntered,
          userProfileBloc: userProfileBloc,
          localizedReason: localizedReason,
        ),
      ),
    );
  }
}
