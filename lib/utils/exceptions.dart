String extractExceptionMessage(
  Object exception, {
  bool clearTrailingDot = false,
}) {
  final detailRegex = r'((?<=\"detail\":\")(.*)(?=.*\"}))';
  final nsLocalizedRegex = r'((?<={NSLocalizedDescription=)(.*)(?=}))';
  final lnUrlRegex = r'((?<=LNURL:.)(.*)(?=.method:))';
  final grouped = RegExp('$nsLocalizedRegex|$lnUrlRegex|$detailRegex');
  var message = grouped.stringMatch(exception.toString()) ?? exception.toString();
  if (clearTrailingDot) {
    message = message.replaceAll(RegExp(r'([.!?:])\s*$'), '');
  }
  return message;
}
