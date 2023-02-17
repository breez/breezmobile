import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/widgets/circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

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
    if (_accountBloc == null && widget.closeOnSync) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      _accountBloc.accountStream
          .firstWhere((a) => a?.syncedToChain == true && a.serverReady,
              orElse: () => null)
          .then((a) {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (context, snapshot) {
        AccountModel acc = snapshot.data;
        if (acc == null) return const SizedBox();

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 150.0,
          child: CircularProgress(
            color: widget.progressColor ?? themeData.textTheme.labelLarge.color,
            size: 100.0,
            value: acc.serverReady ? acc.syncProgress : null,
            title: acc.serverReady
                ? texts.sync_progress_server_ready
                : texts.sync_progress_waiting_network,
          ),
        );
      },
    );
  }
}
