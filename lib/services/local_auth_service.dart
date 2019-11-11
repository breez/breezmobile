import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthenticationService {
  BuildContext context;

  LocalAuthenticationService(this.context);

  final _auth = LocalAuthentication();

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
