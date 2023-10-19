import 'dart:async';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/backup_in_progress_dialog.dart';
import 'package:breez/routes/close_warning_dialog.dart';
import 'package:breez/routes/funds_over_limit_dialog.dart';
import 'package:breez/routes/lsp/select_lsp_page.dart';
import 'package:breez/routes/select_provider_error_dialog.dart';
import 'package:breez/routes/transfer_funds_in_progress_dialog.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/widgets/enable_backup_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/rotator.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rxdart/rxdart.dart';

class AccountRequiredActionsIndicator extends StatefulWidget {
  @override
  AccountRequiredActionsIndicatorState createState() {
    return AccountRequiredActionsIndicatorState();
  }
}

class AccountRequiredActionsIndicatorState
    extends State<AccountRequiredActionsIndicator> {
  StreamSubscription<dynamic> _promptBackupSubscription;
  bool showingBackupDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initListeners();
    });
  }

  void _initListeners() {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);

    _promptBackupSubscription?.cancel();
    _promptBackupSubscription = backupBloc.promptBackupSubscription
        .delay(const Duration(seconds: 4))
        .listen((signInNeeded) => _promptBackup(signInNeeded));
  }

  void _promptBackup(bool signInNeeded) async {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    log.info("prompt backup: {signInNeeded: $signInNeeded }");
    if (signInNeeded) {
      backupBloc.backupPromptVisibleSink.add(true);
      popFlushbars(context);
      showDialog(
        useRootNavigator: false,
        barrierDismissible: false,
        context: context,
        builder: (_) => const EnableBackupDialog(),
      ).then((_) {
        backupBloc.promptBackupDismissedSink.add(true);
        backupBloc.backupPromptVisibleSink.add(false);
      });
    }
  }

  @override
  void dispose() {
    _promptBackupSubscription?.cancel();
    super.dispose();
  }

  Widget _buildLoader(BackupState backupState, AccountModel account) {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    final texts = context.texts();

    Widget Function(BuildContext) dialogBuilder;
    String tooltip = "";

    if (backupState?.inProgress == true) {
      dialogBuilder = (_) => buildBackupInProgressDialog(
            context,
            backupBloc.backupStateStream,
            onFinished: () {},
          );
      tooltip = texts.account_required_actions_backup;
    } else if (account?.transferringOnChainDeposit == true) {
      dialogBuilder = (_) => buildTransferFundsInProgressDialog(
            context,
            accountBloc.accountStream,
          );
      tooltip = texts.transferring_funds_title;
    }

    if (dialogBuilder != null) {
      return WarningAction(
        () {
          showDialog(context: context, builder: dialogBuilder);
        },
        tooltip: tooltip,
        iconWidget: Rotator(
          child: Image(
            image: const AssetImage("src/icon/sync.png"),
            color: Theme.of(context).appBarTheme.actionsIconTheme.color,
          ),
        ),
      );
    }

    return null;
  }

  int _inactiveWarningDuration(
    List<LSPInfo> lspList,
    Map<String, Int64> activity,
  ) {
    int warningDuration = 0;
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    for (var l in lspList) {
      if (activity.containsKey(l.lspID) &&
          ((currentTimestamp - activity[l.lspID].toInt()) >
              4 * (l.maxInactiveDuration ~/ 5))) {
        if ((warningDuration == 0) ||
            (warningDuration >
                (currentTimestamp - activity[l.lspID].toInt()))) {
          warningDuration = (currentTimestamp - activity[l.lspID].toInt());
        }
      }
    }
    return warningDuration;
  }

  @override
  Widget build(BuildContext context) {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    final lspBloc = AppBlocsProvider.of<LSPBloc>(context);

    return StreamBuilder<LSPStatus>(
      stream: lspBloc.lspStatusStream,
      builder: (ctx, lspStatusSnapshot) {
        final lspStatus = lspStatusSnapshot.data;

        return StreamBuilder<AccountSettings>(
          stream: accountBloc.accountSettingsStream,
          builder: (context, settingsSnapshot) {
            final accountSettings = settingsSnapshot.data;

            return StreamBuilder<AccountModel>(
              stream: accountBloc.accountStream,
              builder: (context, accountSnapshot) {
                final accountModel = accountSnapshot.data;

                return StreamBuilder<List<PaymentInfo>>(
                  stream: accountBloc.pendingChannelsStream,
                  builder: (ctx, pendingChannelsSnapshot) {
                    final pendingChannels = pendingChannelsSnapshot.data;

                    return StreamBuilder<LSPActivity>(
                      stream: accountBloc.lspActivityStream,
                      builder: (context, lspActivitySnapshot) {
                        final lspActivity = lspActivitySnapshot.data;

                        return StreamBuilder<BackupState>(
                          stream: backupBloc.backupStateStream,
                          builder: (context, backupSnapshot) {
                            final backup = backupSnapshot.data;
                            final hasError = backupSnapshot.hasError;
                            final backupError = backupSnapshot.error;

                            return _build(
                              lspStatus,
                              accountSettings,
                              accountModel,
                              pendingChannels,
                              lspActivity,
                              backup,
                              hasError,
                              backupError,
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
    );
  }

  Widget _build(
    LSPStatus lspStatus,
    AccountSettings accountSettings,
    AccountModel accountModel,
    List<PaymentInfo> pendingChannels,
    LSPActivity lspActivity,
    BackupState backup,
    bool hasError,
    Object backupError,
  ) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final navigatorState = Navigator.of(context);

    List<Widget> warnings = [];
    Int64 walletBalance = accountModel?.walletBalance ?? Int64(0);

    if (walletBalance > 0 && !accountSettings.ignoreWalletBalance) {
      warnings.add(
        WarningAction(
          () => navigatorState.pushNamed("/send_coins"),
          tooltip: texts.unexpected_funds_title,
        ),
      );
    }

    if (hasError) {
      warnings.add(
        WarningAction(
          () async {
            showDialog(
              useRootNavigator: false,
              barrierDismissible: false,
              context: context,
              builder: (_) => const EnableBackupDialog(),
            );
          },
          tooltip: texts.account_required_actions_backup,
        ),
      );
    }

    final availableLSPs = lspStatus?.availableLSPs ?? [];
    if (lspActivity != null) {
      int inactiveWarningDuration = _inactiveWarningDuration(
        availableLSPs,
        lspActivity.activity,
      );
      if (inactiveWarningDuration > 0) {
        warnings.add(
          WarningAction(
            () async {
              showDialog(
                useRootNavigator: false,
                barrierDismissible: false,
                context: context,
                builder: (_) => CloseWarningDialog(inactiveWarningDuration),
              );
            },
            tooltip: texts.close_warning_dialog_title,
          ),
        );
      }
    }

    final loaderIcon = _buildLoader(backup, accountModel);
    if (loaderIcon != null) {
      warnings.add(loaderIcon);
    }

    final swapStatus = accountModel?.swapFundsStatus;
    // only warn on refundable addresses that weren't refunded in the past.
    if (swapStatus != null && swapStatus.waitingRefundAddresses.isNotEmpty) {
      warnings.add(
        WarningAction(
          () async {
            showDialog(
              useRootNavigator: false,
              barrierDismissible: false,
              context: context,
              builder: (_) => const SwapRefundDialog(),
            );
          },
          tooltip: texts.funds_over_limit_dialog_on_chain_transaction,
        ),
      );
    }

    if (accountModel?.syncUIState == SyncUIState.COLLAPSED) {
      final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      warnings.add(
        WarningAction(
          () => accountBloc.userActionsSink.add(
            ChangeSyncUIState(SyncUIState.BLOCKING),
          ),
          tooltip: texts.handler_sync_ui_message,
          iconWidget: Rotator(
            child: Image(
              image: const AssetImage("src/icon/sync.png"),
              color: themeData.appBarTheme.actionsIconTheme.color,
            ),
          ),
        ),
      );
    }

    if (lspStatus?.selectionRequired == true) {
      warnings.add(
        WarningAction(
          () {
            if (lspStatus?.lastConnectionError != null) {
              showProviderErrorDialog(context, lspStatus?.lastConnectionError,
                  () {
                navigatorState.push(
                  FadeInRoute(
                    builder: (_) => const SelectLSPPage(),
                  ),
                );
              });
            } else {
              navigatorState.pushNamed("/select_lsp");
            }
          },
          tooltip: texts.account_page_activation_provider_label,
        ),
      );
    }

    if (warnings.isEmpty) {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: warnings,
    );
  }
}

class WarningAction extends StatefulWidget {
  final void Function() onTap;
  final Widget iconWidget;
  final String tooltip;

  const WarningAction(
    this.onTap, {
    this.iconWidget,
    this.tooltip = "",
  });

  @override
  State<StatefulWidget> createState() {
    return WarningActionState();
  }
}

class WarningActionState extends State<WarningAction>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    //use Tween animation here, to animate between the values of 1.0 & 2.5.
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _animation.addListener(() {
      //here, a listener that rebuilds our widget tree when animation.value changes
      setState(() {});
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return IconButton(
      iconSize: 45.0,
      padding: EdgeInsets.zero,
      icon: SizedBox(
        width: 45 * _animation.value,
        child: widget.iconWidget ??
            SvgPicture.asset(
              "src/icon/warning.svg",
              colorFilter: ColorFilter.mode(
                themeData.appBarTheme.actionsIconTheme.color,
                BlendMode.srcATop,
              ),
            ),
      ),
      tooltip: widget.tooltip,
      onPressed: widget.onTap,
    );
  }
}
