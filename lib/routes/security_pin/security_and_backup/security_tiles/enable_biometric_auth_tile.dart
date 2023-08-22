import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/services/local_auth_service.dart';
import 'package:breez/widgets/designsystem/switch/simple_switch.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class EnableBiometricAuthTile extends StatefulWidget {
  final UserProfileBloc userProfileBloc;
  final AutoSizeGroup autoSizeGroup;
  final Future Function(SecurityModel securityModel) changeBiometricAuth;

  const EnableBiometricAuthTile({
    @required this.userProfileBloc,
    @required this.autoSizeGroup,
    @required this.changeBiometricAuth,
  });

  @override
  State<EnableBiometricAuthTile> createState() =>
      _EnableBiometricAuthTileState();
}

class _EnableBiometricAuthTileState extends State<EnableBiometricAuthTile>
    with WidgetsBindingObserver {
  LocalAuthenticationOption _localAuthenticationOption;

  @override
  void initState() {
    super.initState();
    _localAuthenticationOption = LocalAuthenticationOption.NONE;
    _getEnrolledBiometrics();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getEnrolledBiometrics();
    }
  }

  Future _getEnrolledBiometrics() async {
    var getEnrolledBiometricsAction = GetEnrolledBiometrics();
    widget.userProfileBloc.userActionsSink.add(getEnrolledBiometricsAction);
    return getEnrolledBiometricsAction.future.then((enrolledBiometrics) {
      setState(() {
        _localAuthenticationOption = enrolledBiometrics;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_localAuthenticationOption == LocalAuthenticationOption.NONE) {
      return null;
    } else {
      return StreamBuilder<BreezUserModel>(
        stream: widget.userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          final securityModel = snapshot.data.securityModel;

          return SimpleSwitch(
            text: _localAuthenticationOptionLabel(),
            switchValue: securityModel.isFingerprintEnabled,
            group: securityModel.requiresPin ? widget.autoSizeGroup : null,
            onChanged: (value) async {
              if (mounted) {
                if (value) {
                  await _validateBiometrics(securityModel);
                } else {
                  await widget.changeBiometricAuth(
                    securityModel.copyWith(isFingerprintEnabled: false),
                  );
                }
              }
            },
          );
        },
      );
    }
  }

  String _localAuthenticationOptionLabel() {
    final texts = context.texts();
    switch (_localAuthenticationOption) {
      case LocalAuthenticationOption.FACE:
        return texts.security_and_backup_enable_biometric_option_face;
      case LocalAuthenticationOption.FACE_ID:
        return texts.security_and_backup_enable_biometric_option_face_id;
      case LocalAuthenticationOption.FINGERPRINT:
        return texts.security_and_backup_enable_biometric_option_fingerprint;
      case LocalAuthenticationOption.TOUCH_ID:
        return texts.security_and_backup_enable_biometric_option_touch_id;
      case LocalAuthenticationOption.NONE:
      default:
        return texts.security_and_backup_enable_biometric_option_none;
    }
  }

  Future _validateBiometrics(SecurityModel securityModel) async {
    final texts = context.texts();

    final validateBiometricsAction = ValidateBiometrics(
      localizedReason: texts.security_and_backup_validate_biometrics_reason,
    );
    widget.userProfileBloc.userActionsSink.add(validateBiometricsAction);
    validateBiometricsAction.future.then(
      (isValid) async {
        widget.changeBiometricAuth(
          securityModel.copyWith(isFingerprintEnabled: isValid),
        );
      },
      onError: (error) => showFlushbar(context, message: error),
    );
  }
}
