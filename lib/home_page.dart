import 'dart:async';
import 'dart:io';

import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/ui/anytime_podcast_app.dart';
import 'package:anytime/ui/podcast/now_playing.dart';
import 'package:audio_service/audio_service.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_fund_vendor_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/admin_login_dialog.dart';
import 'package:breez/routes/charge/pos_invoice.dart';
import 'package:breez/routes/home/bottom_actions_bar.dart';
import 'package:breez/routes/home/qr_action_button.dart';
import 'package:breez/routes/marketplace/marketplace.dart';
import 'package:breez/routes/podcast/podcast_page.dart' as breezPodcast;
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/fade_in_widget.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez/widgets/lost_card_dialog.dart' as lostCard;
import 'package:breez/widgets/lsp_fee.dart';
import 'package:breez/widgets/navigation_drawer.dart';
import 'package:breez/widgets/payment_failed_report_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez/utils/i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'bloc/invoice/invoice_model.dart';
import 'bloc/user_profile/user_actions.dart';
import 'handlers/check_version_handler.dart';
import 'handlers/ctp_join_session_handler.dart';
import 'handlers/lnurl_handler.dart';
import 'handlers/podcast_url_handler.dart';
import 'handlers/received_invoice_notification.dart';
import 'handlers/showPinHandler.dart';
import 'handlers/sync_ui_handler.dart';
import 'routes/account_required_actions.dart';
import 'routes/connect_to_pay/connect_to_pay_page.dart';
import 'routes/home/account_page.dart';
import 'routes/no_connection_dialog.dart';

final GlobalKey firstPaymentItemKey = GlobalKey();
final ScrollController scrollController = ScrollController();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class Home extends StatefulWidget {
  final AccountBloc accountBloc;
  final InvoiceBloc invoiceBloc;
  final UserProfileBloc userProfileBloc;
  final ConnectPayBloc ctpBloc;
  final BackupBloc backupBloc;
  final LSPBloc lspBloc;
  final ReverseSwapBloc reverseSwapBloc;
  final LNUrlBloc lnurlBloc;

  Home(this.accountBloc, this.invoiceBloc, this.userProfileBloc, this.ctpBloc,
      this.backupBloc, this.lspBloc, this.reverseSwapBloc, this.lnurlBloc);

  final List<DrawerItemConfig> _screens = List<DrawerItemConfig>.unmodifiable(
      [DrawerItemConfig("breezHome", "Breez", "")]);

  final Map<String, Widget> _screenBuilders = {};

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with WidgetsBindingObserver {
  final GlobalKey podcastMenuItemKey = GlobalKey();
  String _activeScreen = "breezHome";
  Set _hiddenRoutes = Set<String>();
  StreamSubscription<String> _accountNotificationsSubscription;
  AudioBloc audioBloc;

  TutorialCoachMark tutorial;
  List<TargetFocus> targets = [];

  @override
  void initState() {
    super.initState();
    audioBloc = Provider.of<AudioBloc>(context, listen: false);
    WidgetsBinding.instance.addObserver(this);
    audioBloc.transitionLifecycleState(LifecyleState.resume);

    _registerNotificationHandlers();
    listenNoConnection(context, widget.accountBloc);
    _listenBackupConflicts();
    _listenWhitelistPermissionsRequest();
    _listenLSPSelectionPrompt();
    _listenPaymentResults();
    _hiddenRoutes.add("/get_refund");
    widget.accountBloc.accountStream.listen((acc) {
      setState(() {
        if (acc != null &&
            acc.swapFundsStatus.maturedRefundableAddresses.length > 0) {
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
        activeAccountRoutes.forEach((r) => addOrRemove(r));
      });
    });

    AudioService.notificationClickEventStream
        .where((event) => event == true)
        .listen((event) async {
      final userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      final userModel = await userBloc.userStream.first;
      final nowPlaying =
          await audioBloc.nowPlaying.first.timeout(Duration(seconds: 1));
      if (nowPlaying != null &&
          !breezPodcast.NowPlayingTransport.nowPlayingVisible) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
              builder: (context) => withPodcastTheme(userModel, NowPlaying()),
              fullscreenDialog: false),
        );
      }
    }, onDone: () {
      print("done");
    }, onError: (e) {
      print("error " + e.toString());
    });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   final audioBloc = Provider.of<AudioBloc>(context, listen: false);

  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       audioBloc.transitionLifecycleState(LifecyleState.resume);
  //       break;
  //     case AppLifecycleState.paused:
  //       audioBloc.transitionLifecycleState(LifecyleState.pause);
  //       break;
  //     default:
  //       break;
  //   }
  // }

  @override
  void dispose() {
    audioBloc.transitionLifecycleState(LifecyleState.pause);
    WidgetsBinding.instance.removeObserver(this);
    _accountNotificationsSubscription?.cancel();
    super.dispose();
  }

  Future<dynamic> _showTutorial() {
    return Future.delayed(Duration(milliseconds: 200), () {
      if (_scaffoldKey.currentState.isDrawerOpen) {
        _buildTutorial();
      }
    });
  }

  void _buildTutorial() {
    tutorial = TutorialCoachMark(context,
        targets: targets,
        opacityShadow: 0.9,
        textSkip: I18N.t(context, "DISMISS"),
        colorShadow: Theme.of(context).primaryColorLight,
        onClickOverlay: (s) => tutorial.finish(),
        onClickTarget: (s) {
          tutorial.finish();
          widget.userProfileBloc.userActionsSink
              .add(SetAppMode(AppMode.podcasts));
          Navigator.pop(context);
        },
        onSkip: () => tutorial.finish(),
        onFinish: () {
          final userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
          userBloc.userActionsSink.add(SetSeenPodcastTutorial(true));
        });
    _buildTutorialTargets();
  }

  void _buildTutorialTargets() {
    targets.add(TargetFocus(
      identify: "PodcastMenuItem",
      keyTarget: podcastMenuItemKey,
      enableOverlayTab: true,
      shape: ShapeLightFocus.RRect,
      paddingFocus: 8,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "New!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Stream sats to your favorite podcasters while they stream ideas back to you.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ))
      ],
    ));
    tutorial.show();
  }

  @override
  Widget build(BuildContext context) {
    AddFundsBloc addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
    LSPBloc lspBloc = AppBlocsProvider.of<LSPBloc>(context);
    return WillPopScope(
      onWillPop: () {
        return promptAreYouSure(context, "Exit Breez",
                Text("Do you really want to quit Breez?"))
            .then((shouldExit) {
          if (shouldExit) {
            exit(0);
          }
          return false;
        });
      },
      child: StreamBuilder<BreezUserModel>(
          stream: widget.userProfileBloc.userStream,
          builder: (context, userSnapshot) {
            var user = userSnapshot.data;

            return StreamBuilder<AccountModel>(
                stream: widget.accountBloc.accountStream,
                builder: (context, accSnapshot) {
                  var account = accSnapshot.data;
                  if (account == null) {
                    return SizedBox();
                  }
                  return StreamBuilder<AccountSettings>(
                      stream: widget.accountBloc.accountSettingsStream,
                      builder: (context, settingsSnapshot) {
                        var settings = settingsSnapshot.data;
                        if (settings == null) {
                          return SizedBox();
                        }

                        return StreamBuilder<LSPStatus>(
                            stream: lspBloc.lspStatusStream,
                            builder: (context, lspSnapshot) {
                              return StreamBuilder<List<AddFundVendorModel>>(
                                  stream: addFundsBloc.availableVendorsStream,
                                  builder: (context, snapshot) {
                                    List<DrawerItemConfig> addFundsVendors = [];
                                    if (snapshot.data != null) {
                                      snapshot.data.forEach((v) {
                                        if (v.isAllowed) {
                                          var vendorDrawerConfig =
                                              DrawerItemConfig(
                                                  v.route,
                                                  I18N.t(context,
                                                      v.shortName ?? v.name),
                                                  v.icon,
                                                  disabled: !v.enabled ||
                                                      v.requireActiveChannel &&
                                                          !account.connected,
                                                  onItemSelected: (item) {
                                            if (!v.showLSPFee) {
                                              Navigator.of(context)
                                                  .pushNamed(v.route);
                                              return;
                                            }
                                            promptLSPFeeAndNavigate(
                                                context,
                                                account,
                                                lspSnapshot.data.currentLSP,
                                                v.route);
                                          });

                                          addFundsVendors
                                              .add(vendorDrawerConfig);
                                        }
                                      });
                                    }
                                    var refundableAddresses = account
                                        .swapFundsStatus
                                        .maturedRefundableAddresses;
                                    var refundItems = <DrawerItemConfigGroup>[];
                                    if (refundableAddresses.length > 0) {
                                      refundItems = [
                                        DrawerItemConfigGroup([
                                          DrawerItemConfig("", "Get Refund",
                                              "src/icon/withdraw_funds.png",
                                              onItemSelected: (_) =>
                                                  protectAdminRoute(context,
                                                      user, "/get_refund"))
                                        ])
                                      ];
                                    }

                                    var flavorItems = <DrawerItemConfigGroup>[];
                                    flavorItems = user.appMode == AppMode.pos
                                        ? [
                                            DrawerItemConfigGroup([
                                              DrawerItemConfig(
                                                  "/transactions",
                                                  I18N.t(
                                                      context, "transactions"),
                                                  "src/icon/transactions.png")
                                            ])
                                          ]
                                        : [];

                                    var balanceItem = DrawerItemConfig(
                                      "",
                                      I18N.t(context, "balance"),
                                      "src/icon/balance.png",
                                      isSelected:
                                          user.appMode == AppMode.balance,
                                      onItemSelected: (_) {
                                        protectAdminAction(context, user, () {
                                          widget.userProfileBloc.userActionsSink
                                              .add(SetAppMode(AppMode.balance));
                                          return Future.value(null);
                                        });
                                      },
                                    );

                                    var podcastItem = DrawerItemConfig(
                                      "",
                                      I18N.t(context, "podcasts"),
                                      "src/icon/podcast.png",
                                      key: podcastMenuItemKey,
                                      isSelected:
                                          user.appMode == AppMode.podcasts,
                                      onItemSelected: (_) {
                                        protectAdminAction(context, user, () {
                                          widget.userProfileBloc.userActionsSink
                                              .add(
                                                  SetAppMode(AppMode.podcasts));
                                          return Future.value(null);
                                        });
                                      },
                                    );

                                    var posItem = DrawerItemConfig(
                                      "",
                                      I18N.t(context, "point_of_sale"),
                                      "src/icon/pos.png",
                                      isSelected: user.appMode == AppMode.pos,
                                      onItemSelected: (_) {
                                        widget.userProfileBloc.userActionsSink
                                            .add(SetAppMode(AppMode.pos));
                                      },
                                    );

                                    var lightningAppsItem = DrawerItemConfig(
                                        "",
                                        I18N.t(context, "apps"),
                                        "src/icon/apps.png",
                                        isSelected: user.appMode ==
                                            AppMode.apps, onItemSelected: (_) {
                                      protectAdminAction(context, user, () {
                                        widget.userProfileBloc.userActionsSink
                                            .add(SetAppMode(AppMode.apps));
                                        return Future.value(null);
                                      });
                                    });

                                    var appModeItems =
                                        <DrawerItemConfigGroup>[];
                                    appModeItems = [
                                      DrawerItemConfigGroup([
                                        balanceItem,
                                      ]),
                                      DrawerItemConfigGroup([
                                        podcastItem,
                                      ]),
                                      DrawerItemConfigGroup([
                                        posItem,
                                      ]),
                                      DrawerItemConfigGroup([
                                        lightningAppsItem,
                                      ]),
                                      DrawerItemConfigGroup([])
                                    ];

                                    var advancedFlavorItems =
                                        <DrawerItemConfig>[];
                                    advancedFlavorItems = user.appMode ==
                                            AppMode.pos
                                        ? [
                                            DrawerItemConfig("", "POS Settings",
                                                "src/icon/settings.png",
                                                onItemSelected: (_) =>
                                                    protectAdminRoute(context,
                                                        user, "/settings")),
                                          ]
                                        : [
                                            DrawerItemConfig(
                                                "/developers",
                                                I18N.t(context, "developers"),
                                                "src/icon/developers.png")
                                          ];

                                    return StreamBuilder<
                                            Future<DecodedClipboardData>>(
                                        stream: widget
                                            .invoiceBloc.decodedClipboardStream,
                                        builder: (context, snapshot) {
                                          return Container(
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: FadeInWidget(
                                              child: Scaffold(
                                                  resizeToAvoidBottomInset:
                                                      false,
                                                  key: _scaffoldKey,
                                                  appBar: AppBar(
                                                    brightness:
                                                        theme.themeId == "BLUE"
                                                            ? Brightness.light
                                                            : Theme.of(context)
                                                                .appBarTheme
                                                                .brightness,
                                                    centerTitle: false,
                                                    actions: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(14.0),
                                                        child:
                                                            AccountRequiredActionsIndicator(
                                                                widget
                                                                    .backupBloc,
                                                                widget
                                                                    .accountBloc,
                                                                widget.lspBloc),
                                                      ),
                                                    ],
                                                    leading: _buildMenuIcon(
                                                        context,
                                                        user.appMode,
                                                        user.seenTutorials
                                                            .podcastsTutorial),
                                                    title: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      icon: SvgPicture.asset(
                                                        "src/images/logo-color.svg",
                                                        height: 23.5,
                                                        width: 62.7,
                                                        color: Theme.of(context)
                                                            .appBarTheme
                                                            .actionsIconTheme
                                                            .color,
                                                        colorBlendMode:
                                                            BlendMode.srcATop,
                                                      ),
                                                      iconSize: 64,
                                                      onPressed: () async {
                                                        _scaffoldKey
                                                            .currentState
                                                            .openDrawer();
                                                        if (!user.seenTutorials
                                                            .podcastsTutorial) {
                                                          _showTutorial();
                                                        }
                                                      },
                                                    ),
                                                    iconTheme: IconThemeData(
                                                        color: Color.fromARGB(
                                                            255, 0, 133, 251)),
                                                    backgroundColor: (user
                                                                .appMode ==
                                                            AppMode.pos)
                                                        ? Theme.of(context)
                                                            .backgroundColor
                                                        : theme
                                                            .customData[
                                                                theme.themeId]
                                                            .dashboardBgColor,
                                                    elevation: 0.0,
                                                  ),
                                                  drawerEnableOpenDragGesture:
                                                      true,
                                                  drawerDragStartBehavior:
                                                      DragStartBehavior.down,
                                                  drawerEdgeDragWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  drawer: Theme(
                                                    data: theme
                                                        .themeMap[user.themeId],
                                                    child: NavigationDrawer(
                                                        true,
                                                        [
                                                          ...refundItems,
                                                          ...appModeItems,
                                                          ...flavorItems,
                                                          DrawerItemConfigGroup(
                                                            _filterItems([
                                                              DrawerItemConfig(
                                                                  "/fiat_currency",
                                                                  I18N.t(
                                                                      context,
                                                                      "fiat_currencies"),
                                                                  "src/icon/fiat_currencies.png"),
                                                              DrawerItemConfig(
                                                                  "/network",
                                                                  I18N.t(
                                                                      context,
                                                                      "network"),
                                                                  "src/icon/network.png"),
                                                              DrawerItemConfig(
                                                                  "/security",
                                                                  I18N.t(
                                                                      context,
                                                                      "security_and_backup"),
                                                                  "src/icon/security.png"),
                                                              ...advancedFlavorItems,
                                                            ]),
                                                            groupTitle: I18N.t(
                                                                context,
                                                                "preferences"),
                                                            groupAssetImage: "",
                                                          ),
                                                        ],
                                                        _onNavigationItemSelected),
                                                  ),
                                                  bottomNavigationBar: user
                                                              .appMode ==
                                                          AppMode.balance
                                                      ? BottomActionsBar(account,
                                                          firstPaymentItemKey)
                                                      : null,
                                                  floatingActionButton: user
                                                              .appMode ==
                                                          AppMode.balance
                                                      ? QrActionButton(account,
                                                          firstPaymentItemKey)
                                                      : null,
                                                  floatingActionButtonLocation:
                                                      FloatingActionButtonLocation
                                                          .centerDocked,
                                                  body: widget._screenBuilders[
                                                          _activeScreen] ??
                                                      _homePage(user)),
                                            ),
                                          );
                                        });
                                  });
                            });
                      });
                });
          }),
    );
  }

  IconButton _buildMenuIcon(
      BuildContext context, AppMode appMode, bool seenPodcastTutorial) {
    return IconButton(
        icon: Image.asset(
          _getAppModesAssetName(appMode),
          height: 24.0,
          width: 24.0,
          color: Theme.of(context).appBarTheme.actionsIconTheme.color,
        ),
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
          if (!seenPodcastTutorial) _showTutorial();
        });
  }

  String _getAppModesAssetName(AppMode appMode) {
    switch (appMode) {
      case (AppMode.podcasts):
        return "src/icon/podcast.png";
      case (AppMode.pos):
        return "src/icon/pos.png";
      case (AppMode.apps):
        return "src/icon/apps.png";
      case (AppMode.balance):
        return "src/icon/balance.png";
      default:
        return "src/icon/hamburger.svg";
    }
  }

//  noSubscriptionsMessage:
//               "Use the Discover view to find and subscribe to your first podcast",
  _homePage(BreezUserModel user) {
    switch (user.appMode) {
      case AppMode.podcasts:
        return Container(
          color: Theme.of(context).bottomAppBarColor,
          child: SafeArea(
            child: AnytimeHomePage(
              topBarVisible: false,
              inlineSearch: true,
              noSubscriptionsMessage:
                  "Use the Discover view to find and subscribe to your first podcast",
              title: 'Anytime Podcast Player',
            ),
          ),
        );
      case AppMode.pos:
        return POSInvoice();
      case AppMode.apps:
        return MarketplacePage();
      default:
        return AccountPage(firstPaymentItemKey, scrollController);
    }
  }

  _onNavigationItemSelected(String itemName) {
    if (widget._screens.map((sc) => sc.name).contains(itemName)) {
      setState(() {
        _activeScreen = itemName;
      });
    } else {
      if (itemName == "/lost_card") {
        showDialog(
            useRootNavigator: false,
            context: context,
            builder: (_) => lostCard.LostCardDialog(
                  context: context,
                ));
      } else {
        Navigator.of(context).pushNamed(itemName).then((message) {
          if (message != null && message.runtimeType == String) {
            showFlushbar(context, message: message);
          }
        });
      }
    }
  }

  void _registerNotificationHandlers() {
    InvoiceNotificationsHandler(
        context,
        widget.userProfileBloc,
        widget.accountBloc,
        widget.invoiceBloc.receivedInvoicesStream,
        firstPaymentItemKey,
        scrollController,
        _scaffoldKey);
    LNURLHandler(context, widget.lnurlBloc);
    CTPJoinSessionHandler(widget.userProfileBloc, widget.ctpBloc, this.context,
        (session) {
      Navigator.popUntil(context, (route) {
        return route.settings.name != "/connect_to_pay";
      });
      var ctpRoute = FadeInRoute(
          builder: (_) => ConnectToPayPage(session),
          settings: RouteSettings(name: "/connect_to_pay"));
      Navigator.of(context).push(ctpRoute);
    }, (e) {
      promptError(
          context,
          I18N.t(context, "connect_to_pay"),
          Text(e.toString(),
              style: Theme.of(context).dialogTheme.contentTextStyle));
    });
    PodcastURLHandler(widget.userProfileBloc, this.context, (e) {
      promptError(
          context,
          "Podcast Link",
          Text(e.toString(),
              style: Theme.of(context).dialogTheme.contentTextStyle));
    });
    SyncUIHandler(widget.accountBloc, context);
    ShowPinHandler(widget.userProfileBloc, context);

    _accountNotificationsSubscription = widget
        .accountBloc.accountNotificationsStream
        .listen((data) => showFlushbar(context, message: data),
            onError: (e) => showFlushbar(context, message: e.toString()));
    widget.reverseSwapBloc.broadcastTxStream.listen((_) {
      showFlushbar(context,
          messageWidget: LoadingAnimatedText("Broadcasting your transaction",
              textStyle: theme.snackBarStyle, textAlign: TextAlign.left));
    });
    CheckVersionHandler(context, widget.userProfileBloc);
  }

  void _listenBackupConflicts() {
    widget.accountBloc.nodeConflictStream.listen((_) async {
      Navigator.popUntil(context, (route) {
        return route.settings.name == "/";
      });
      await promptError(
          context,
          "Configuration Error",
          Text(
              "Breez detected another device is running with the same configuration (probably due to restore). Breez cannot run the same configuration on more than one device. Please reinstall Breez if you wish to continue using Breez on this device.",
              style: Theme.of(context).dialogTheme.contentTextStyle),
          okText: "Exit Breez",
          okFunc: () => exit(0),
          disableBack: true);
    });
  }

  void _listenLSPSelectionPrompt() async {
    widget.lspBloc.lspPromptStream.first
        .then((_) => Navigator.of(context).pushNamed("/select_lsp"));
  }

  void _listenWhitelistPermissionsRequest() {
    widget.accountBloc.optimizationWhitelistExplainStream.listen((_) async {
      await promptError(
          context,
          "Background Synchronization",
          Text(
              "In order to support instantaneous payments, Breez needs your permission in order to synchronize the information while the app is not active. Please approve the app in the next dialog.",
              style: Theme.of(context).dialogTheme.contentTextStyle),
          okFunc: () =>
              widget.accountBloc.optimizationWhitelistRequestSink.add(null));
    });
  }

  void _listenPaymentResults() {
    widget.accountBloc.completedPaymentsStream.listen((fulfilledPayment) {
      if (!fulfilledPayment.cancelled &&
          !fulfilledPayment.ignoreGlobalFeedback) {
        scrollController.animateTo(scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 10), curve: Curves.ease);
        showFlushbar(context, message: "Payment was successfully sent!");
      }
    }, onError: (err) async {
      var error = err as PaymentError;
      if (error.ignoreGlobalFeedback) {
        return;
      }
      var accountSettings =
          await widget.accountBloc.accountSettingsStream.first;
      bool prompt =
          accountSettings.failedPaymentBehavior == BugReportBehavior.PROMPT;
      bool send = accountSettings.failedPaymentBehavior ==
          BugReportBehavior.SEND_REPORT;

      var accountModel = await widget.accountBloc.accountStream.first;
      var errorString = error.toDisplayMessage(accountModel.currency);
      showFlushbar(context, message: "$errorString");
      if (!error.validationError) {
        if (prompt) {
          send = await showDialog(
              useRootNavigator: false,
              context: context,
              barrierDismissible: false,
              builder: (_) =>
                  PaymentFailedReportDialog(context, widget.accountBloc));
        }

        if (send) {
          var sendAction = SendPaymentFailureReport(error.traceReport);
          widget.accountBloc.userActionsSink.add(sendAction);
          await Navigator.push(
              context,
              createLoaderRoute(context,
                  message: "Sending Report...",
                  opacity: 0.8,
                  action: sendAction.future));
        }
      }
    });
  }

  List<DrawerItemConfig> _filterItems(List<DrawerItemConfig> items) {
    return items.where((c) => !_hiddenRoutes.contains(c.name)).toList();
  }

  DrawerItemConfig get activeScreen {
    return widget._screens.firstWhere((screen) => screen.name == _activeScreen);
  }
}
