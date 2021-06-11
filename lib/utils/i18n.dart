import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

String t(final BuildContext context, final String key,
    {final Map<String, String> params}) {
  return FlutterI18n.translate(context, key, translationParams: params);
}
