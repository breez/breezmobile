import 'dart:io';

import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/widgets.dart';
import 'package:breez_translations/breez_translations_locales.dart';

WillPopCallback willPopCallback(
  BuildContext context, {
  bool immediateExit = false,
  String title,
  String message,
  Function canCancel,
}) {
  final texts = context.texts();
  return () async {
    if (canCancel != null && canCancel()) return true;
    return promptAreYouSure(
      context,
      title ?? texts.close_popup_title,
      Text(message ?? texts.close_popup_message),
    ).then((ok) {
      if (ok && immediateExit) {
        exit(0);
      }
      return ok;
    });
  };
}
