import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/widgets/circular_progress.dart';
import 'package:flutter/material.dart';

class SyncProgressDialog extends StatefulWidget {
  final bool closeOnSync;

  const SyncProgressDialog({Key key, this.closeOnSync = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SyncProgressDialogState();
  }
}

class SyncProgressDialogState extends State<SyncProgressDialog> {
  AccountBloc _accountBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_accountBloc == null && this.widget.closeOnSync) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      _accountBloc.accountStream
          .firstWhere((a) => a?.syncedToChain == true, orElse: () => null)
          .then((a) {
        if (this.mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (context, snapshot) {
        AccountModel acc = snapshot.data;
        if (acc == null) {
          return SizedBox();
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 150.0,
          child: CircularProgress(
              color: Theme.of(context).textTheme.button.color,
              size: 100.0,
              value: acc.syncProgress,
              title: "Synchronizing to the network"),
        );
      },
    );
  }
}
