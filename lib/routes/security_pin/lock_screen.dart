import 'package:clovrlabs_wallet/bloc/user_profile/user_profile_bloc.dart';
import 'package:clovrlabs_wallet/widgets/back_button.dart' as backBtn;
import 'package:clovrlabs_wallet/widgets/close_popup.dart';
import 'package:clovrlabs_wallet/widgets/pin_code_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    return WillPopScope(
      onWillPop: willPopCallback(
        context,
        immediateExit: !canCancel,
        canCancel: () => canCancel,
      ),
      child: Scaffold(
        appBar: canCancel == true
            ? AppBar(
                iconTheme: themeData.appBarTheme.iconTheme,
                textTheme: themeData.appBarTheme.textTheme,
                backgroundColor: themeData.canvasColor,
                leading: backBtn.BackButton(
                  onPressed: () => Navigator.pop(context, false),
                ),
                elevation: 0.0,
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
