import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/closed_channel_payment_details.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

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
    final texts = context.texts();

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 24.0, 16.0),
      title: AutoSizeText(
        texts.pending_closed_channel_title,
        style: themeData.dialogTheme.titleTextStyle,
        maxLines: 1,
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: FutureBuilder(
        future: _fetchFuture,
        initialData: null,
        builder: (ctx, loadingSnapshot) {
          if (loadingSnapshot.connectionState != ConnectionState.done) {
            return const Loader();
          }

          return StreamBuilder<List<PaymentInfo>>(
            stream: widget.accountBloc.pendingChannelsStream,
            builder: (ctx, snapshot) {
              final pendingClosedChannels = snapshot?.data;
              if (pendingClosedChannels == null ||
                  pendingClosedChannels.isEmpty) {
                return const Loader();
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
            style: themeData.primaryTextTheme.labelLarge,
          ),
        )
      ],
    );
  }
}
