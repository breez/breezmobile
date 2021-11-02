import 'package:email_validator/email_validator.dart';

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

bool isLightningAddress(String uri) {
  // Ref. https://github.com/andrerfneves/lightning-address/blob/master/DIY.md

    if(uri == null || uri.isEmpty) { return false; }

    var email = uri.toLowerCase();
    if (email.startsWith("lightning:")) {
      email = email.substring("lightning:".length);
    }

  var result = EmailValidator.validate(email);
  print('isLightningAddress: $email: $result');
  return result;

}
