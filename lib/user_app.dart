import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/shared/lsp/select_lsp_page.dart';
import 'package:breez/routes/shared/security_pin/lock_screen.dart';
import 'package:breez/routes/user/add_funds/deposit_to_btc_address_page.dart';
import 'package:breez/routes/user/add_funds/moonpay_webview.dart';
import 'package:breez/routes/user/get_refund/get_refund_page.dart';
import 'package:breez/routes/user/withdraw_funds/send_coins_dialog.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:breez/routes/user/connect_to_pay/connect_to_pay_page.dart';
import 'package:flutter/material.dart';
import 'package:breez/routes/shared/splash_page.dart';
import 'package:breez/routes/shared/initial_walkthrough.dart';
import 'package:breez/routes/shared/network/network.dart';
import 'package:breez/routes/shared/security_pin/security_pin_page.dart';
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
import 'package:flutter/services.dart';
import 'bloc/lsp/lsp_bloc.dart';
import 'theme_data.dart' as theme;

class UserApp extends StatelessWidget {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    var accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    var invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    var userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    var backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    var connectPayBloc = AppBlocsProvider.of<ConnectPayBloc>(context);
    var lspBloc = AppBlocsProvider.of<LSPBloc>(context);

    return StreamBuilder(
        stream: userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return StaticLoader();
          }

          BreezUserModel user = snapshot.data;
          theme.themeId = user.themeId;
          SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(statusBarColor: Colors.transparent));
          return BlocProvider(
              creator: () => AddFundsBloc(
                  userProfileBloc.userStream, accountBloc.accountStream),
              builder: (ctx) => MaterialApp(
                    navigatorKey: _navigatorKey,
                    title: 'Breez',
                    theme: theme.themeMap[user.themeId],
                    builder: (BuildContext context, Widget child) {
                      final MediaQueryData data = MediaQuery.of(context);
                      return MediaQuery(
                          data: data.copyWith(
                            textScaleFactor: (data.textScaleFactor >= 1.3)
                                ? 1.3
                                : data.textScaleFactor,
                          ),
                          child: child);
                    },
                    initialRoute: user.registrationRequested
                        ? (user.locked ? '/lockscreen' : null)
                        : '/splash',
                    home: Home(accountBloc, invoiceBloc, userProfileBloc,
                        connectPayBloc, backupBloc, lspBloc),
                    onGenerateRoute: (RouteSettings settings) {
                      switch (settings.name) {
                        case '/lockscreen':
                          return FadeInRoute(
                              builder: (ctx) => AppLockScreen(
                                    (pinEntered) {
                                      var validateAction =
                                          ValidatePinCode(pinEntered);
                                      userProfileBloc.userActionsSink
                                          .add(validateAction);
                                      return validateAction.future.then((_) {
                                        Navigator.pop(ctx);
                                        userProfileBloc.userActionsSink
                                            .add(SetLockState(false));
                                      });
                                    },
                                    onFingerprintEntered: user
                                            .securityModel.isFingerprintEnabled
                                        ? (isValid) async {
                                            if (isValid) {
                                              await Future.delayed(
                                                  Duration(milliseconds: 200));
                                              Navigator.pop(ctx);
                                              userProfileBloc.userActionsSink
                                                  .add(SetLockState(false));
                                            }
                                          }
                                        : null,
                                    userProfileBloc: userProfileBloc,
                                  ),
                              settings: settings);
                        case '/home':
                          return FadeInRoute(
                            builder: (_) => Home(
                                accountBloc,
                                invoiceBloc,
                                userProfileBloc,
                                connectPayBloc,
                                backupBloc,
                                lspBloc),
                            settings: settings,
                          );
                        case '/intro':
                          return FadeInRoute(
                            builder: (_) => InitialWalkthroughPage(
                                user, userProfileBloc, backupBloc, false),
                            settings: settings,
                          );
                        case '/order_card':
                          return FadeInRoute(
                            builder: (_) => OrderCardPage(showSkip: false),
                            settings: settings,
                          );
                        case '/order_card?skip=true':
                          return FadeInRoute(
                            builder: (_) => OrderCardPage(showSkip: true),
                            settings: settings,
                          );
                        case '/add_funds':
                          return FadeInRoute(
                            builder: (_) => AddFundsPage(),
                            settings: settings,
                          );
                        case '/deposit_btc_address':
                          return FadeInRoute(
                            builder: (_) =>
                                DepositToBTCAddressPage(accountBloc),
                            settings: settings,
                          );
                        case '/buy_bitcoin':
                          return FadeInRoute(
                            builder: (_) =>
                                MoonpayWebView(accountBloc, backupBloc),
                            settings: settings,
                          );
                        case '/withdraw_funds':
                          return FadeInRoute(
                            builder: (_) => WithdrawFundsPage(),
                            settings: settings,
                          );
                        case '/send_coins':
                          return MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) =>
                                SendCoinsDialog(accountBloc: accountBloc),
                            settings: settings,
                          );
                        case '/select_lsp':
                          return MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) => SelectLSPPage(lstBloc: lspBloc),
                            settings: settings,
                          );
                        case '/get_refund':
                          return FadeInRoute(
                            builder: (_) => GetRefundPage(),
                            settings: settings,
                          );
                        case '/activate_card':
                          return FadeInRoute(
                            builder: (_) => ActivateCardPage(),
                            settings: settings,
                          );
                        case '/pay_nearby':
                          return FadeInRoute(
                            builder: (_) => PayNearbyPage(),
                            settings: settings,
                          );
                        case '/pay_nearby_complete':
                          return FadeInRoute(
                            builder: (_) => PayNearbyComplete(),
                            settings: settings,
                          );
                        case '/create_invoice':
                          return FadeInRoute(
                            builder: (_) => CreateInvoicePage(),
                            settings: settings,
                          );
                        case '/network':
                          return FadeInRoute(
                            builder: (_) => NetworkPage(),
                            settings: settings,
                          );
                        case '/security':
                          return FadeInRoute(
                            builder: (_) =>
                                SecurityPage(userProfileBloc, backupBloc),
                            settings: settings,
                          );
                        case '/developers':
                          return FadeInRoute(
                            builder: (_) => DevView(),
                            settings: settings,
                          );
                        case '/splash':
                          return FadeInRoute(
                            builder: (_) => SplashPage(user),
                            settings: settings,
                          );
                        case '/connect_to_pay':
                          return FadeInRoute(
                            builder: (_) => ConnectToPayPage(null),
                            settings: settings,
                          );
                        case '/marketplace':
                          return FadeInRoute(
                            builder: (_) => MarketplacePage(),
                            settings: settings,
                          );
                        case '/fastbitcoins':
                          return FadeInRoute(
                            builder: (_) => FastbitcoinsPage(),
                            settings: settings,
                          );
                      }
                      assert(false);
                    },
                  ));
        });
  }
}
