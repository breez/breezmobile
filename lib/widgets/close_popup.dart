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
  return () async {
    if (canCancel != null && canCancel()) return true;
    return promptAreYouSure(
      context,
      title ?? context.l10n.close_popup_title,
      Text(message ?? context.l10n.close_popup_message),
    ).then((ok) {
      if (ok && immediateExit) {
        exit(0);
      }
      return ok;
    });
  };
}
