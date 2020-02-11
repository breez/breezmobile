import 'dart:io' show Platform;
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/pos_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:breez/logger.dart';
import 'package:breez/bloc/app_blocs.dart';

AppBlocs blocs = AppBlocs();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BreezLogger();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  initializeDateFormatting(Platform.localeName, null);
  AppBlocs blocs = AppBlocs();
  runApp(AppBlocsProvider(child: PosApp(), appBlocs: blocs));
}
