import 'package:email_validator/email_validator.dart';

RegExp _lnurlPrefix = new RegExp(",*?((lnurl)([0-9]{1,}[a-z0-9]+){1})");
String _lightningProtocolPrefix = "lightning:";

bool isLNURL(String url) {
  var lower = url.toLowerCase();
  if (lower.startsWith(_lightningProtocolPrefix)) {
    lower = lower.substring(_lightningProtocolPrefix.length);
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

bool isLightningAddress(String uri) {
  var result = false;
  var v = parseLightningAddress(uri);
  result = v != null && v.isNotEmpty;
  return result;
}

bool isLightningAddressURI(String uri) {
  var result = false;

  if (uri != null) {
    result = uri.toLowerCase().startsWith(_lightningProtocolPrefix) &&
        isLightningAddress(uri);
  }
  return result;
}

parseLightningAddress(String uri) {
  // Ref. https://github.com/andrerfneves/lightning-address/blob/master/DIY.md

  String result;
  if (uri != null && uri.isNotEmpty) {
    var l = uri.toLowerCase();
    if (l.startsWith(_lightningProtocolPrefix)) {
      result = uri.substring(_lightningProtocolPrefix.length);
    }

    result ??= uri;
    if (!EmailValidator.validate(result)) {
      result = null;
    }
    print('parseLightningAddress: $uri: $result');
  }
  return result;
}
