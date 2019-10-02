import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez/routes/shared/network/network.dart';
import 'package:breez/routes/shared/dev/dev.dart';
import 'package:breez/routes/shared/initial_walkthrough.dart';
import 'package:breez/routes/pos/home/pos_home_page.dart';
import 'package:breez/routes/pos/settings/pos_settings_page.dart';
import 'package:breez/routes/user/withdraw_funds/withdraw_funds_page.dart';
import 'package:breez/routes/pos/transactions/pos_transactions_page.dart';
import 'package:breez/theme_data.dart' as theme;

class PosApp extends StatelessWidget {
  const PosApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BackupBloc backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    UserProfileBloc userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    return StreamBuilder(
        stream: userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Loader());
          }

          BreezUserModel user = snapshot.data;
          return MaterialApp(
            title: 'Breez POS',
            initialRoute: user.registered ? null : '/intro',
            home: PosHome(accountBloc, backupBloc, userProfileBloc),
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case '/home':
                  return new FadeInRoute(
                    builder: (_) =>
                        new PosHome(accountBloc, backupBloc, userProfileBloc),
                    settings: settings,
                  );
                case '/intro':
                  return new FadeInRoute(
                    builder: (_) => new InitialWalkthroughPage(user,
                        userProfileBloc, backupBloc, true),
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
                case '/network':
                  return new FadeInRoute(
                    builder: (_) => new NetworkPage(),
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
              canvasColor: theme.BreezColors.blue[500],
              fontFamily: 'IBMPlexSansRegular',
              cardColor: theme.BreezColors.blue[500],
            ),
          );
        });
  }
}
