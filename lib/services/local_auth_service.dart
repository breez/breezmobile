import 'dart:io';

import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationService {
  BuildContext context;

  LocalAuthenticationService(this.context);

  final _auth = LocalAuthentication();

  Future<bool> checkBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (error) {
      showFlushbar(context, message: error.message);
      return false;
    }
  }

  Future<String> getAvailableBiometrics() async {
    try {
      List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.face)) {
        return "face";
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return "fingerprint";
      }
    } on PlatformException catch (error) {
      if (error.code == "PasscodeNotSet") {
        showFlushbar(context, message: error.message);
      }
    }
    return "";
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticateWithBiometrics(
        localizedReason: 'Authenticate to sign in',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (error) {
      showFlushbar(context, message: error.message);
      return false;
    }
  }
}
