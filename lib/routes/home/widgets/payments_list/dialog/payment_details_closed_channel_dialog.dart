import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/closed_channel_payment_details.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogClosedChannelDialog extends StatelessWidget {
  final PaymentInfo paymentInfo;

  const PaymentDetailsDialogClosedChannelDialog({
    Key key,
    this.paymentInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final lspBloc = AppBlocsProvider.of<LSPBloc>(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
      title: Text(
        paymentInfo.pending
            ? texts.payment_details_dialog_closed_channel_title_pending
            : texts.payment_details_dialog_closed_channel_title,
        style: themeData.dialogTheme.titleTextStyle,
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: StreamBuilder<LSPStatus>(
        stream: lspBloc.lspStatusStream,
        builder: (context, snapshot) {
          return ClosedChannelPaymentDetails(
            accountBloc: accountBloc,
            lsp: snapshot.data,
            closedChannel: paymentInfo,
          );
        },
      ),
      actions: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: Text(
            texts.payment_details_dialog_closed_channel_ok,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
