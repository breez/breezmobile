import 'dart:typed_data';

import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/satscard/satscard_actions.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/routes/satscard_balance/satscard_balance_page.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter/material.dart';

class BroadcastTransactionPage extends StatefulWidget {
  final Function() onBack;
  final Function() onDone;
  final AddressInfo Function() getAddressInfo;
  final Uint8List Function() getPrivateKey;
  final RawSlotSweepTransaction Function() getTransaction;

  const BroadcastTransactionPage(
      {this.onBack, this.onDone, this.getAddressInfo, this.getPrivateKey, this.getTransaction});

  @override
  State<StatefulWidget> createState() => BroadcastTransactionPageState();
}

class BroadcastTransactionPageState extends State<BroadcastTransactionPage> {
  TransactionDetails _signedTransaction;
  String _recentError = "";

  void _setError(String errorMessage) {
    if (context.mounted) {
      setState(() => _recentError = errorMessage);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _requestSignTransaction();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Scaffold(
      appBar: AppBar(
        leading: backBtn.BackButton(
          onPressed: widget.onBack,
        ),
      ),
      body: _recentError.isNotEmpty
          ? buildErrorBody(themeData, _recentError)
          : buildLoaderBody(themeData, _getLoaderText(texts)),
    );
  }

  void _requestSignTransaction() {
    _setError("");

    final bloc = AppBlocsProvider.of<SatscardBloc>(context);
    final addressInfo = widget.getAddressInfo();
    final privateKey = widget.getPrivateKey();
    final transaction = widget.getTransaction();
    final action = SignSlotSweepTransaction(addressInfo, transaction, privateKey);
    bloc.actionsSink.add(action);
    action.future.then((response) {
      if (context.mounted) {
        setState(() => _signedTransaction = response as TransactionDetails);
      }
    }).catchError(
      (e) => _setError(
          context.texts().satscard_broadcast_error_signing(e.toString())),
    );
  }

  String _getLoaderText(BreezTranslations texts) {
    if (_signedTransaction == null) {
      return texts.satscard_broadcast_signing_label;
    }
    return texts.satscard_broadcast_broadcasting_label;
  }
}
