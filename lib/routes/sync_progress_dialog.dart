import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/circular_progress.dart';
import 'package:flutter/material.dart';

class SyncProgressDialog extends StatefulWidget {
  final bool closeOnSync;
  final Color progressColor;

  const SyncProgressDialog({
    Key key,
    this.closeOnSync = true,
    this.progressColor,
  }) : super(key: key);

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
          .firstWhere((a) => a?.syncedToChain == true && a.serverReady,
              orElse: () => null)
          .then((a) {
        if (this.mounted) {
          context.pop(true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;

    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (context, snapshot) {
        AccountModel acc = snapshot.data;
        if (acc == null) return SizedBox();

        return Container(
          width: context.mediaQuerySize.width,
          height: 150.0,
          child: CircularProgress(
            color: widget.progressColor ?? context.textTheme.button.color,
            size: 100.0,
            value: acc.serverReady ? acc.syncProgress : null,
            title: acc.serverReady
                ? l10n.sync_progress_server_ready
                : l10n.sync_progress_waiting_network,
          ),
        );
      },
    );
  }
}
