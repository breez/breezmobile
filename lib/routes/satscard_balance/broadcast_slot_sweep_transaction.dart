import 'dart:typed_data';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/satscard/satscard_actions.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/routes/satscard_balance/satscard_balance_page.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/link_launcher.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter/material.dart';

class BroadcastSlotSweepTransactionPage extends StatefulWidget {
  final Function() onBack;
  final Function() onDone;
  final AddressInfo Function() getAddressInfo;
  final Uint8List Function() getPrivateKey;
  final RawSlotSweepTransaction Function() getTransaction;

  const BroadcastSlotSweepTransactionPage(
      {@required this.onBack,
      @required this.onDone,
      @required this.getAddressInfo,
      @required this.getPrivateKey,
      @required this.getTransaction});

  @override
  State<StatefulWidget> createState() =>
      BroadcastSlotSweepTransactionPageState();
}

class BroadcastSlotSweepTransactionPageState
    extends State<BroadcastSlotSweepTransactionPage> {
  TransactionDetails _signedTransaction;
  Future<void> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _broadcastTransaction(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          final themeData = Theme.of(context);
          final texts = context.texts();
          final showError = snapshot.hasError;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                texts.satscard_broadcast_title,
                style: themeData.appBarTheme.titleTextStyle,
              ),
              leading: backBtn.BackButton(
                onPressed: widget.onBack,
              ),
            ),
            bottomNavigationBar:
                !snapshot.hasError || _signedTransaction == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SingleButtonBottomBar(
                          stickToBottom: true,
                          text: texts.satscard_balance_button_retry_label,
                          onPressed: () => _broadcastTransaction(context),
                        ),
                      ),
            body: showError
                ? buildErrorBody(
                    themeData, _getErrorText(texts, snapshot.error))
                : buildLoaderBody(themeData, _getLoaderText(texts)),
          );
        });
  }

  String _getErrorText(BreezTranslations texts, Object error) {
    return _signedTransaction == null
        ? texts.satscard_broadcast_error_signing(error)
        : texts.satscard_broadcast_error_broadcasting(error);
  }

  String _getLoaderText(BreezTranslations texts) {
    return _signedTransaction == null
        ? texts.satscard_broadcast_signing_label
        : texts.satscard_broadcast_broadcasting_label;
  }

  void _broadcastTransaction(BuildContext context) {
    if (!context.mounted) {
      return;
    }
    setState(() {
      _future = Future.sync(() {
        // Sign the selected transaction if we haven't already
        if (_signedTransaction == null) {
          final satscardBloc = AppBlocsProvider.of<SatscardBloc>(context);
          final info = widget.getAddressInfo();
          final tx = widget.getTransaction();
          final key = widget.getPrivateKey();
          final action = SignSlotSweepTransaction(info, tx, key);
          satscardBloc.actionsSink.add(action);
          return action.future.then((result) {
            if (context.mounted) {
              setState(() {
                _signedTransaction = result as TransactionDetails;
              });
            }
          });
        }
      }).then((_) {
        final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
        final action = PublishTransaction(_signedTransaction.tx);
        accountBloc.userActionsSink.add(action);
        return action.future;
      }).then((_) {
        if (context.mounted) {
          final texts = context.texts();
          final tx = _signedTransaction;

          widget.onDone();
          promptMessage(
            context,
            texts.satscard_broadcast_complete_title,
            Builder(
              builder: (context) => LinkLauncher(
                linkName: tx.txHash,
                linkAddress: "https://blockstream.info/tx/${tx.txHash}",
                onCopy: () {
                  ServiceInjector().device.setClipboardText(tx.txHash);
                  showFlushbar(
                    context,
                    message: texts.add_funds_transaction_id_copied,
                    duration: const Duration(seconds: 3),
                  );
                },
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
          );
        }
      });
    });
  }
}
