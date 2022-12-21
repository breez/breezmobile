import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String extractExceptionMessage(
  Object exception, {
  bool clearTrailingDot = false,
  // pass AppLocalizations if you want to replace the error message with a localized one
  AppLocalizations texts,
}) {
  final detailRegex = r'((?<=\"detail\":\")(.*)(?=.*\"}))';
  final nsLocalizedRegex = r'((?<={NSLocalizedDescription=)(.*)(?=}))';
  final lnUrlRegex = r'((?<=LNURL:.)(.*)(?=.method:))';
  final grouped = RegExp('$nsLocalizedRegex|$lnUrlRegex|$detailRegex');
  var message = grouped.stringMatch(exception.toString()) ?? exception.toString();
  message = message.trim();
  if (clearTrailingDot) {
    message = message.replaceAll(RegExp(r'([.!?:])\s*$'), '');
  }
  if (texts != null) {
    message = _localizedExceptionMessage(texts, message);
  }
  return message;
}

String _localizedExceptionMessage(
  AppLocalizations texts,
  String originalMessage,
) {
  switch (originalMessage.toLowerCase()) {
    case "invalid pair hash":
      return texts.localized_error_message_invalid_pair_hash;
    default:
      return originalMessage;
  }
}
