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

const String URN_SCHEME = "bitcoin:";

String extractBitcoinAddress(String address) {
  if (address.toLowerCase().startsWith(URN_SCHEME)) {
    try {
      int split = address.indexOf("?");
      String addr = address.substring(URN_SCHEME.length, split == -1 ? null : split);
      if (addr.isNotEmpty) {
        isLegacyOrNestedSegwit(addr) ? addr : addr = addr.toLowerCase();
        return addr;
      }
    } on FormatException {
      // do nothing.
    }
  }
  return address;
}

bool isLegacyOrNestedSegwit(String address) {
  if (address.startsWith(RegExp("^[1 | 3]"))) {
    return true;
  }
  return false;
}
