RegExp _lnurlPrefix = new RegExp(",*?((lnurl)([0-9]{1,}[a-z0-9]+){1})");
String _lightningProtoclPrefix = "lightning:";

bool isLNURL(String url) {
  var lower = url.toLowerCase();
  if (lower.startsWith(_lightningProtoclPrefix)) {
    lower = lower.substring(_lightningProtoclPrefix.length);
  }
  var firstMatch = _lnurlPrefix.firstMatch(lower);
  if (firstMatch != null && firstMatch.start == 0) {
    return true;
  }
  try {
    Uri uri = Uri.parse(lower);
    String lightning = uri.queryParameters["lightning"];
    return lightning != null && _lnurlPrefix.firstMatch(lightning) != null;
  } on FormatException {} // do nothing.
  return false;
}
