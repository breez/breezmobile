import 'dart:io' show Platform;
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:breez/logger.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/routes/shared/dev/dev.dart';
import 'package:breez/routes/shared/initial_walkthrough.dart';
import 'package:breez/routes/pos/home/pos_home_page.dart';
import 'package:breez/routes/pos/settings/pos_settings_page.dart';
import 'package:breez/routes/user/withdraw_funds/withdraw_funds_page.dart';
import 'package:breez/routes/pos/transactions/pos_transactions_page.dart';
import 'package:breez/theme_data.dart' as theme;

AppBlocs blocs = AppBlocs();
void main() {
  BreezLogger();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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

          return new MaterialApp(
            title: 'Breez POS',
            initialRoute: snapshot.data.registered ? null : '/intro',
            home: PosHome(_blocs.accountBloc),
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case '/home':
                  return new FadeInRoute(
                    builder: (_) => new PosHome(_blocs.accountBloc),
                    settings: settings,
                  );
                case '/intro':
                  return new FadeInRoute(
                    builder: (_) => new InitialWalkthroughPage(_blocs.userProfileBloc, true),
                    settings: settings,
                  );
                case '/transactions':
                  return new FadeInRoute(
                    builder: (_) => new PosTransactionsPage(),
                    settings: settings,
                  );
                case '/withdraw_funds':
                  return new FadeInRoute(
                    builder: (_) => new WithdrawFundsPage(),
                    settings: settings,
                  );
                case '/settings':
                  return new FadeInRoute(
                    builder: (_) => PosSettingsPage(),
                    settings: settings,
                  );
                case '/developers':
                  return new FadeInRoute(
                    builder: (_) => new DevView(),
                    settings: settings,
                  );
              }
              assert(false);
            },
            theme: ThemeData(
              brightness: Brightness.dark,
              accentColor: Color(0xFFffffff),
              dialogBackgroundColor: Colors.white,
              primaryColor: Color.fromRGBO(255, 255, 255, 1.0),
              textSelectionColor: Color.fromRGBO(255, 255, 255, 0.5),
              textSelectionHandleColor: Color(0xFF0085fb),
              dividerColor: Color(0x33ffffff),
              errorColor: theme.errorColor,
              canvasColor: Color.fromRGBO(5, 93, 235, 1.0),
              fontFamily: 'IBMPlexSansRegular',
              cardColor: Color.fromRGBO(5, 93, 235, 1.0),
            ),
          );
        });
  }
}
