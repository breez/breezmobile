import 'dart:async';
import 'package:flutter/services.dart';

class Share {
  static const MethodChannel channel =
  const MethodChannel('com.breez.client/share_breez');

  static Future<dynamic> share(String text, {String title}) {
    final Map<String, dynamic> args = <String, dynamic>{
      'text': text,
    };

    if (title != null) {
      args['title'] = title;
    }

    return channel.invokeMethod('share', args);
  }
}
