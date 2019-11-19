import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationService {
  LocalAuthenticationService();

  final _auth = LocalAuthentication();

  Future<String> get enrolledBiometrics async => await _getAvailableBiometrics();

  Future<String> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
    String enrolledBiometrics = "";
    if (availableBiometrics.contains(BiometricType.face)) {
      enrolledBiometrics = (Platform.isIOS) ? "Face ID" : "Face";
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      enrolledBiometrics = (Platform.isIOS) ? "Touch ID" : "Fingerprint";
    }
    return enrolledBiometrics;
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticateWithBiometrics(
        localizedReason: 'Authenticate to sign in',
        useErrorDialogs: false,
      );
    } on PlatformException catch (error) {
      if (error.code == "LockedOut" || error.code == "PermanentlyLockedOut") {
        return false;
      }
      throw error.message;
    }
  }
}
