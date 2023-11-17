import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/satscard/chain_code_field.dart';
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

  final Satscard _card;
  final String _activeSlot;

  InitializeSatscardPage(this._card)
      : _activeSlot = (_card.activeSlotIndex + 1).toString();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: Platform.isIOS &&
                    (_spendCodeFocusNode.hasFocus ||
                        _chainCodeFocusNode.hasFocus)
                ? 40.0
                : 0.0,
          ),
          child: SingleButtonBottomBar(
            stickToBottom: true,
            text: texts.satscard_initialize_button_label,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                final navigator = Navigator.of(context);
                var loaderRoute = createLoaderRoute(
                  context,
                  message: "Test message",
                );
                navigator.push(loaderRoute);
              }
            },
          )),
      appBar: AppBar(
        leading: const backBtn.BackButton(),
        title: Text(texts.satscard_initialize_title(_activeSlot)),
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
                  ),
                  ChainCodeFormField(
                    context: context,
                    texts: texts,
                    focusNode: _chainCodeFocusNode,
                    controller: _chainCodeController,
                    style: theme.FieldTextStyle.textStyle,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: AutoSizeText(
                      texts.satscard_card_id_text(_card.ident),
                      style: theme.textStyle,
                      maxLines: 1,
                      minFontSize: MinFontSize(context).minFontSize,
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
