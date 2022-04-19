import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/l10n/locales.dart';
import 'package:breez/routes/fiat_currencies/fiat_currency_settings.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/routes/qr_scan.dart';
import 'package:breez/utils/locale.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bloc/lnurl/lnurl_bloc.dart';
import 'bloc/lsp/lsp_bloc.dart';
import 'bloc/reverse_swap/reverse_swap_bloc.dart';
import 'home_page.dart';
import 'routes/add_funds/deposit_to_btc_address_page.dart';
import 'routes/add_funds/moonpay_webview.dart';
import 'routes/charge/items/item_page.dart';
import 'routes/connect_to_pay/connect_to_pay_page.dart';
import 'routes/create_invoice/create_invoice_page.dart';
import 'routes/dev/dev.dart';
import 'routes/get_refund/get_refund_page.dart';
import 'routes/initial_walkthrough.dart';
import 'routes/lsp/select_lsp_page.dart';
import 'routes/marketplace/marketplace.dart';
import 'routes/network/network.dart';
import 'routes/order_card/order_card_page.dart';
import 'routes/security_pin/lock_screen.dart';
import 'routes/security_pin/security_pin_page.dart';
import 'routes/settings/pos_settings_page.dart';
import 'routes/splash_page.dart';
import 'routes/transactions/pos_transactions_page.dart';
import 'routes/withdraw_funds/reverse_swap_page.dart';
import 'routes/withdraw_funds/unexpected_funds.dart';
import 'theme_data.dart' as theme;

final routeObserver = RouteObserver();

Widget _withTheme(BreezUserModel user, Widget child) {
  if (user.appMode == AppMode.podcasts) {
    return withPodcastTheme(user, child);
  }
  return child;
}

// ignore: must_be_immutable
class UserApp extends StatelessWidget {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    var accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    var invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
    var userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    var backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    var connectPayBloc = AppBlocsProvider.of<ConnectPayBloc>(context);
    var lspBloc = AppBlocsProvider.of<LSPBloc>(context);
    var reverseSwapBloc = AppBlocsProvider.of<ReverseSwapBloc>(context);
    var lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);
    var posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);

    return StreamBuilder(
      stream: userProfileBloc.userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return StaticLoader();
        }

        BreezUserModel user = snapshot.data;
        theme.themeId = user.themeId;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ));
        return BlocProvider(
          creator: () => AddFundsBloc(
            userProfileBloc.userStream,
            accountBloc.accountStream,
            lspBloc.lspStatusStream,
          ),
          builder: (ctx) => MaterialApp(
            navigatorKey: _navigatorKey,
            title: getSystemAppLocalizations().app_name,
            theme: theme.themeMap[user.themeId],
            localizationsDelegates: localizationsDelegates(),
            supportedLocales: supportedLocales(),
            builder: (BuildContext context, Widget child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(
                  textScaleFactor: (data.textScaleFactor >= 1.3)
                      ? 1.3
                      : data.textScaleFactor,
                ),
                child: _withTheme(user, child),
              );
            },
            initialRoute: user.registrationRequested
                ? (user.locked ? '/lockscreen' : "/")
                : '/splash',
            // ignore: missing_return
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case '/intro':
                  return FadeInRoute(
                    builder: (_) => InitialWalkthroughPage(
                      userProfileBloc,
                      backupBloc,
                    ),
                    settings: settings,
                  );
                case '/splash':
                  return FadeInRoute(
                    builder: (_) => SplashPage(user),
                    settings: settings,
                  );
                case '/lockscreen':
                  return NoTransitionRoute(
                    builder: (ctx) => withBreezTheme(
                      ctx,
                      AppLockScreen(
                        (pinEntered) {
                          var validateAction = ValidatePinCode(pinEntered);
                          userProfileBloc.userActionsSink.add(validateAction);
                          return validateAction.future.then((_) {
                            Navigator.pop(ctx);
                            userProfileBloc.userActionsSink
                                .add(SetLockState(false));
                          });
                        },
                        onFingerprintEntered:
                            user.securityModel.isFingerprintEnabled
                                ? (isValid) async {
                                    if (isValid) {
                                      await Future.delayed(
                                        Duration(milliseconds: 200),
                                      );
                                      Navigator.pop(ctx);
                                      userProfileBloc.userActionsSink
                                          .add(SetLockState(false));
                                    }
                                  }
                                : null,
                        userProfileBloc: userProfileBloc,
                      ),
                    ),
                    settings: settings,
                  );
                case '/':
                  return FadeInRoute(
                    builder: (_) => WillPopScope(
                      onWillPop: () async {
                        return !await _homeNavigatorKey.currentState.maybePop();
                      },
                      child: Navigator(
                        key: _homeNavigatorKey,
                        observers: [routeObserver],
                        initialRoute: "/",
                        // ignore: missing_return
                        onGenerateRoute: (RouteSettings settings) {
                          switch (settings.name) {
                            case '/':
                              return FadeInRoute(
                                builder: (_) => Home(
                                  accountBloc,
                                  invoiceBloc,
                                  userProfileBloc,
                                  connectPayBloc,
                                  backupBloc,
                                  lspBloc,
                                  reverseSwapBloc,
                                  lnurlBloc,
                                ),
                                settings: settings,
                              );
                            case '/order_card':
                              return FadeInRoute(
                                builder: (_) => OrderCardPage(
                                  showSkip: false,
                                ),
                                settings: settings,
                              );
                            case '/order_card?skip=true':
                              return FadeInRoute(
                                builder: (_) => OrderCardPage(
                                  showSkip: true,
                                ),
                                settings: settings,
                              );
                            case '/deposit_btc_address':
                              return FadeInRoute(
                                builder: (_) => withBreezTheme(
                                  context,
                                  DepositToBTCAddressPage(),
                                ),
                                settings: settings,
                              );
                            case '/buy_bitcoin':
                              return FadeInRoute(
                                builder: (_) => MoonpayWebView(),
                                settings: settings,
                              );
                            case '/withdraw_funds':
                              return FadeInRoute(
                                builder: (_) => ReverseSwapPage(),
                                settings: settings,
                              );
                            case '/send_coins':
                              return MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) => withBreezTheme(
                                  context,
                                  UnexpectedFunds(),
                                ),
                                settings: settings,
                              );
                            case '/select_lsp':
                              return MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (_) => SelectLSPPage(
                                  lstBloc: lspBloc,
                                ),
                                settings: settings,
                              );
                            case '/get_refund':
                              return FadeInRoute(
                                builder: (_) => GetRefundPage(),
                                settings: settings,
                              );
                            case '/create_invoice':
                              return FadeInRoute(
                                builder: (_) => withBreezTheme(
                                  context,
                                  CreateInvoicePage(),
                                ),
                                settings: settings,
                              );
                            case '/fiat_currency':
                              return FadeInRoute(
                                builder: (_) => withBreezTheme(
                                  context,
                                  FiatCurrencySettings(
                                    accountBloc,
                                    userProfileBloc,
                                  ),
                                ),
                                settings: settings,
                              );
                            case '/network':
                              return FadeInRoute(
                                builder: (_) => withBreezTheme(
                                  context,
                                  NetworkPage(),
                                ),
                                settings: settings,
                              );
                            case '/security':
                              return FadeInRoute(
                                builder: (_) => withBreezTheme(
                                  context,
                                  SecurityPage(
                                    userProfileBloc,
                                    backupBloc,
                                  ),
                                ),
                                settings: settings,
                              );
                            case '/developers':
                              return FadeInRoute(
                                builder: (_) => withBreezTheme(
                                  context,
                                  DevView(),
                                ),
                                settings: settings,
                              );
                            case '/connect_to_pay':
                              return FadeInRoute(
                                builder: (_) => withBreezTheme(
                                  context,
                                  ConnectToPayPage(null),
                                ),
                                settings: settings,
                              );
                            case '/marketplace':
                              return FadeInRoute(
                                builder: (_) => MarketplacePage(),
                                settings: settings,
                              );
                            // POS routes
                            case '/add_item':
                              return FadeInRoute(
                                builder: (_) => ItemPage(posCatalogBloc),
                                settings: settings,
                              );
                            case '/transactions':
                              return FadeInRoute(
                                builder: (_) => PosTransactionsPage(),
                                settings: settings,
                              );
                            case '/settings':
                              return FadeInRoute(
                                builder: (_) => PosSettingsPage(),
                                settings: settings,
                              );
                            case '/qr_scan':
                              return MaterialPageRoute<String>(
                                fullscreenDialog: true,
                                builder: (_) => QRScan(),
                                settings: settings,
                              );
                          }
                          assert(false);
                        },
                      ),
                    ),
                    settings: settings,
                  );
              }
              assert(false);
            },
          ),
        );
      },
    );
  }
}
