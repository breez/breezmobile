import 'dart:ui';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/user/get_refund/get_refund_page.dart';
import 'package:breez/routes/user/withdraw_funds/send_coins_dialog.dart';
import 'package:breez/widgets/fade_in_widget.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:breez/routes/user/connect_to_pay/connect_to_pay_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez/routes/shared/splash_page.dart';
import 'package:breez/routes/shared/initial_walkthrough.dart';
import 'package:breez/routes/shared/network/network.dart';
import 'package:breez/routes/shared/security_pin/security_pin_page.dart';
import 'package:breez/routes/shared/security_pin/prompt_pin_code.dart';
import 'package:breez/routes/shared/dev/dev.dart';
import 'package:breez/routes/user/activate_card/activate_card_page.dart';
import 'package:breez/routes/user/add_funds/add_funds_page.dart';
import 'package:breez/routes/user/add_funds/fastbitcoins_page.dart';
import 'package:breez/routes/user/home/home_page.dart';
import 'package:breez/routes/user/order_card/order_card_page.dart';
import 'package:breez/routes/user/withdraw_funds/withdraw_funds_page.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez/routes/user/pay_nearby/pay_nearby_page.dart';
import 'package:breez/routes/user/pay_nearby/pay_nearby_complete.dart';
import 'package:breez/routes/user/create_invoice/create_invoice_page.dart';
import 'package:breez/routes/user/marketplace/marketplace.dart';
import 'package:breez/theme_data.dart' as theme;

class UserApp extends StatelessWidget {
  GlobalKey<NavigatorState> _navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    var accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    var invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    var userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    var backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    var connectPayBloc = AppBlocsProvider.of<ConnectPayBloc>(context);

    return StreamBuilder(
        stream: userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return StaticLoader();
          }

          BreezUserModel user = snapshot.data;
          return MaterialApp(
            navigatorKey: _navigatorKey,
            title: 'Breez',
            theme: ThemeData(
              backgroundColor: theme.BreezColors.blue[500],
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
            initialRoute: user.registered ? (user.waitingForPin ? '/lockscreen' : null) : '/splash',
            home: new Home(accountBloc, invoiceBloc, userProfileBloc, connectPayBloc, backupBloc),
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case '/lockscreen':
                  return new FadeInRoute(
                      builder: (_) => new LockScreen(),
                      settings: settings
                  );
                case '/home':
                  return new FadeInRoute(
                    builder: (_) => new Home(accountBloc,invoiceBloc,userProfileBloc,connectPayBloc,backupBloc),
                    settings: settings,
                  );
                case '/intro':
                  return new FadeInRoute(
                    builder: (_) => new InitialWalkthroughPage(
                        userProfileBloc, backupBloc, false),
                    settings: settings,
                  );
                case '/order_card':
                  return new FadeInRoute(
                    builder: (_) => new OrderCardPage(showSkip: false),
                    settings: settings,
                  );
                case '/order_card?skip=true':
                  return new FadeInRoute(
                    builder: (_) => new OrderCardPage(showSkip: true),
                    settings: settings,
                  );
                case '/add_funds':
                  return new FadeInRoute(
                    builder: (_) => new AddFundsPage(user, accountBloc),
                    settings: settings,
                  );
                case '/withdraw_funds':
                  return new FadeInRoute(
                    builder: (_) => new WithdrawFundsPage(),
                    settings: settings,
                  );
                case '/send_coins':
                  return new MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) =>
                        new SendWalletFundsDialog(accountBloc),
                    settings: settings,
                  );
                case '/get_refund':
                  return new FadeInRoute(
                    builder: (_) => new GetRefundPage(),
                    settings: settings,
                  );
                case '/activate_card':
                  return new FadeInRoute(
                    builder: (_) => new ActivateCardPage(),
                    settings: settings,
                  );
                case '/pay_nearby':
                  return new FadeInRoute(
                    builder: (_) => new PayNearbyPage(),
                    settings: settings,
                  );
                case '/pay_nearby_complete':
                  return new FadeInRoute(
                    builder: (_) => new PayNearbyComplete(),
                    settings: settings,
                  );
                case '/create_invoice':
                  return new FadeInRoute(
                    builder: (_) => new CreateInvoicePage(),
                    settings: settings,
                  );
                case '/network':
                  return new FadeInRoute(
                    builder: (_) => new NetworkPage(),
                    settings: settings,
                  );
                case '/security':
                  return new FadeInRoute(
                    builder: (_) => (user.waitingForPin) ? new LockScreen(dismissible: true, route: new SecurityPage(),) : new SecurityPage(),
                    settings: settings,
                  );
                case '/developers':
                  return new FadeInRoute(
                    builder: (_) => new DevView(),
                    settings: settings,
                  );
                case '/splash':
                  return new FadeInRoute(
                    builder: (_) => new SplashPage(user),
                    settings: settings,
                  );
                case '/connect_to_pay':
                  return new FadeInRoute(
                    builder: (_) => new ConnectToPayPage(null),
                    settings: settings,
                  );
                case '/marketplace':
                  return new FadeInRoute(
                    builder: (_) => new MarketplacePage(),
                    settings: settings,
                  );
                case '/fastbitcoins':
                  return new FadeInRoute(
                    builder: (_) =>
                    new FastbitcoinsPage(),
                    settings: settings,
                  );
              }
              assert(false);
            },
          );
        });
  }
}
