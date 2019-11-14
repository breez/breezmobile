import 'dart:async';
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
      throw error.message;
    }
  }

  Future<String> getAvailableBiometrics() async {
    try {
      List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.face)) {
        return (Platform.isIOS) ? "Face ID" : "Face";
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return (Platform.isIOS) ? "Touch ID" : "Fingerprint";
      }
      return "";
    } on PlatformException catch (error) {
      throw error.message;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticateWithBiometrics(
        localizedReason: 'Authenticate to sign in',
        useErrorDialogs: false,
      );
    } on PlatformException catch (error) {
      if (error.code == "LockedOut" || error.code == "PermanentlyLockedOut") {
        showFlushbar(context, message: error.message);
        return false;
      }
      throw error.message;
    }
  }
}
