import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:breez/widgets/enable_backup_dialog.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:rxdart/rxdart.dart';

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
              .delay(Duration(seconds: 1))
              .listen((_) {                
                if (_currentSettings.promptOnError && !showingBackupDialog) {
                  showingBackupDialog = true;
                  popFlushbars(context);                  
                  showDialog(
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccountSettings>(
        stream: widget._accountBloc.accountSettingsStream,
        builder: (context, settingsSnapshot) {
          return StreamBuilder<AccountModel>(
              stream: widget._accountBloc.accountStream,
              builder: (context, accountSnapshot) {
                return StreamBuilder<DateTime>(
                    stream: widget._backupBloc.lastBackupTimeStream,
                    builder: (context, backupSnapshot) {
                      List<void Function()> warnings = List<void Function()>();
                      Int64 walletBalance =
                          accountSnapshot?.data?.walletBalance ?? Int64(0);
                      if (walletBalance > 0 &&
                          !settingsSnapshot.data.ignoreWalletBalance) {
                        warnings.add(() =>
                            Navigator.of(context).pushNamed("/send_coins"));
                      }

                      if (backupSnapshot.hasError) {
                        warnings.add(() => showDialog(
                            context: context,
                            builder: (_) => new EnableBackupDialog(
                                context, widget._backupBloc)));
                      }

                      if (warnings.length == 0) {
                        return SizedBox();
                      }

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: warnings
                            .map((onTap) => WarningAction(onTap))
                            .toList(),
                      );
                    });
              });
        });
  }
}

class WarningAction extends StatelessWidget {
  final void Function() onTap;

  WarningAction(this.onTap);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: new Image(
        image: new AssetImage("src/icon/warning.png"),
        color: Color.fromRGBO(0, 120, 253, 1.0),
      ),
      tooltip: 'Backup',
      onPressed: this.onTap,
    );
  }
}
