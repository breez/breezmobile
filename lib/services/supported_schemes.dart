const _validSchemes = [
  "breez:",
  "lightning:",
  "lnurlc:",
  "lnurlp:",
  "lnurlw:",
  "keyauth:",
];

bool canHandleScheme(String link) {
  if (link == null) return false;
  final sanitized = link.toLowerCase().trim();
  return _validSchemes.any((scheme) => sanitized.startsWith(scheme));
}

/// Extracts the link from an arbitrary payload removing some special characters
/// from the beginning of the payload such as 0x00
String extractPayloadLink(String payload) {
  try {
    final scheme = _validSchemes.firstWhere((e) => payload.contains(e));
    return payload.substring(payload.indexOf(scheme));
  } catch (e) {
    return null;
  }
}
