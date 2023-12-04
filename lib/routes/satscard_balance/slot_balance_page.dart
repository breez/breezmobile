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
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class SlotBalancePage extends StatefulWidget {
  final Satscard _card;
  final Slot _slot;
  final Function() onBack;
  final Function(AddressInfo) onSweep;

  const SlotBalancePage(this._card, this._slot,
      {@required this.onBack, @required this.onSweep});

  @override
  State<StatefulWidget> createState() => SlotBalancePageState();
}

class SlotBalancePageState extends State<SlotBalancePage> {
  SatscardBloc _satscardBloc;
  Future _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _satscardBloc = AppBlocsProvider.of<SatscardBloc>(context);
    _retrieveBalance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, infoSnapshot) => StreamBuilder<AccountModel>(
        stream: AppBlocsProvider.of<AccountBloc>(context).accountStream,
        builder: (context, accSnapshot) {
          final texts = context.texts();
          final themeData = Theme.of(context);

          final acc = accSnapshot.data;
          final info = infoSnapshot.data;
          final error = infoSnapshot.error ?? accSnapshot.error;
          final showError = error != null;
          final showLoader =
              !showError && (!infoSnapshot.hasData || !accSnapshot.hasData);
          final canSweep = !showError &&
              !showLoader &&
              infoSnapshot.data.confirmedBalance > 0;

          return Scaffold(
            appBar: AppBar(
              leading: backBtn.BackButton(onPressed: widget.onBack),
              title: Text(texts.satscard_balance_title),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SingleButtonBottomBar(
                stickToBottom: true,
                text: showError
                    ? texts.satscard_balance_button_retry_label
                    : texts.satscard_balance_button_label,
                onPressed: () => _onButtonPressed(
                  context,
                  themeData,
                  texts,
                  info,
                  showError: showError,
                  canSweep: canSweep,
                ),
              ),
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
                      padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
                      child: _buildBalanceBody(
                        context,
                        themeData,
                        texts,
                        acc,
                        info,
                        error: error,
                        showError: showError,
                        showLoader: showLoader,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceBody(
    BuildContext context,
    ThemeData themeData,
    BreezTranslations texts,
    AccountModel acc,
    AddressInfo info, {
    Object error,
    bool showError,
    bool showLoader,
  }) {
    if (showError) {
      return buildWarning(
        themeData,
        title: texts.satscard_balance_error_address_info(error.toString()),
      );
    } else if (showLoader) {
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: buildIndicator(
          themeData,
          title: info == null
              ? texts.satscard_balance_awaiting_balance_label
              : texts.satscard_balance_awaiting_account_label,
        ),
      );
    }
    final minFont = MinFontSize(context);
    return Column(
      children: [
        buildSlotPageTextTile(
          context,
          minFont,
          titleText: texts.satscard_balance_confirmed_label,
          trailingText: formatBalanceValue(texts, acc, info.confirmedBalance),
          trailingColor: themeData.colorScheme.error,
        ),
        info.unconfirmedBalance == 0
            ? null
            : buildSlotPageTextTile(
                context,
                minFont,
                titleText: texts.satscard_balance_unconfirmed_label,
                trailingText:
                    formatBalanceValue(texts, acc, info.unconfirmedBalance),
                trailingColor: Colors.white.withOpacity(0.4),
              ),
        buildSlotPageTextTile(context, minFont,
            titleText: texts.satscard_balance_slot_label,
            trailingText:
                "${widget._card.activeSlotIndex + 1} / ${widget._card.numSlots}"),
        buildSlotPageTextTile(context, minFont,
            titleText: texts.satscard_balance_version_label,
            trailingText: widget._card.appletVersion),
        buildSlotPageTextTile(context, minFont,
            titleText: texts.satscard_balance_birth_height_label,
            trailingText: widget._card.birthHeight.toString()),
        buildSlotPageTextTile(context, minFont,
            titleText: texts.satscard_balance_card_id_label,
            trailingText: widget._card.ident,
            copyMessage: texts.satscard_card_id_copied),
      ].whereNotNull().toList(),
    );
  }

  void _onButtonPressed(
    BuildContext context,
    ThemeData themeData,
    BreezTranslations texts,
    AddressInfo info, {
    bool showError,
    bool canSweep,
  }) async {
    if (showError) {
      _retrieveBalance();
      return;
    } else if (!canSweep) {
      promptError(
        context,
        texts.satscard_balance_warning_no_funds_title,
        Text(
          texts.satscard_balance_warning_no_funds_body,
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
      return;
    } else if (info.unconfirmedBalance > 0) {
      final confirm = await promptAreYouSure(
          context,
          texts.satscard_balance_warning_unconfirmed_title,
          Text(
            texts.satscard_balance_warning_unconfirmed_body,
            style: themeData.dialogTheme.contentTextStyle,
          ));
      if (!confirm) {
        return;
      }
    }
    if (context.mounted) {
      widget.onSweep(info);
    }
  }

  void _retrieveBalance() {
    setState(() {
      final action = GetAddressInfo(widget._slot.address);
      _satscardBloc.actionsSink.add(action);
      _future = action.future.then((result) => result as AddressInfo);
    });
  }
}
