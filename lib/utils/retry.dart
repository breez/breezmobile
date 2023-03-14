import "dart:async";

import 'package:breez_translations/breez_translations_locales.dart';

Future<dynamic> retry(
  Future<dynamic> Function() f, {
  int tryLimit = 6,
  Duration interval,
}) async {
  interval ??= const Duration(seconds: 10);

  for (int t = 0; t < tryLimit; t++) {
    try {
      final result = await f();

      return result;
    } catch (e) {
      if (t == tryLimit - 1) rethrow;

      await Future.delayed(interval);
    }
  }

  // To prevent static warning
  throw Exception(getSystemAppLocalizations().utils_retry_failed);
}
