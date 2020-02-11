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
import 'package:breez/bloc/account/add_funds_bloc.dart';

import 'bloc/lsp/lsp_bloc.dart';

class PosApp extends StatelessWidget {
  const PosApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BackupBloc backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    UserProfileBloc userProfileBloc =
        AppBlocsProvider.of<UserProfileBloc>(context);
    LSPBloc lspBloc = AppBlocsProvider.of<LSPBloc>(context);

    return StreamBuilder(
        stream: userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Loader());
          }

          BreezUserModel user = snapshot.data;
          theme.themeId = user.themeId;
          SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(statusBarColor: Colors.transparent));
          return BlocProvider(
            creator: () => AddFundsBloc(
                userProfileBloc.userStream, accountBloc.accountStream),
            builder: (ctx) => MaterialApp(
              title: 'Breez POS',
              initialRoute: user.registered ? null : '/intro',
              home: PosHome(accountBloc, backupBloc, userProfileBloc, lspBloc),
              theme: theme.themeMap[user.themeId],
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case '/home':
                    return FadeInRoute(
                      builder: (_) => PosHome(
                          accountBloc, backupBloc, userProfileBloc, lspBloc),
                      settings: settings,
                    );
                  case '/intro':
                    return FadeInRoute(
                      builder: (_) => InitialWalkthroughPage(
                          user, userProfileBloc, backupBloc, true),
                      settings: settings,
                    );
                  case '/transactions':
                    return FadeInRoute(
                      builder: (_) => PosTransactionsPage(),
                      settings: settings,
                    );
                  case '/withdraw_funds':
                    return FadeInRoute(
                      builder: (_) => WithdrawFundsPage(),
                      settings: settings,
                    );
                  case '/settings':
                    return FadeInRoute(
                      builder: (_) => PosSettingsPage(),
                      settings: settings,
                    );
                  case '/network':
                    return FadeInRoute(
                      builder: (_) => NetworkPage(),
                      settings: settings,
                    );
                  case '/developers':
                    return FadeInRoute(
                      builder: (_) => DevView(),
                      settings: settings,
                    );
                }
                assert(false);
              },
            ),
          );
        });
  }
}
