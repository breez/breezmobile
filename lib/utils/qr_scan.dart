import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

Future<String> scan() async {
  try {
    String result = "";
    await BarcodeScanner.scan().then((scanResult) async {
      await Future.delayed(Duration(milliseconds: 250));
      if (scanResult == "GET_CLIPBOARD_DATA") {
        result = await _getClipboardData();
      } else {
        result = scanResult;
      }
    });
    return result;
  } on PlatformException catch (error) {
    throw error;
  }
}

Future<String> _getClipboardData() async {
  ClipboardData clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
  return clipboardData?.text;
}

Map parse(String query) {
  var search = new RegExp('([^&=]+)=?([^&]*)');
  var result = new Map();
  if (query.startsWith('?')) query = query.substring(1);
  decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

  for (Match match in search.allMatches(query)) {
    result[decode(match.group(1))] = decode(match.group(2));
  }

  return result;
}
