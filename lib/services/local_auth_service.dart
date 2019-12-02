import 'dart:async';
import 'dart:io';

import 'package:breez/logger.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationService {
  LocalAuthenticationService();

  final _auth = LocalAuthentication();

  Future<String> get enrolledBiometrics async =>
      await _getAvailableBiometrics();

  Future<String> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();
    String enrolledBiometrics = "";
    if (availableBiometrics.contains(BiometricType.face)) {
      enrolledBiometrics = (Platform.isIOS) ? "Face ID" : "Face";
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      enrolledBiometrics = (Platform.isIOS) ? "Touch ID" : "Fingerprint";
    }
    return enrolledBiometrics;
  }

  Future<bool> authenticate({String localizedReason}) async {
    try {
      return await _auth.authenticateWithBiometrics(
          localizedReason: localizedReason ?? 'Authenticate to Sign-In.',
          useErrorDialogs: false,
          androidAuthStrings: AndroidAuthMessages(fingerprintHint: ""));
    } on PlatformException catch (error) {
      if (error.code == "LockedOut" || error.code == "PermanentlyLockedOut") {
        throw error.message;
      }
      log.severe("Error Code: ${error.code} - Message: ${error.message}");
      await _auth.stopAuthentication();
      return false;
    }
  }
}
