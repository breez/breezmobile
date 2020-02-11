bool isFastBitcoinURL(String url) {
  try {
    Uri uri = Uri.parse(url);
    return uri.host == "fastbitcoins.com";
  } on Exception {}
  return false;
}
