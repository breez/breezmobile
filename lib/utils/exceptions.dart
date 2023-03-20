import 'package:breez/logger.dart';
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

  var message = exception.toString();
  log.info('extractExceptionMessage: $message');
  message = grouped.stringMatch(message)?.trim() ?? message;
  message = _extractInnerErrorMessage(message);
  if (clearTrailingDot) {
    message = message.replaceAll(RegExp(r'([.!?:])\s*$'), '');
  }
  if (texts != null) {
    message = _localizedExceptionMessage(texts, message);
  }
  return message;
}

String _extractInnerErrorMessage(String originalMessage) {
  log.info('extractInnerErrorMessage: $originalMessage');
  const descRegex = r'((?<=desc = )(.*)(?=.*}))';
  final grouped = RegExp(descRegex);
  return grouped.stringMatch(originalMessage)?.trim() ?? originalMessage;
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
