import 'package:breez_translations/generated/breez_translations.dart';

String extractExceptionMessage(
  Object exception, {
  bool clearTrailingDot = false,
  // pass BreezTranslations if you want to replace the error message with a localized one
  BreezTranslations texts,
}) {
  const detailRegex = r'((?<=\"detail\":\")(.*)(?=.*\"}))';
  const nsLocalizedRegex = r'((?<={NSLocalizedDescription=)(.*)(?=}))';
  const lnUrlRegex = r'((?<=LNURL:.)(.*)(?=.method:))';
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
  BreezTranslations texts,
  String originalMessage,
) {
  switch (originalMessage.toLowerCase()) {
    case "invalid pair hash":
      return texts.localized_error_message_invalid_pair_hash;
    default:
      return originalMessage;
  }
}
