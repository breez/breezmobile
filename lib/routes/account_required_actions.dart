import 'dart:async';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/routes/close_warning_dialog.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/widgets/enable_backup_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/rotator.dart';
import 'package:breez/widgets/route.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rxdart/rxdart.dart';

import 'backup_in_progress_dialog.dart';
import 'funds_over_limit_dialog.dart';
import 'lsp/select_lsp_page.dart';
import 'select_provider_error_dialog.dart';
import 'transfer_funds_in_progress_dialog.dart';

class AccountRequiredActionsIndicator extends StatefulWidget {
  final BackupBloc _backupBloc;
  final AccountBloc _accountBloc;
  final LSPBloc lspBloc;

  const AccountRequiredActionsIndicator(
    this._backupBloc,
    this._accountBloc,
    this.lspBloc,
  );

  @override
  AccountRequiredActionsIndicatorState createState() {
    return AccountRequiredActionsIndicatorState();
  }
}

class AccountRequiredActionsIndicatorState
    extends State<AccountRequiredActionsIndicator> {
  StreamSubscription<void> _promptEnableSubscription;
  StreamSubscription<BackupSettings> _settingsSubscription;
  BackupSettings _currentSettings;
  bool showingBackupDialog = false;
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_init) {
      _settingsSubscription = widget._backupBloc.backupSettingsStream
          .listen((settings) => _currentSettings = settings);

      _promptEnableSubscription = widget._backupBloc.promptBackupStream
          .delay(const Duration(seconds: 4))
          .listen((needSignIn) async {
        if (_currentSettings.promptOnError && !showingBackupDialog) {
          showingBackupDialog = true;
          widget._backupBloc.backupPromptVisibleSink.add(true);
          popFlushbars(context);
          showDialog(
              useRootNavigator: false,
              barrierDismissible: false,
              context: context,
              builder: (_) => EnableBackupDialog(
                    context,
                    widget._backupBloc,
                    signInNeeded: needSignIn,
                  )).then((_) {
            showingBackupDialog = false;
            widget._backupBloc.backupPromptVisibleSink.add(false);
          });
        }
      });
      _init = true;
    }
  }

  @override
  void dispose() {
    _promptEnableSubscription.cancel();
    _settingsSubscription.cancel();
    super.dispose();
  }

  Widget _buildLoader(BackupState backupState, AccountModel account) {
    Widget Function(BuildContext) dialogBuilder;

    if (backupState?.inProgress == true) {
      dialogBuilder = (_) => buildBackupInProgressDialog(
          context, widget._backupBloc.backupStateStream);
    } else if (account?.transferringOnChainDeposit == true) {
      dialogBuilder = (_) => buildTransferFundsInProgressDialog(
          context, widget._accountBloc.accountStream);
    }

    if (dialogBuilder != null) {
      return WarningAction(
        () {
          showDialog(context: context, builder: dialogBuilder);
        },
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
    return StreamBuilder<LSPStatus>(
      stream: widget.lspBloc.lspStatusStream,
      builder: (ctx, lspStatusSnapshot) {
        final lspStatus = lspStatusSnapshot.data;

        return StreamBuilder<AccountSettings>(
          stream: widget._accountBloc.accountSettingsStream,
          builder: (context, settingsSnapshot) {
            final accountSettings = settingsSnapshot.data;

            return StreamBuilder<AccountModel>(
              stream: widget._accountBloc.accountStream,
              builder: (context, accountSnapshot) {
                final accountModel = accountSnapshot.data;

                return StreamBuilder<List<PaymentInfo>>(
                  stream: widget._accountBloc.pendingChannelsStream,
                  builder: (ctx, pendingChannelsSnapshot) {
                    final pendingChannels = pendingChannelsSnapshot.data;

                    return StreamBuilder<LSPActivity>(
                      stream: widget._accountBloc.lspActivityStream,
                      builder: (context, lspActivitySnapshot) {
                        final lspActivity = lspActivitySnapshot.data;

                        return StreamBuilder<BackupSettings>(
                          stream: widget._backupBloc.backupSettingsStream,
                          builder: (context, backupSettingsSnapshot) {
                            final backupSettings = backupSettingsSnapshot.data;

                            return StreamBuilder<BackupState>(
                              stream: widget._backupBloc.backupStateStream,
                              builder: (context, backupSnapshot) {
                                final backup = backupSnapshot.data;
                                final hasError = backupSnapshot.hasError;
                                final backupError = backupSnapshot.error;

                                return _build(
                                  context,
                                  lspStatus,
                                  accountSettings,
                                  accountModel,
                                  pendingChannels,
                                  lspActivity,
                                  backupSettings,
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
      },
    );
  }

  Widget _build(
    BuildContext context,
    LSPStatus lspStatus,
    AccountSettings accountSettings,
    AccountModel accountModel,
    List<PaymentInfo> pendingChannels,
    LSPActivity lspActivity,
    BackupSettings backupSettings,
    BackupState backup,
    bool hasError,
    Object backupError,
  ) {
    final themeData = Theme.of(context);
    final navigatorState = Navigator.of(context);

    List<Widget> warnings = [];
    Int64 walletBalance = accountModel?.walletBalance ?? Int64(0);

    if (walletBalance > 0 && !accountSettings.ignoreWalletBalance) {
      warnings.add(
        WarningAction(() => navigatorState.pushNamed("/send_coins")),
      );
    }

    if (hasError) {
      bool signInNeeded = false;
      if (backupError.runtimeType == BackupFailedException) {
        signInNeeded =
            (backupError as BackupFailedException).authenticationError;
      }
      warnings.add(WarningAction(() async {
        showDialog(
          useRootNavigator: false,
          barrierDismissible: false,
          context: context,
          builder: (_) => EnableBackupDialog(
            context,
            widget._backupBloc,
            signInNeeded: signInNeeded,
          ),
        );
      }));
    }

    final availableLSPs = lspStatus?.availableLSPs ?? [];
    if (lspActivity != null) {
      int inactiveWarningDuration = _inactiveWarningDuration(
        availableLSPs,
        lspActivity.activity,
      );
      if (inactiveWarningDuration > 0) {
        warnings.add(WarningAction(() async {
          showDialog(
              useRootNavigator: false,
              barrierDismissible: false,
              context: context,
              builder: (_) => CloseWarningDialog(inactiveWarningDuration));
        }));
      }
    }

    final loaderIcon = _buildLoader(backup, accountModel);
    if (loaderIcon != null) {
      warnings.add(loaderIcon);
    }

    final swapStatus = accountModel?.swapFundsStatus;
    // only warn on refundable addresses that weren't refunded in the past.
    if (swapStatus != null && swapStatus.waitingRefundAddresses.isNotEmpty) {
      warnings.add(WarningAction(() => showDialog(
            useRootNavigator: false,
            barrierDismissible: false,
            context: context,
            builder: (_) => SwapRefundDialog(
              accountBloc: widget._accountBloc,
            ),
          )));
    }

    if (accountModel?.syncUIState == SyncUIState.COLLAPSED) {
      warnings.add(WarningAction(
        () => widget._accountBloc.userActionsSink.add(
          ChangeSyncUIState(SyncUIState.BLOCKING),
        ),
        iconWidget: Rotator(
            child: Image(
          image: const AssetImage("src/icon/sync.png"),
          color: themeData.appBarTheme.actionsIconTheme.color,
        )),
      ));
    }

    if (lspStatus?.selectionRequired == true) {
      warnings.add(WarningAction(() {
        if (lspStatus?.lastConnectionError != null) {
          showProviderErrorDialog(context, lspStatus?.lastConnectionError, () {
            navigatorState.push(FadeInRoute(
              builder: (_) => SelectLSPPage(lstBloc: widget.lspBloc),
            ));
          });
        } else {
          navigatorState.pushNamed("/select_lsp");
        }
      }));
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

  const WarningAction(
    this.onTap, {
    this.iconWidget,
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
    final texts = context.texts();

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
      tooltip: texts.account_required_actions_backup,
      onPressed: widget.onTap,
    );
  }
}
