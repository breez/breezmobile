import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

Future<String> scan() async {
  try {
    String result = "";
    await BarcodeScanner.scan().then((scanResult) async {
      await Future.delayed(Duration(milliseconds: 250));
        result = scanResult;
    });
    return result;
  } on PlatformException catch (error) {
    throw error;
  }
}