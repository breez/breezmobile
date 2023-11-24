import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:flutter/material.dart';

class SweepSlotPage extends StatefulWidget {
  final SatscardBloc _bloc;
  final Satscard _card;
  final Slot _slot;
  final Function() onBack;

  const SweepSlotPage(this._bloc, this._card, this._slot, {this.onBack});

  @override
  State<StatefulWidget> createState() => SweepSlotPageState();
}

class SweepSlotPageState extends State<SweepSlotPage> {
  @override
  Widget build(BuildContext context) {
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    final lspBloc = AppBlocsProvider.of<LSPBloc>(context);

    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (context, accSnapshot) => StreamBuilder<LSPStatus>(
          stream: lspBloc.lspStatusStream,
          builder: (context, lspSnapshot) {
            final texts = context.texts();

            return Scaffold(
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SingleButtonBottomBar(
                  stickToBottom: true,
                  text: texts.satscard_sweep_button_label,
                  onPressed: () {
                    // TODO: Add SweepSatscard action and open the NFC dialog
                  },
                ),
              ),
              appBar: AppBar(
                leading: backBtn.BackButton(onPressed: widget.onBack),
                title: Text(texts.satscard_sweep_title(widget._slot.index + 1)),
              ),
              body: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [SizedBox.shrink()],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
