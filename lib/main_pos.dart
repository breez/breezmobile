import 'dart:io' show Platform;
import 'package:breez/pos_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:breez/logger.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/widgets/loader.dart';

AppBlocs blocs = AppBlocs();
void main() {
  BreezLogger();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  initializeDateFormatting(Platform.localeName, null);
  runApp(BlocProvider<AppBlocs>(blocs, UserLoaderWidget(blocs)));
}

class UserLoaderWidget extends StatelessWidget {
  // Platform channel to tell the native code whether we are a POS client
  static const _platform = const MethodChannel('com.breez.client/main');

  final AppBlocs _blocs;
  UserLoaderWidget(this._blocs);

  @override
  Widget build(BuildContext context) {
    _platform.invokeMethod("setPos", {'isPos': true});
    return new StreamBuilder<BreezUserModel>(
        stream: _blocs.userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Loader());
          }

          return new PosApp(user: snapshot.data, appBlocs: _blocs);
        });
  }
}
