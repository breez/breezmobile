import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
//import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() { 
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //initializeDateFormatting(Platform.localeName, null);  
  runApp(Container());
}
