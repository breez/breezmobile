import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/add_funds/address_widget.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:flutter/material.dart';

class SlotBalancePage extends StatefulWidget {
  final Satscard _card;
  final Slot _slot;
  final Function() onBack;
  final Function() onSweep;

  const SlotBalancePage(this._card, this._slot, {this.onBack, this.onSweep});

  @override
  State<StatefulWidget> createState() => SlotBalancePageState();
}

class SlotBalancePageState extends State<SlotBalancePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccountModel>(
      stream: AppBlocsProvider.of<AccountBloc>(context).accountStream,
      builder: (context, snapshot) {
        final minFont = MinFontSize(context);
        final texts = context.texts();
        final themeData = Theme.of(context);

        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SingleButtonBottomBar(
              stickToBottom: true,
              text: texts.satscard_balance_button_label,
              onPressed: widget.onSweep,
            ),
          ),
          appBar: AppBar(
            leading: backBtn.BackButton(onPressed: widget.onBack),
            title: Text(texts.satscard_balance_title),
          ),
          body: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AddressWidget(
                    widget._slot.address,
                    isGeneric: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 25, 16, 10),
                    child: Column(
                      children: [
                        _buildTextTile(
                            context,
                            themeData,
                            minFont,
                            texts.satscard_balance_balance_label,
                            "TODO: Asynchronously get"), // TODO: Satscard
                        _buildTextTile(
                            context,
                            themeData,
                            minFont,
                            texts.satscard_balance_slot_label,
                            "${widget._card.activeSlotIndex + 1} / ${widget._card.numSlots}"),
                        _buildTextTile(
                            context,
                            themeData,
                            minFont,
                            texts.satscard_balance_version_label,
                            widget._card.appletVersion),
                        _buildTextTile(
                            context,
                            themeData,
                            minFont,
                            texts.satscard_balance_birth_height_label,
                            widget._card.birthHeight.toString()),
                        _buildTextTile(
                            context,
                            themeData,
                            minFont,
                            texts.satscard_balance_card_id_label,
                            widget._card.ident,
                            flushbarMessage: texts.satscard_card_id_copied),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ListTile _buildTextTile(BuildContext context, ThemeData themeData,
      MinFontSize minFont, String label, String trailingText,
      {String flushbarMessage}) {
    final style = theme.FieldTextStyle.labelStyle.copyWith(color: Colors.white);
    final trailing = AutoSizeText(
      trailingText,
      style: style,
      maxLines: 1,
      minFontSize: minFont.minFontSize,
      stepGranularity: 0.1,
    );
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      title: AutoSizeText(
        label,
        style: style,
        maxLines: 1,
        minFontSize: minFont.minFontSize,
        stepGranularity: 0.1,
      ),
      trailing: flushbarMessage == null
          ? trailing
          : GestureDetector(
              onTap: () {
                ServiceInjector().device.setClipboardText(trailingText);
                showFlushbar(context, message: flushbarMessage);
              },
              child: trailing,
            ),
    );
  }
}
