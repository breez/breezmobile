import 'dart:async';

import 'package:clovrlabs_wallet/bloc/account/account_actions.dart';
import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/bloc/account/add_fund_vendor_model.dart';
import 'package:clovrlabs_wallet/bloc/account/add_funds_bloc.dart';
import 'package:clovrlabs_wallet/bloc/backup/backup_bloc.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:clovrlabs_wallet/bloc/invoice/invoice_bloc.dart';
import 'package:clovrlabs_wallet/bloc/lnurl/lnurl_bloc.dart';
import 'package:clovrlabs_wallet/bloc/lsp/lsp_bloc.dart';
import 'package:clovrlabs_wallet/bloc/lsp/lsp_model.dart';
import 'package:clovrlabs_wallet/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/clovr_user_model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/user_profile_bloc.dart';
import 'package:clovrlabs_wallet/handlers/check_channel_connection_handler.dart';
import 'package:clovrlabs_wallet/routes/admin_login_dialog.dart';
import 'package:clovrlabs_wallet/routes/charge/pos_invoice.dart';
import 'package:clovrlabs_wallet/routes/home/bottom_actions_bar.dart';
import 'package:clovrlabs_wallet/routes/home/qr_action_button.dart';
import 'package:clovrlabs_wallet/routes/marketplace/marketplace.dart';
import 'package:clovrlabs_wallet/utils/theme.dart';
import 'package:clovrlabs_wallet/services/injector.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/widgets/close_popup.dart';
import 'package:clovrlabs_wallet/widgets/error_dialog.dart';
import 'package:clovrlabs_wallet/widgets/fade_in_widget.dart';
import 'package:clovrlabs_wallet/widgets/flushbar.dart';
import 'package:clovrlabs_wallet/widgets/loader.dart';
import 'package:clovrlabs_wallet/widgets/loading_animated_text.dart';
import 'package:clovrlabs_wallet/widgets/lost_card_dialog.dart' as lostCard;
import 'package:clovrlabs_wallet/widgets/navigation_drawer.dart';
import 'package:clovrlabs_wallet/widgets/payment_failed_report_dialog.dart';
import 'package:clovrlabs_wallet/widgets/route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bloc/invoice/invoice_model.dart';
import 'bloc/user_profile/user_actions.dart';
import 'handlers/ctp_join_session_handler.dart';
import 'handlers/lnurl_handler.dart';
import 'handlers/received_invoice_notification.dart';
import 'handlers/showPinHandler.dart';
import 'handlers/sync_ui_handler.dart';
import 'lnurl_success_action_dialog.dart';
import 'routes/account_required_actions.dart';
import 'routes/connect_to_pay/connect_to_pay_page.dart';
import 'routes/home/account_page.dart';
import 'routes/unexpected_error_dialog.dart';

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

  Home(
    this.accountBloc,
    this.invoiceBloc,
    this.userProfileBloc,
    this.ctpBloc,
    this.backupBloc,
    this.lspBloc,
    this.reverseSwapBloc,
    this.lnurlBloc,
  );

  final List<DrawerItemConfig> _screens = List<DrawerItemConfig>.unmodifiable([
    DrawerItemConfig("ClovrLabs", "ClovrLabs", ""),
  ]);

  final Map<String, Widget> _screenBuilders = {};

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with WidgetsBindingObserver {
  String _activeScreen = "ClovrLabs";
  Set _hiddenRoutes = Set<String>();
  StreamSubscription<String> _accountNotificationsSubscription;
  bool _listensInit = false;

  @override
  void initState() {
    super.initState();
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
  }

  void _initListens(BuildContext context) {
    if (_listensInit) return;
    _listensInit = true;
    ServiceInjector().breezBridge.initBreezLib();
    _registerNotificationHandlers(context);
    listenUnexpectedError(context, widget.accountBloc);
    _listenBackupConflicts(context);
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

    final addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
    final lspBloc = AppBlocsProvider.of<LSPBloc>(context);
    final texts = AppLocalizations.of(context);
    // return SizedBox();

    return WillPopScope(
      onWillPop: willPopCallback(
        context,
        canCancel: () => _scaffoldKey.currentState?.isDrawerOpen ?? false,
      ),
      child: StreamBuilder<ClovrUserModel>(
        stream: widget.userProfileBloc.userStream,
        builder: (context, userSnapshot) {
          final user = userSnapshot.data;

          return StreamBuilder<AccountModel>(
            stream: widget.accountBloc.accountStream,
            builder: (context, accSnapshot) {
              final account = accSnapshot.data;
              if (account == null) {
                return SizedBox();
              }

              return StreamBuilder<AccountSettings>(
                stream: widget.accountBloc.accountSettingsStream,
                builder: (context, settingsSnapshot) {
                  final settings = settingsSnapshot.data;
                  if (settings == null) {
                    return SizedBox();
                  }

                  return StreamBuilder<LSPStatus>(
                    stream: lspBloc.lspStatusStream,
                    builder: (context, lspSnapshot) {
                      final lspStatus = lspSnapshot.data;

                      return StreamBuilder<List<AddFundVendorModel>>(
                        stream: addFundsBloc.availableVendorsStream,
                        builder: (context, snapshot) {
                          final vendor = snapshot.data;

                          return StreamBuilder<Future<DecodedClipboardData>>(
                            stream: widget.invoiceBloc.decodedClipboardStream,
                            builder: (context, snapshot) {
                              return _build(
                                context,
                                user,
                                account,
                                settings,
                                lspStatus,
                                vendor,
                                texts,
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _build(
    BuildContext context,
    ClovrUserModel user,
    AccountModel account,
    AccountSettings settings,
    LSPStatus lspStatus,
    List<AddFundVendorModel> vendor,
    AppLocalizations texts,
  ) {
    final themeData = Theme.of(context);
    final mediaSize = MediaQuery.of(context).size;

    return Container(
      height: mediaSize.height,
      width: mediaSize.width,
      child: FadeInWidget(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          appBar: AppBar(
            systemOverlayStyle: theme.themeId == "WHITE"
                ? SystemUiOverlayStyle.dark
                : themeData.appBarTheme.systemOverlayStyle,
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 0, 14),
                child: AccountRequiredActionsIndicator(
                  widget.backupBloc,
                  widget.accountBloc,
                  widget.lspBloc,
                ),
              ),
            ],
            leading: _buildMenuIcon(context, user.appMode),
            iconTheme: IconThemeData(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            elevation: 0.0,
          ),
          drawerEnableOpenDragGesture: true,
          drawerDragStartBehavior: DragStartBehavior.down,
          drawerEdgeDragWidth: mediaSize.width,
          drawer: Theme(
            data: theme.themeMap[user.themeId],
            child: _navigationDrawer(
              context,
              user,
              account,
              settings,
              lspStatus,
              vendor,
              texts,
            ),
          ),
          bottomNavigationBar: user.appMode == AppMode.balance
              ? BottomActionsBar(account, firstPaymentItemKey)
              : null,
          floatingActionButton: user.appMode == AppMode.balance
              ? QrActionButton(account, firstPaymentItemKey)
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: _homePage(
            context,
            user,
          ),
        ),
      ),
    );
  }

  NavigationDrawer _navigationDrawer(
    BuildContext context,
    ClovrUserModel user,
    AccountModel account,
    AccountSettings settings,
    LSPStatus lspStatus,
    List<AddFundVendorModel> vendor,
    AppLocalizations texts,
  ) {
    return NavigationDrawer(
      true,
      [
        // Comment temporary
        // ..._drawerConfigRefundItems(
        //   context,
        //   user,
        //   account.swapFundsStatus.maturedRefundableAddresses,
        // ),
        ..._drawerConfigAppModeItems(context, user, texts),
        DrawerItemConfigGroup([_drawerItemPos(context, user, texts)]),
        DrawerItemConfigGroup(
          _filterItems(_drawerConfigToFilter(context, user, texts)),
          groupTitle: texts.home_drawer_item_title_preferences,
          groupAssetImage: "",
        ),
      ],
      _onNavigationItemSelected,
    );
  }

  List<DrawerItemConfig> _drawerConfigToFilter(
    BuildContext context,
    ClovrUserModel user,
    AppLocalizations texts,
  ) {
    return [
      DrawerItemConfig(
        "/fiat_currency",
        texts.home_drawer_item_title_fiat_currencies,
        "src/icon/fiat_currencies.png",
      ),
      DrawerItemConfig(
        "/network",
        texts.home_drawer_item_title_network,
        "src/icon/network.png",
      ),
      DrawerItemConfig(
        "",
        texts.home_drawer_item_title_security,
        "src/icon/security.png",
        onItemSelected: (_) => protectAdminRoute(context, user, "/security"),
      ),
      DrawerItemConfig(
        "",
        texts.home_drawer_item_title_payment_options,
        "src/icon/payment_options.png",
        onItemSelected: (_) => protectAdminRoute(
          context,
          user,
          "/payment_options",
        ),
      ),
      ..._drawerConfigAdvancedFlavorItems(context, user, texts),
    ];
  }

  List<DrawerItemConfigGroup> _drawerConfigRefundItems(
    BuildContext context,
    ClovrUserModel user,
    List<RefundableAddress> refundableAddresses,
  ) {
    if (refundableAddresses.length == 0) {
      return [];
    }
    final texts = AppLocalizations.of(context);
    return [
      DrawerItemConfigGroup(
        [
          DrawerItemConfig(
            "",
            texts.home_drawer_item_title_get_refund,
            "src/icon/withdraw_funds.png",
            onItemSelected: (_) => protectAdminRoute(
              context,
              user,
              "/get_refund",
            ),
          )
        ],
      ),
    ];
  }

  List<DrawerItemConfigGroup> _drawerConfigFlavorItems(
    BuildContext context,
    ClovrUserModel user,
    AppLocalizations texts,
  ) {
    switch (user.appMode) {
      case AppMode.pos:
        return [
          DrawerItemConfigGroup(
            [
              DrawerItemConfig(
                "/transactions",
                texts.home_drawer_item_title_transactions,
                "src/icon/transactions.png",
              ),
            ],
          ),
        ];

      default:
        return [];
    }
  }

  List<DrawerItemConfigGroup> _drawerConfigAppModeItems(
    BuildContext context,
    ClovrUserModel user,
    AppLocalizations texts,
  ) {
    return [
      DrawerItemConfigGroup([_drawerItemBalance(context, user, texts)]),
    ];
  }

  DrawerItemConfig _drawerItemBalance(
    BuildContext context,
    ClovrUserModel user,
    AppLocalizations texts,
  ) {
    return DrawerItemConfig(
      "",
      texts.home_drawer_item_title_balance,
      "src/icon/balance.png",
      isSelected: user.appMode == AppMode.balance,
      onItemSelected: (_) {
        protectAdminAction(
          context,
          user,
          () {
            widget.userProfileBloc.userActionsSink.add(
              SetAppMode(AppMode.balance),
            );
            return Future.value(null);
          },
        );
      },
    );
  }

  DrawerItemConfig _drawerItemPos(
    BuildContext context,
    ClovrUserModel user,
    AppLocalizations texts,
  ) {
    return DrawerItemConfig(
      "",
      texts.home_drawer_item_title_pos,
      "src/icon/pos.png",
      isSelected: user.appMode == AppMode.pos,
      onItemSelected: (_) {
        widget.userProfileBloc.userActionsSink.add(
          SetAppMode(AppMode.pos),
        );
      },
    );
  }

  DrawerItemConfig _drawerItemLightningApps(
    BuildContext context,
    ClovrUserModel user,
    AppLocalizations texts,
  ) {
    return DrawerItemConfig(
      "",
      texts.home_drawer_item_title_apps,
      "src/icon/apps.png",
      isSelected: user.appMode == AppMode.apps,
      onItemSelected: (_) {
        protectAdminAction(
          context,
          user,
          () {
            widget.userProfileBloc.userActionsSink
                .add(SetAppMode(AppMode.apps));
            return Future.value(null);
          },
        );
      },
    );
  }

  List<DrawerItemConfig> _drawerConfigAdvancedFlavorItems(
    BuildContext context,
    ClovrUserModel user,
    AppLocalizations texts,
  ) {
    if (user.appMode == AppMode.pos) {
      return [
        DrawerItemConfig(
          "",
          texts.home_drawer_item_title_pos_settings,
          "src/icon/settings.png",
          onItemSelected: (_) => protectAdminRoute(context, user, "/settings"),
        ),
      ];
    } else {
      return [
        DrawerItemConfig(
          "/developers",
          texts.home_drawer_item_title_developers,
          "src/icon/developers.png",
        ),
      ];
    }
  }

  IconButton _buildMenuIcon(BuildContext context, AppMode appMode) {
    final themeData = Theme.of(context);

    return IconButton(
      icon: Image.asset(
        _getAppModesAssetName(appMode),
        height: 24.0,
        width: 24.0,
        color: themeData.appBarTheme.actionsIconTheme.color,
      ),
      onPressed: () {
        _scaffoldKey.currentState.openDrawer();
      },
    );
  }

  String _getAppModesAssetName(AppMode appMode) {
    switch (appMode) {
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

  Widget _homePage(BuildContext context, ClovrUserModel user) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    switch (user.appMode) {
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
          builder: (_) => lostCard.LostCardDialog(),
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
    final texts = AppLocalizations.of(context);

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
          builder: (_) =>
              withClovrLabsWalletTheme(context, ConnectToPayPage(session)),
          settings: RouteSettings(name: "/connect_to_pay"),
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
    SyncUIHandler(widget.accountBloc, context);
    ShowPinHandler(widget.userProfileBloc, context);

    _accountNotificationsSubscription =
        widget.accountBloc.accountNotificationsStream.listen(
      (data) => showFlushbar(
        context,
        message: data,
      ),
      onError: (e) => showFlushbar(
        context,
        message: e.toString(),
      ),
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
    // Check app updating
    // checkVersionDialog(context, widget.userProfileBloc);
    CheckChannelConnection().startListen(context, widget.accountBloc);
  }

  void _listenBackupConflicts(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    widget.accountBloc.nodeConflictStream.listen((_) async {
      Navigator.popUntil(context, (route) {
        return route.settings.name == "/";
      });
      await promptError(
        context,
        texts.home_config_error_title,
        Text(
          texts.home_config_error_message,
          style: themeData.dialogTheme.contentTextStyle,
        ),
        okText: texts.home_config_error_action_exit,
        disableBack: true,
      );
    });
  }

  void _listenLSPSelectionPrompt(BuildContext context) async {
    widget.lspBloc.lspPromptStream.first
        .then((_) => Navigator.of(context).pushNamed("/select_lsp"));
  }

  void _listenWhitelistPermissionsRequest(BuildContext context) {
    final texts = AppLocalizations.of(context);
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
    final texts = AppLocalizations.of(context);

    widget.accountBloc.completedPaymentsStream.listen((fulfilledPayment) async {
      final paymentHash = fulfilledPayment.paymentHash;
      print('_listenPaymentResults processing: $paymentHash');

      if (!fulfilledPayment.cancelled &&
          !fulfilledPayment.ignoreGlobalFeedback) {
        await scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 10),
          curve: Curves.ease,
        );

        var action = fulfilledPayment?.paymentItem?.lnurlPayInfo?.successAction;
        if (action?.hasTag() == true) {
          await Future.delayed(Duration(seconds: 1));
          showLNURLSuccessAction(context, action);
        } else {
          showFlushbar(
            context,
            messageWidget: SingleChildScrollView(
              child: Text(texts.home_payment_sent),
            ),
          );
        }
      }
    }, onError: (err) async {
      var error = err as PaymentError;
      if (error.ignoreGlobalFeedback) {
        return;
      }
      final settings = await widget.accountBloc.accountSettingsStream.first;
      final behavior = settings.failedPaymentBehavior;
      bool prompt = behavior == BugReportBehavior.PROMPT;
      bool send = behavior == BugReportBehavior.SEND_REPORT;

      final accountModel = await widget.accountBloc.accountStream.first;
      final errorString = error.toDisplayMessage(accountModel.currency);
      showFlushbar(context, message: "$errorString");

      if (!error.validationError) {
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
          var sendAction = SendPaymentFailureReport(error.traceReport);
          widget.accountBloc.userActionsSink.add(sendAction);
          await Navigator.push(
            context,
            createLoaderRoute(
              context,
              message: texts.home_report_sending,
              opacity: 0.8,
              action: sendAction.future,
            ),
          );
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
