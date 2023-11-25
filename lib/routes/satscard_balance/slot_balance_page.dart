import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/satscard/satscard_actions.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/routes/add_funds/address_widget.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/circular_progress.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class SlotBalancePage extends StatefulWidget {
  final SatscardBloc _bloc;
  final Satscard _card;
  final Slot _slot;
  final Function() onBack;
  final Function(AddressBalance) onSweep;

  const SlotBalancePage(this._bloc, this._card, this._slot,
      {this.onBack, this.onSweep});

  @override
  State<StatefulWidget> createState() => SlotBalancePageState();
}

class SlotBalancePageState extends State<SlotBalancePage> {
  AddressBalance _balance;

  @override
  void initState() {
    super.initState();
    final action = GetAddressBalance(widget._slot.address);
    widget._bloc.actionsSink.add(action);
    action.future.then((result) {
      final newBalance = result as AddressBalance;
      if (mounted) {
        setState(() => _balance = newBalance);
      }
    }).onError((error, stackTrace) {
      bool here = true; // TODO: Handle errors when retrieving balance
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccountModel>(
      stream: AppBlocsProvider.of<AccountBloc>(context).accountStream,
      builder: (context, snapshot) {
        final minFont = MinFontSize(context);
        final texts = context.texts();
        final themeData = Theme.of(context);
        final acc = snapshot.data;
        final showIndicator = _balance == null || acc == null;
        final canSweep = !showIndicator && _balance.confirmed > 0;

        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SingleButtonBottomBar(
              stickToBottom: true,
              text: texts.satscard_balance_button_label,
              onPressed: () {
                if (!canSweep) {
                  promptError(
                      context,
                      texts.satscard_balance_warning_no_funds_title,
                      Text(
                        texts.satscard_balance_warning_no_funds_body,
                        style: themeData.dialogTheme.contentTextStyle,
                      ));
                  //return;
                }

                if (_balance.unconfirmed > 0) {
                  promptAreYouSure(
                    context,
                    texts.satscard_balance_warning_unconfirmed_title,
                    Text(
                      texts.satscard_balance_warning_unconfirmed_body,
                      style: themeData.dialogTheme.contentTextStyle,
                    ),
                  ).then((result) {
                    if (result == true) {
                      widget.onSweep(_balance);
                    }
                  });
                } else {
                  widget.onSweep(_balance);
                }
              },
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
                    child: showIndicator
                        ? Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: CircularProgress(
                              color: themeData.progressIndicatorTheme.color,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              size: 64,
                              title: _balance == null
                                  ? texts
                                      .satscard_balance_awaiting_balance_label
                                  : texts
                                      .satscard_balance_awaiting_account_label,
                            ),
                          )
                        : Column(
                            children: [
                              ..._buildBalanceLabels(
                                  context, texts, themeData, minFont, acc),
                              _buildTextTile(context, themeData, minFont,
                                  titleText: texts.satscard_balance_slot_label,
                                  trailingText:
                                      "${widget._card.activeSlotIndex + 1} / ${widget._card.numSlots}"),
                              _buildTextTile(context, themeData, minFont,
                                  titleText:
                                      texts.satscard_balance_version_label,
                                  trailingText: widget._card.appletVersion),
                              _buildTextTile(context, themeData, minFont,
                                  titleText:
                                      texts.satscard_balance_birth_height_label,
                                  trailingText:
                                      widget._card.birthHeight.toString()),
                              _buildTextTile(context, themeData, minFont,
                                  titleText:
                                      texts.satscard_balance_card_id_label,
                                  trailingText: widget._card.ident,
                                  flushbarMessage:
                                      texts.satscard_card_id_copied),
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

  ListTile _buildTextTile(
      BuildContext context, ThemeData themeData, MinFontSize minFont,
      {String titleText, String trailingText, String flushbarMessage}) {
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
        titleText ?? "",
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

  List<Widget> _buildBalanceLabels(
      BuildContext context,
      BreezTranslations texts,
      ThemeData themeData,
      MinFontSize minFont,
      AccountModel acc) {
    Widget build(String title, Int64 sats) {
      final formatted = acc.currency.format(sats);
      final translated = acc.fiatCurrency == null
          ? texts.satscard_balance_value_no_fiat(formatted)
          : texts.satscard_balance_value_with_fiat(
              formatted, acc.fiatCurrency.format(sats));
      return _buildTextTile(context, themeData, minFont,
          titleText: title, trailingText: translated);
    }

    final confirmedWidget =
        build(texts.satscard_balance_confirmed_label, _balance.confirmed);
    return _balance.unconfirmed > 0
        ? [
            confirmedWidget,
            build(
                texts.satscard_balance_unconfirmed_label, _balance.unconfirmed)
          ]
        : [confirmedWidget];
  }
}
