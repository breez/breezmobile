import 'package:auto_size_text/auto_size_text.dart';
import 'package:clovrlabs_wallet/bloc/account/account_actions.dart';
import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/widgets/loader.dart';
import 'package:clovrlabs_wallet/widgets/payment_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PendingClosedChannelDialog extends StatefulWidget {
  final AccountBloc accountBloc;

  const PendingClosedChannelDialog({
    Key key,
    this.accountBloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PendingClosedChannelDialogState();
  }
}

class PendingClosedChannelDialogState
    extends State<PendingClosedChannelDialog> {
  Future _fetchFuture;

  @override
  void initState() {
    super.initState();
    var fetchAction = FetchPayments();
    _fetchFuture = fetchAction.future;
    widget.accountBloc.userActionsSink.add(fetchAction);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 16.0),
      title: AutoSizeText(
        texts.pending_closed_channel_title,
        style: themeData.dialogTheme.titleTextStyle,
        maxLines: 1,
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: FutureBuilder(
        future: this._fetchFuture,
        initialData: null,
        builder: (ctx, loadingSnapshot) {
          if (loadingSnapshot.connectionState != ConnectionState.done) {
            return Loader();
          }

          return StreamBuilder<List<PaymentInfo>>(
            stream: widget.accountBloc.pendingChannelsStream,
            builder: (ctx, snapshot) {
              final pendingClosedChannels = snapshot?.data;
              if (pendingClosedChannels == null ||
                  pendingClosedChannels.length == 0) {
                return Loader();
              }

              return ClosedChannelPaymentDetails(
                closedChannel: pendingClosedChannels[0],
              );
            },
          );
        },
      ),
      actions: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: Text(
            texts.pending_closed_channel_action_ok,
            style: themeData.primaryTextTheme.button,
          ),
        )
      ],
    );
  }
}
