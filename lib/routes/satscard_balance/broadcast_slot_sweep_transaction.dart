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
  Future<String> _future;

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
          final showDone = !showError && snapshot.hasData;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                texts.satscard_broadcast_title,
                style: themeData.appBarTheme.titleTextStyle,
              ),
              leading: backBtn.BackButton(
                onPressed: showDone ? widget.onDone : widget.onBack,
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
            body: _buildBody(themeData, texts, snapshot, showError, showDone),
          );
        });
  }

  Widget _buildBody(
    ThemeData themeData,
    BreezTranslations texts,
    AsyncSnapshot<String> snapshot,
    bool showError,
    bool showDone,
  ) {
    if (showError) {
      return buildErrorBody(themeData, _getErrorText(texts, snapshot.error));
    } else if (!showDone) {
      return buildLoaderBody(themeData, _getLoaderText(texts));
    }

    final txId = snapshot.data;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinkLauncher(
            linkName: txId,
            linkAddress: "https://blockstream.info/tx/$txId",
            onCopy: () {
              ServiceInjector().device.setClipboardText(txId);
              showFlushbar(
                context,
                message: texts.add_funds_transaction_id_copied,
                duration: const Duration(seconds: 3),
              );
            },
          ),
        ],
      ),
    );
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
        // Close the page automatically after a successful broadcast
        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            widget.onDone();
          }
        });
        return _signedTransaction.txHash;
      });
    });
  }
}
