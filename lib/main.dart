import 'dart:io' show Platform;
import 'package:breez/user_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/logger.dart';
import 'package:breez/widgets/static_loader.dart';

AppBlocs blocs = AppBlocs();
void main() {
  BreezLogger();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  initializeDateFormatting(Platform.localeName, null);
  runApp(BlocProvider<AppBlocs>(blocs, AppLoader(blocs)));
}

class AppLoader extends StatelessWidget {
  final AppBlocs _blocs;
  AppLoader(this._blocs);

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<BreezUserModel>(
        stream: _blocs.userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return StaticLoader();
          }

          return UserApp(_blocs, snapshot.data);
        });
  }
}
