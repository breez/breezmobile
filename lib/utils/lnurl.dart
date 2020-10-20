RegExp _exp = new RegExp(",*?((lnurl)([0-9]{1,}[a-z0-9]+){1})");

bool isLNURL(String url) {
  var lower = url.toLowerCase();
  return _exp.firstMatch(lower) != null;
}
