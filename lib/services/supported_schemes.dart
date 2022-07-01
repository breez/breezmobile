bool canHandleScheme(String link) {
  if (link == null) return false;
  final sanitized = link.toLowerCase().trim();
  return sanitized.startsWith("breez:") ||
      sanitized.startsWith("lightning:") ||
      sanitized.startsWith("lnurlc:") ||
      sanitized.startsWith("lnurlp:") ||
      sanitized.startsWith("lnurlw:") ||
      sanitized.startsWith("keyauth:");
}
