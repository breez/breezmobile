import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:flutter/material.dart';

class SatscardsBalancePage extends StatelessWidget {
  final Satscard _card;
  final Slot _slot;

  const SatscardsBalancePage(this._card, this._slot);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Scaffold(
      bottomNavigationBar: SingleButtonBottomBar(
        stickToBottom: true,
        text: texts.satscard_balance_button_label,
        onPressed: () {
          // TODO: Navigate to sweep page
        },
      ),
      appBar: AppBar(
        leading: const backBtn.BackButton(),
        title: Text(texts.satscard_balance_title(_slot.index + 1)),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
