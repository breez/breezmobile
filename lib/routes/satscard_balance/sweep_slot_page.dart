import 'dart:collection';
import 'dart:io';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/satscard/spend_code_field.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:flutter/material.dart';

class SweepSlotPage extends StatefulWidget {
  final SatscardBloc _bloc;
  final Satscard _card;
  final Slot _slot;
  final Function() onBack;
  final AddressBalance Function() getBalance;

  AddressBalance _balance;
  set balance(AddressBalance balance) {
    _balance = balance;
  }

  SweepSlotPage(this._bloc, this._card, this._slot,
      {this.onBack, this.getBalance});

  @override
  State<StatefulWidget> createState() => SweepSlotPageState();
}

class SweepSlotPageState extends State<SweepSlotPage> {
  final _formKey = GlobalKey<FormState>();
  final _spendCodeController = TextEditingController();
  final _spendCodeFocusNode = FocusNode();
  final _incorrectCodes =
      HashSet<String>(equals: (a, b) => a == b, hashCode: (a) => a.hashCode);

  @override
  Widget build(BuildContext context) {
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    final lspBloc = AppBlocsProvider.of<LSPBloc>(context);
    final balance = widget.getBalance();

    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (context, accSnapshot) => StreamBuilder<LSPStatus>(
          stream: lspBloc.lspStatusStream,
          builder: (context, lspSnapshot) {
            final texts = context.texts();

            return Scaffold(
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(
                  bottom: Platform.isIOS && _spendCodeFocusNode.hasFocus
                      ? 40.0
                      : 0.0,
                ),
                child: SingleButtonBottomBar(
                  stickToBottom: true,
                  text: texts.satscard_sweep_button_label,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // TODO: Add SweepSatscard action and open the NFC dialog
                    }
                  },
                ),
              ),
              appBar: AppBar(
                leading: backBtn.BackButton(
                  onPressed: () {
                    if (_spendCodeFocusNode.hasFocus) {
                      _spendCodeFocusNode.unfocus();
                    }
                    widget.onBack();
                  },
                ),
                title: Text(texts.satscard_sweep_title(widget._slot.index + 1)),
              ),
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SpendCodeFormField(
                              context: context,
                              texts: texts,
                              focusNode: _spendCodeFocusNode,
                              controller: _spendCodeController,
                              style: theme.FieldTextStyle.textStyle,
                              validatorFn: (code) => _incorrectCodes
                                      .contains(code)
                                  ? texts
                                      .satscard_spend_code_incorrect_code_hint
                                  : null),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
