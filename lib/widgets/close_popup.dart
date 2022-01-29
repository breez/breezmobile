import 'dart:io';

import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/widgets.dart';

WillPopCallback willPopCallback(
  BuildContext context, {
  bool immediateExit = false,
  String title,
  String message,
  Function canCancel,
}) {
  var l10n = context.l10n;

  return () async {
    if (canCancel != null && canCancel()) return true;
    return promptAreYouSure(
      context,
      title ?? l10n.close_popup_title,
      Text(message ?? l10n.close_popup_message),
    ).then((ok) {
      if (ok && immediateExit) {
        exit(0);
      }
      return ok;
    });
  };
}
