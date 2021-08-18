import 'dart:io';

import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/widgets.dart';

WillPopCallback willPopCallback(
  BuildContext context, {
  bool immediateExit = false,
  String title: 'Exit Breez',
  String message: 'Do you really want to quit Breez?',
  Function canCancel,
}) {
  return () async {
    if (canCancel != null && canCancel()) return true;
    return promptAreYouSure(context, title, Text(message)).then((ok) {
      if (ok && immediateExit) {
        exit(0);
      }
      return ok;
    });
  };
}
