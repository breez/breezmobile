String extractBolt11FromBip21(String bip21) {
  String lowerBit21 = bip21.toLowerCase();
  if (lowerBit21.startsWith("bitcoin:")) {
    try {
      Uri uri = Uri.parse(lowerBit21);
      String bolt11 = uri.queryParameters["lightning"];
      if (bolt11 != null && bolt11.isNotEmpty) {
        return bolt11;
      }
    } on FormatException {} // do nothing.
  }
  return null;
}
