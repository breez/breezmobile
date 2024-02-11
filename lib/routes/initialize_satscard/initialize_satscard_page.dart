import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/satscard/satscard_actions.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/bloc/satscard/satscard_op_status.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/satscard/chain_code_field.dart';
import 'package:breez/widgets/satscard/satscard_operation_dialog.dart';
import 'package:breez/widgets/satscard/spend_code_field.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:flutter/material.dart';

class InitializeSatscardPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _spendCodeController = TextEditingController();
  final _chainCodeController = TextEditingController();
  final _spendCodeFocusNode = FocusNode();
  final _chainCodeFocusNode = FocusNode();
  final _incorrectCodes =
      HashSet<String>(equals: (a, b) => a == b, hashCode: (a) => a.hashCode);

  final Satscard _card;
  final String _activeSlot;

  InitializeSatscardPage(this._card)
      : _activeSlot = (_card.activeSlotIndex + 1).toString();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const backBtn.BackButton(),
        title: Text(texts.satscard_initialize_title(_activeSlot)),
      ),
      bottomNavigationBar: SingleButtonBottomBar(
        stickToBottom: true,
        text: texts.satscard_initialize_button_label,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            final bloc = AppBlocsProvider.of<SatscardBloc>(context);
            final action = InitializeSlot(
                _card, _spendCodeController.text, _chainCodeController.text);
            bloc.actionsSink.add(action);

            showSatscardOperationDialog(context, bloc, _card.ident)
                .then((result) {
              if (result is SatscardOpStatusBadAuth) {
                _incorrectCodes.add(action.spendCode);
                _formKey.currentState.validate();
              } else if (result is SatscardOpStatusSuccess) {
                Navigator.of(context).pushReplacementNamed("/satscard_balance",
                    result: false,
                    arguments: {
                      "card": result.card,
                      "slot": result.slot
                    }).then((_) => bloc.actionsSink.add(EnableListening()));
              }
            });
          }
        },
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpendCodeFormField(
                      context: context,
                      texts: texts,
                      focusNode: _spendCodeFocusNode,
                      controller: _spendCodeController,
                      style: theme.FieldTextStyle.textStyle,
                      validatorFn: (code) => _incorrectCodes.contains(code)
                          ? texts.satscard_spend_code_incorrect_code_hint
                          : null),
                  ChainCodeFormField(
                    context: context,
                    texts: texts,
                    focusNode: _chainCodeFocusNode,
                    controller: _chainCodeController,
                    style: theme.FieldTextStyle.textStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        ServiceInjector().device.setClipboardText(_card.ident);
                        showFlushbar(context,
                            message: texts.satscard_card_id_copied);
                      },
                      child: AutoSizeText(
                        texts.satscard_card_id_text(_card.ident),
                        style: theme.textStyle,
                        maxLines: 1,
                        minFontSize: MinFontSize(context).minFontSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
