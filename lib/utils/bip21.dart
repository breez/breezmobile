String extractBolt11FromBip21(String bip21) {
  String lowerBip21 = bip21.toLowerCase();
  if (lowerBip21.startsWith("bitcoin:")) {
    try {
      Uri uri = Uri.parse(lowerBip21);
      String bolt11 = uri.queryParameters["lightning"];
      if (bolt11 != null && bolt11.isNotEmpty) {
        return bolt11;
      }
    } on FormatException {
      // do nothing.
    }
  }
  return null;
}

String extractBitcoinAddressFromBip21(String bip21) {
  String urnScheme = "bitcoin";
  if (bip21.startsWith("bitcoin:") || bip21.startsWith("BITCOIN:")) {
    try {
      int split = bip21.indexOf("?");
      String address =
          bip21.substring(urnScheme.length + 1, split == -1 ? null : split);
      if (address.isNotEmpty) {
        isLegacyOrNestedSegwit(address)
            ? address
            : address = address.toLowerCase();
        return address;
      }
    } on FormatException {
      // do nothing.
    }
  }
  return null;
}

bool isLegacyOrNestedSegwit(String address) {
  if (address.startsWith(RegExp("^[1 | 3]"))) {
    return true;
  }
  return false;
}
