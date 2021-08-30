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

bool isLightningAddress(String email) {
    // This is just a normal e-mail address.
    // Ref. https://github.com/andrerfneves/lightning-address/blob/master/DIY.md

    var result = false;
    if (email.isNotEmpty) {
        print('isLightningAddress: testing $email');

        // source: https://www.w3resource.com/javascript/form/email-validation.php
        final emailRegExp = new RegExp(
                r'^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$', caseSensitive : false);
        final match = emailRegExp.matchAsPrefix(email);
        result = (match != null) && ((match.end - match.start) == email.length);

    }

    print('isLightningAddress: $result');
    return result;
}
