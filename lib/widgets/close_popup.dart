import 'dart:io';

import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/widgets.dart';

WillPopCallback willPopCallback(
  BuildContext context, {
  String title: 'Exit Breez',
  String message: 'Do you really want to quit Breez?',
  Future<bool> canCancel,
}) {
  return () {
    return (canCancel ?? Future.value(false)).then((canCancel) {
      if (canCancel) return true;
      return promptAreYouSure(context, title, Text(message)).then((shouldExit) {
        if (shouldExit) {
          exit(0);
        }
        return false;
      });
    });
  };
}
