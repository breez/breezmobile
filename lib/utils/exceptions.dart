String extractExceptionMessage(Object exception) {
  final detailRegex = r'((?<=\"detail\":\")(.*)(?=.*\"}))';
  final nsLocalizedRegex = r'((?<={NSLocalizedDescription=)(.*)(?=}))';
  final lnUrlRegex = r'((?<=LNURL:.)(.*)(?=.method:))';
  final grouped = RegExp('$nsLocalizedRegex|$lnUrlRegex|$detailRegex');
  return grouped.stringMatch(exception.toString()) ?? exception.toString();
}
