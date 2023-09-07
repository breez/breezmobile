import 'dart:async';

import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/ui/anytime_podcast_app.dart';
import 'package:anytime/ui/podcast/now_playing.dart';
import 'package:audio_service/audio_service.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/nostr/nostr_actions.dart';
import 'package:breez/bloc/nostr/nostr_bloc.dart';
import 'package:breez/bloc/nostr/nostr_model.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/handlers/check_channel_connection_handler.dart';
import 'package:breez/handlers/check_version_handler.dart';
import 'package:breez/handlers/ctp_join_session_handler.dart';
import 'package:breez/handlers/lnurl_handler.dart';
import 'package:breez/handlers/podcast_url_handler.dart';
import 'package:breez/handlers/received_invoice_notification.dart';
import 'package:breez/handlers/show_pin_handler.dart';
import 'package:breez/handlers/sync_ui_handler.dart';
import 'package:breez/lnurl_success_action_dialog.dart';
import 'package:breez/routes/charge/pos_invoice.dart';
import 'package:breez/routes/connect_to_pay/connect_to_pay_page.dart';
import 'package:breez/routes/home/account_page.dart';
import 'package:breez/routes/home/bottom_actions_bar.dart';
import 'package:breez/routes/home/qr_action_button.dart';
import 'package:breez/routes/marketplace/marketplace.dart';
import 'package:breez/routes/podcast/podcast_page.dart' as breezPodcast;
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/routes/unexpected_error_dialog.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/breez_navigation_drawer.dart';
import 'package:breez/widgets/close_popup.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/home/home_app_bar.dart';
import 'package:breez/widgets/home/home_navigation_drawer.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez/widgets/lost_card_dialog.dart' as lostCard;
import 'package:breez/widgets/payment_failed_report_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey firstPaymentItemKey =
    GlobalKey(debugLabel: "firstPaymentItemKey");
final ScrollController scrollController = ScrollController();
final GlobalKey<ScaffoldState> _scaffoldKey =
    GlobalKey<ScaffoldState>(debugLabel: "scaffoldKey");

class Home extends StatefulWidget {
  final AccountBloc accountBloc;
  final InvoiceBloc invoiceBloc;
  final UserProfileBloc userProfileBloc;
  final ConnectPayBloc ctpBloc;
  final BackupBloc backupBloc;
  final LSPBloc lspBloc;
  final ReverseSwapBloc reverseSwapBloc;
  final LNUrlBloc lnurlBloc;
  final NostrBloc nostrBloc;

  Home(
    this.accountBloc,
    this.invoiceBloc,
    this.userProfileBloc,
    this.ctpBloc,
    this.backupBloc,
    this.lspBloc,
    this.reverseSwapBloc,
    this.lnurlBloc,
    this.nostrBloc,
  );

  final List<DrawerItemConfig> _screens = List<DrawerItemConfig>.unmodifiable([
    const DrawerItemConfig("breezHome", "Breez", ""),
  ]);

  final Map<String, Widget> _screenBuilders = {};

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with WidgetsBindingObserver {
  String _activeScreen = "breezHome";
  final Set _hiddenRoutes = <String>{};
  StreamSubscription<String> _accountNotificationsSubscription;
  bool _listensInit = false;

  @override
  void initState() {
    super.initState();
    _hiddenRoutes.add("/get_refund");
    widget.accountBloc.accountStream.listen((acc) {
      setState(() {
        if (acc != null &&
            acc.swapFundsStatus.maturedRefundableAddresses.isNotEmpty) {
          _hiddenRoutes.remove("/get_refund");
        } else {
          _hiddenRoutes.add("/get_refund");
        }
      });
    });

    widget.accountBloc.accountStream.listen((acc) {
      var activeAccountRoutes = [
        "/connect_to_pay",
        "/pay_invoice",
        "/create_invoice"
      ];
      Function addOrRemove =
          acc.connected ? _hiddenRoutes.remove : _hiddenRoutes.add;
      setState(() {
        for (var r in activeAccountRoutes) {
          addOrRemove(r);
        }
      });
    });

    AudioService.notificationClicked.where((event) => event == true).listen(
        (event) async {
      final navigator = Navigator.of(context);
      final userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      final audioBloc = Provider.of<AudioBloc>(context, listen: false);
      final userModel = await userBloc.userStream.first;
      final nowPlaying = await audioBloc.nowPlaying.first.timeout(
        const Duration(seconds: 1),
      );
      if (nowPlaying != null &&
          !breezPodcast.NowPlayingTransport.nowPlayingVisible) {
        navigator.push(
          MaterialPageRoute<void>(
            builder: (context) => withPodcastTheme(userModel, NowPlaying()),
            fullscreenDialog: false,
          ),
        );
      }
    }, onDone: () {
      if (kDebugMode) {
        print("done");
      }
    }, onError: (e) {
      if (kDebugMode) {
        print("error $e");
      }
    });
  }

  void _initListens(BuildContext context) {
    if (_listensInit) return;
    _listensInit = true;
    ServiceInjector().breezBridge.initBreezLib();
    _registerNotificationHandlers(context);
    listenUnexpectedError(context, widget.accountBloc);
    _listenBackupConflicts(context);
    _listenBackupNotLatestConflicts(context);
    _listenWhitelistPermissionsRequest(context);
    _listenLSPSelectionPrompt(context);
    _listenPaymentResults(context);
  }

  @override
  void dispose() {
    _accountNotificationsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initListens(context);
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    final mediaSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: willPopCallback(
        context,
        canCancel: () => _scaffoldKey.currentState?.isDrawerOpen ?? false,
      ),
      child: StreamBuilder<BreezUserModel>(
        stream: userProfileBloc.userStream,
        builder: (context, userSnapshot) {
          final appMode = userSnapshot.data?.appMode;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            appBar: HomeAppBar(_scaffoldKey),
            drawerEnableOpenDragGesture: true,
            drawerDragStartBehavior: DragStartBehavior.down,
            drawerEdgeDragWidth: mediaSize.width,
            drawer: HomeNavigationDrawer(
              _onNavigationItemSelected,
              _filterItems,
            ),
            bottomNavigationBar: appMode == AppMode.balance
                ? BottomActionsBar(firstPaymentItemKey)
                : null,
            floatingActionButton: appMode == AppMode.balance
                ? QrActionButton(firstPaymentItemKey)
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: widget._screenBuilders[_activeScreen] ??
                _homePage(context, appMode),
          );
        },
      ),
    );
  }

  Widget _homePage(BuildContext context, AppMode appMode) {
    if (appMode == null) {
      return AccountPage(firstPaymentItemKey, scrollController);
    }
    final texts = context.texts();
    final themeData = Theme.of(context);

    switch (appMode) {
      case AppMode.podcasts:
        return Container(
          color: themeData.bottomAppBarTheme.color,
          child: SafeArea(
            child: AnytimeHomePage(
              topBarVisible: false,
              inlineSearch: true,
              noSubscriptionsMessage: texts.home_podcast_no_subscriptions,
              title: texts.home_podcast_title,
            ),
          ),
        );
      case AppMode.pos:
        return const POSInvoice();
      case AppMode.apps:
        return MarketplacePage();
      default:
        return AccountPage(firstPaymentItemKey, scrollController);
    }
  }

  void _onNavigationItemSelected(String itemName) {
    if (widget._screens.map((sc) => sc.name).contains(itemName)) {
      setState(() {
        _activeScreen = itemName;
      });
    } else {
      if (itemName == "/lost_card") {
        showDialog(
          useRootNavigator: false,
          context: context,
          builder: (_) => const lostCard.LostCardDialog(),
        );
      } else {
        Navigator.of(context).pushNamed(itemName).then((message) {
          if (message != null && message.runtimeType == String) {
            showFlushbar(context, message: message);
          }
        });
      }
    }
  }

  void _registerNotificationHandlers(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    InvoiceNotificationsHandler(
      context,
      widget.userProfileBloc,
      widget.accountBloc,
      widget.invoiceBloc.receivedInvoicesStream,
      firstPaymentItemKey,
      scrollController,
      _scaffoldKey,
    );
    LNURLHandler(context, widget.lnurlBloc);
    CTPJoinSessionHandler(
      widget.userProfileBloc,
      widget.ctpBloc,
      this.context,
      (session) {
        Navigator.popUntil(context, (route) {
          return route.settings.name != "/connect_to_pay";
        });
        var ctpRoute = FadeInRoute(
          builder: (_) => withBreezTheme(
            context,
            ConnectToPayPage(session),
          ),
          settings: const RouteSettings(name: "/connect_to_pay"),
        );
        Navigator.of(context).push(ctpRoute);
      },
      (e) {
        promptError(
          context,
          texts.home_error_connect_to_pay,
          Text(
            e.toString(),
            style: themeData.dialogTheme.contentTextStyle,
          ),
        );
      },
    );
    PodcastURLHandler(
      widget.userProfileBloc,
      this.context,
      (e) {
        promptError(
          context,
          texts.home_error_podcast_link,
          Text(
            e.toString(),
            style: themeData.dialogTheme.contentTextStyle,
          ),
        );
      },
    );
    SyncUIHandler(widget.accountBloc, context);
    ShowPinHandler(widget.userProfileBloc, context);

    _accountNotificationsSubscription =
        widget.accountBloc.accountNotificationsStream.listen(
      (data) => showFlushbar(context, message: data),
      onError: (e) => showFlushbar(context, message: e.toString()),
    );
    widget.reverseSwapBloc.broadcastTxStream.listen((_) {
      showFlushbar(
        context,
        messageWidget: LoadingAnimatedText(
          texts.home_broadcast_transaction,
          textStyle: theme.snackBarStyle,
          textAlign: TextAlign.left,
        ),
      );
    });
    checkVersionDialog(context, widget.userProfileBloc);
    CheckChannelConnection().startListen(context, widget.accountBloc);
  }

  void _listenBackupConflicts(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    BackupSettings currentsettings;
    widget.backupBloc.backupSettingsStream.listen((settings) {
      currentsettings = settings;
      var encrypted = currentsettings?.backupKeyType == BackupKeyType.PHRASE;
      var provider = currentsettings?.backupProvider?.displayName;
      widget.accountBloc.nodeConflictStream.listen(
        (_) async {
          Navigator.popUntil(context, (route) {
            return route.settings.name == "/";
          });
          await promptError(
            context,
            texts.home_config_error_title,
            Text(
              encrypted
                  ? texts.home_config_backup_error_encrypted(provider)
                  : texts.home_config_backup_error(provider),
              style: themeData.dialogTheme.contentTextStyle,
            ),
          );
        },
      );
    });
  }

  void _listenBackupNotLatestConflicts(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    widget.backupBloc.backupSettingsStream.listen((settings) {
      var encrypted = settings?.backupKeyType == BackupKeyType.PHRASE;
      var provider = settings?.backupProvider?.displayName;
      widget.accountBloc.nodeBackupNotLatestStream.listen(
        (_) async {
          Navigator.popUntil(context, (route) {
            return route.settings.name == "/";
          });
          await promptError(
            context,
            texts.home_config_error_title,
            Text(
              encrypted
                  ? texts.home_config_backup_error_encrypted(provider)
                  : texts.home_config_backup_error(provider),
              style: themeData.dialogTheme.contentTextStyle,
            ),
          );
        },
      );
    });
  }

  void _listenLSPSelectionPrompt(BuildContext context) async {
    widget.lspBloc.lspPromptStream.first
        .then((_) => Navigator.of(context).pushNamed("/select_lsp"));
  }

  void _listenWhitelistPermissionsRequest(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    widget.accountBloc.optimizationWhitelistExplainStream.listen((_) async {
      await promptError(
        context,
        texts.home_background_synchronization_title,
        Text(
          texts.home_background_synchronization_message,
          style: themeData.dialogTheme.contentTextStyle,
        ),
        okFunc: () => widget.accountBloc.optimizationWhitelistRequestSink.add(
          null,
        ),
      );
    });
  }

  void _listenPaymentResults(BuildContext context) {
    final texts = context.texts();

    widget.accountBloc.completedPaymentsStream.listen(
      (fulfilledPayment) async {
        final paymentHash = fulfilledPayment.paymentHash;
        if (kDebugMode) {
          print('_listenPaymentResults processing: $paymentHash');
        }

        if (!fulfilledPayment.cancelled &&
            !fulfilledPayment.ignoreGlobalFeedback) {
          await scrollController
              .animateTo(scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.ease)
              .whenComplete(() async {
            var action =
                fulfilledPayment?.paymentItem?.lnurlPayInfo?.successAction;
            if (action?.hasTag() == true) {
              await Future.delayed(
                const Duration(seconds: 1),
                () => showLNURLSuccessAction(context, action),
              );
            } else {
              showFlushbar(
                context,
                messageWidget: SingleChildScrollView(
                  child: Text(texts.home_payment_sent),
                ),
              );
            }
          });
        }
      },
      onError: (err) async {
        var error = err as PaymentError;
        if (error.ignoreGlobalFeedback) {
          return;
        }
        final navigator = Navigator.of(context);
        var sendAction = SendPaymentFailureReport(error.traceReport);
        final loaderRoute = createLoaderRoute(
          context,
          message: texts.home_report_sending,
          opacity: 0.8,
          action: sendAction.future,
        );
        await widget.accountBloc.accountStream.first.then(
          (accountModel) async {
            final errorString = error.toDisplayMessage(accountModel.currency);
            if (error.validationError &&
                errorString.contains("payment is in transition")) {
              return;
            }
            showFlushbar(context, message: errorString);

            if (!error.validationError) {
              await widget.accountBloc.accountSettingsStream.first.then(
                (settings) async {
                  final behavior = settings.failedPaymentBehavior;
                  bool prompt = behavior == BugReportBehavior.PROMPT;
                  bool send = behavior == BugReportBehavior.SEND_REPORT;
                  if (prompt) {
                    send = await showDialog(
                      useRootNavigator: false,
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => PaymentFailedReportDialog(
                        context,
                        widget.accountBloc,
                      ),
                    );
                  }

                  if (send) {
                    widget.accountBloc.userActionsSink.add(sendAction);
                    await navigator.push(loaderRoute);
                  }
                },
              );
            }
          },
        );
      },
    );
  }

  List<DrawerItemConfig> _filterItems(List<DrawerItemConfig> items) {
    return items.where((c) => !_hiddenRoutes.contains(c.name)).toList();
  }

  DrawerItemConfig get activeScreen {
    return widget._screens.firstWhere((screen) => screen.name == _activeScreen);
  }
}
