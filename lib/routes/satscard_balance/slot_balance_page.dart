import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/satscard/satscard_actions.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/routes/add_funds/address_widget.dart';
import 'package:breez/routes/satscard_balance/satscard_balance_page.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/circular_progress.dart';
import 'package:breez/widgets/error_dialog.dart';
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
  final Function(AddressInfo) onSweep;

  const SlotBalancePage(this._bloc, this._card, this._slot,
      {this.onBack, this.onSweep});

  @override
  State<StatefulWidget> createState() => SlotBalancePageState();
}

class SlotBalancePageState extends State<SlotBalancePage> {
  AddressInfo _addressInfo;

  @override
  void initState() {
    super.initState();
    final action = GetAddressInfo(widget._slot.address);
    widget._bloc.actionsSink.add(action);
    action.future.then((result) {
      final newInfo = result as AddressInfo;
      if (mounted) {
        setState(() => _addressInfo = newInfo);
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
        final showIndicator = _addressInfo == null || acc == null;
        final canSweep = !showIndicator && _addressInfo.confirmedBalance > 0;

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

                if (_addressInfo.unconfirmedBalance > 0) {
                  promptAreYouSure(
                    context,
                    texts.satscard_balance_warning_unconfirmed_title,
                    Text(
                      texts.satscard_balance_warning_unconfirmed_body,
                      style: themeData.dialogTheme.contentTextStyle,
                    ),
                  ).then((result) {
                    if (result == true) {
                      widget.onSweep(_addressInfo);
                    }
                  });
                } else {
                  widget.onSweep(_addressInfo);
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
                            padding: const EdgeInsets.only(top: 25),
                            child: CircularProgress(
                              size: 64,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              color: themeData.progressIndicatorTheme.color,
                              title: _addressInfo == null
                                  ? texts
                                      .satscard_balance_awaiting_balance_label
                                  : texts
                                      .satscard_balance_awaiting_account_label,
                            ),
                          )
                        : Column(
                            children: [
                              ..._buildBalanceTiles(
                                  context, texts, themeData, minFont, acc),
                              buildSlotPageTextTile(context, minFont,
                                  titleText: texts.satscard_balance_slot_label,
                                  trailingText:
                                      "${widget._card.activeSlotIndex + 1} / ${widget._card.numSlots}"),
                              buildSlotPageTextTile(context, minFont,
                                  titleText:
                                      texts.satscard_balance_version_label,
                                  trailingText: widget._card.appletVersion),
                              buildSlotPageTextTile(context, minFont,
                                  titleText:
                                      texts.satscard_balance_birth_height_label,
                                  trailingText:
                                      widget._card.birthHeight.toString()),
                              buildSlotPageTextTile(context, minFont,
                                  titleText:
                                      texts.satscard_balance_card_id_label,
                                  trailingText: widget._card.ident,
                                  copyMessage: texts.satscard_card_id_copied),
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

  List<ListTile> _buildBalanceTiles(
    BuildContext context,
    BreezTranslations texts,
    ThemeData themeData,
    MinFontSize minFont,
    AccountModel acc,
  ) {
    ListTile build({String title, Int64 sats, Color color}) {
      final formatted = acc.currency.format(sats);
      final translated = acc.fiatCurrency == null
          ? texts.satscard_balance_value_no_fiat(formatted)
          : texts.satscard_balance_value_with_fiat(
              formatted, acc.fiatCurrency.format(sats));

      return buildSlotPageTextTile(context, minFont,
          titleText: title, trailingText: translated, trailingColor: color);
    }

    final confirmedWidget = build(
      title: texts.satscard_balance_confirmed_label,
      sats: _addressInfo.confirmedBalance,
      color: themeData.colorScheme.error,
    );

    // Only show unconfirmed balance we have one
    if (_addressInfo.unconfirmedBalance != 0) {
      return [
        confirmedWidget,
        build(
          title: texts.satscard_balance_unconfirmed_label,
          sats: _addressInfo.unconfirmedBalance,
          color: Colors.white.withOpacity(0.4),
        ),
      ];
    }
    return [confirmedWidget];
  }
}
