import 'dart:typed_data';

import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/routes/satscard_balance/satscard_balance_page.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class BroadcastTransactionPage extends StatefulWidget {
  final Function() onBack;
  final Function() onDone;
  final Uint8List Function() getPrivateKey;
  final UnsignedTransaction Function() getTransaction;

  const BroadcastTransactionPage(
      {this.onBack, this.onDone, this.getTransaction, this.getPrivateKey});

  @override
  State<StatefulWidget> createState() => BroadcastTransactionPageState();
}

class BroadcastTransactionPageState extends State<BroadcastTransactionPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // TODO: Sign and broadcast transaction
    final bloc = AppBlocsProvider.of<SatscardBloc>(context);
    final transaction = widget.getTransaction();
    final privateKey = widget.getPrivateKey();
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
        body:
            buildLoaderBody(themeData, "Signing and broadcasting transaction"));
  }
}
