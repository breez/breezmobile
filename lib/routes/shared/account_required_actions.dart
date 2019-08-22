import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/routes/shared/funds_over_limit_dialog.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/rotator.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:breez/widgets/enable_backup_dialog.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:breez/theme_data.dart' as theme;

import 'backup_in_progress_dialog.dart';
import 'transfer_funds_in_progress_dialog.dart';

class AccountRequiredActionsIndicator extends StatefulWidget {
  final BackupBloc _backupBloc;
  final AccountBloc _accountBloc;

  AccountRequiredActionsIndicator(this._backupBloc, this._accountBloc);

  @override
  AccountRequiredActionsIndicatorState createState() {
    return new AccountRequiredActionsIndicatorState();
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

      _promptEnableSubscription =
          Observable(widget._backupBloc.promptBackupStream)
              .delay(Duration(seconds: 4))
              .listen((_) {                
                if (_currentSettings.promptOnError && !showingBackupDialog) {
                  showingBackupDialog = true;
                  popFlushbars(context);                  
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (_) =>
                          new EnableBackupDialog(context, widget._backupBloc)).then((_) {
                    showingBackupDialog = false;
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

  Widget _buildLoader(BackupState backupState, AccountModel account){
    Widget Function(BuildContext) dialogBuilder;

    if (backupState?.inProgress == true) {
      dialogBuilder = (_) => buildBackupInProgressDialog(context, widget._backupBloc.backupStateStream);      
    } else if (account?.transferringOnChainDeposit == true) {
      dialogBuilder = (_) => buildTransferFundsInProgressDialog(context, widget._accountBloc.accountStream);      
    }

    if (dialogBuilder != null) {
      return WarningAction(
        (){
          showDialog(
            context: context,                              
            builder: dialogBuilder
          );
        },
        iconWidget: Rotator(child: Image(image: AssetImage("src/icon/sync.png"), color: Color.fromRGBO(0, 120, 253, 1.0))),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccountSettings>(
        stream: widget._accountBloc.accountSettingsStream,
        builder: (context, settingsSnapshot) {
          return StreamBuilder<AccountModel>(
              stream: widget._accountBloc.accountStream,
              builder: (context, accountSnapshot) {
                return StreamBuilder<BackupState>(
                    stream: widget._backupBloc.backupStateStream,
                    builder: (context, backupSnapshot) {
                      List<Widget> warnings = List<Widget>();
                      Int64 walletBalance =
                          accountSnapshot?.data?.walletBalance ?? Int64(0);
                      if (walletBalance > 0 &&
                          !settingsSnapshot.data.ignoreWalletBalance) {
                        warnings.add(WarningAction(() =>
                            Navigator.of(context).pushNamed("/send_coins")));
                      }

                      if (backupSnapshot.hasError) {
                        warnings.add(WarningAction(() => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => new EnableBackupDialog(
                                context, widget._backupBloc))));
                      }

                      var loaderIcon = _buildLoader(backupSnapshot.data, accountSnapshot.data);
                      if (loaderIcon != null) {
                        warnings.add(loaderIcon);
                      }

                      var swapStatus = accountSnapshot?.data?.swapFundsStatus;

                      // only warn on refundable addresses that weren't refunded in the past.
                      var shouldWarnRefund = swapStatus != null &&
                        swapStatus.refundableAddresses.where((r) => r.lastRefundTxID.isEmpty).length > 0;

                      if (shouldWarnRefund) {  
                        warnings.add(WarningAction(() => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => new SwapRefundDialog(accountBloc: widget._accountBloc))));
                      }

                      if (accountSnapshot?.data?.syncUIState == SyncUIState.COLLAPSED) {
                        warnings.add(WarningAction(
                          () => widget._accountBloc.userActionsSink.add(ChangeSyncUIState(SyncUIState.BLOCKING)),
                          iconWidget: Rotator(child: Image(image: AssetImage("src/icon/sync.png"), color: Color.fromRGBO(0, 120, 253, 1.0))),
                        ));
                      }

                      if (warnings.length == 0) {
                        return SizedBox();
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: warnings                           
                      );
                    });
              });
        });
  }
}

class WarningAction extends StatefulWidget {
  final void Function() onTap;
  final Widget iconWidget;

  WarningAction(this.onTap, {this.iconWidget});

  @override
  State<StatefulWidget> createState() {    
    return WarningActionState();
  }
}

class WarningActionState extends State<WarningAction> with SingleTickerProviderStateMixin {  

  Animation<double> _animation;
  AnimationController _animationController;

  @override 
  void initState() {  
    super.initState();
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        _animationController); //use Tween animation here, to animate between the values of 1.0 & 2.5.
    _animation.addListener(() {
      //here, a listener that rebuilds our widget tree when animation.value chnages
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
    return IconButton(
      iconSize: 45.0,
      padding: EdgeInsets.zero,
      icon: Container(
        width: 45 * _animation.value,
        child: widget.iconWidget ??  new Image(          
          image: new AssetImage("src/icon/warning.png"),
          color: Color.fromRGBO(0, 120, 253, 1.0),
        ),
      ),
      tooltip: 'Backup',
      onPressed: this.widget.onTap,
    );
  }
}
