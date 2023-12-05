import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/satscard_balance/broadcast_slot_sweep_transaction.dart';
import 'package:breez/routes/satscard_balance/slot_balance_page.dart';
import 'package:breez/routes/satscard_balance/sweep_slot_page.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/circular_progress.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/warning_box.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:cktap_protocol/cktapcard.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class SatscardBalancePage extends StatefulWidget {
  final Satscard _card;
  final Slot _slot;

  const SatscardBalancePage(this._card, this._slot);

  @override
  State<StatefulWidget> createState() => SatscardBalancePageState();
}

class SatscardBalancePageState extends State<SatscardBalancePage> {
  final _pageController = PageController();

  AddressInfo _recentAddressInfo;
  RawSlotSweepTransaction _selectedTransaction;
  Uint8List _slotPrivateKey;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SlotBalancePage(
            widget._card,
            widget._slot,
            onBack: () => Navigator.pop(context),
            onSweep: (balance) {
              _recentAddressInfo = balance;
              _pageController.nextPage(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
            },
          ),
          SweepSlotPage(
            widget._card,
            onBack: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            ),
            onUnsealed: (transaction, privateKey) {
              _selectedTransaction = transaction;
              _slotPrivateKey = privateKey;
              _pageController.nextPage(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
            },
            getAddressInfo: () => _recentAddressInfo,
            getCachedPrivateKey: () {
              // Allow for unsealed slots
              if (_slotPrivateKey.isEmpty) {
                return widget._slot.privkey;
              }
              return _slotPrivateKey;
            },
          ),
          BroadcastSlotSweepTransactionPage(
            onBack: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            ),
            onDone: () => Navigator.of(context).pop(),
            getAddressInfo: () => _recentAddressInfo,
            getPrivateKey: () => _slotPrivateKey,
            getTransaction: () => _selectedTransaction,
          ),
        ],
      ),
    );
  }
}

Widget buildErrorBody(ThemeData themeData, String title) {
  return Stack(
    children: <Widget>[
      Positioned.fill(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildWarning(themeData, title: title),
          ],
        ),
      ),
    ],
  );
}

Widget buildLoaderBody(ThemeData themeData, String title) {
  return Stack(
    children: <Widget>[
      Positioned.fill(
        child: buildIndicator(themeData, title: title),
      ),
    ],
  );
}

Widget buildIndicator(ThemeData themeData, {String title}) {
  return CircularProgress(
    size: 64,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    color: themeData.progressIndicatorTheme.color,
    title: title,
  );
}

ListTile buildSlotPageTextTile(
  BuildContext context,
  MinFontSize minFont, {
  String titleText,
  Color titleColor,
  String trailingText,
  Color trailingColor,
  String copyMessage,
}) {
  final style = theme.FieldTextStyle.labelStyle
      .copyWith(color: titleColor ?? Colors.white);
  final trailing = AutoSizeText(
    trailingText ?? "",
    style: style.copyWith(color: trailingColor ?? Colors.white),
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
    trailing: copyMessage == null
        ? trailing
        : GestureDetector(
            onTap: () {
              ServiceInjector().device.setClipboardText(trailingText);
              showFlushbar(context, message: copyMessage);
            },
            child: trailing,
          ),
  );
}

Widget buildWarning(ThemeData themeData, {String title}) {
  return WarningBox(
    child: Text(
      title,
      style: themeData.textTheme.titleLarge,
      textAlign: TextAlign.left,
    ),
  );
}

String formatBalanceValue(
    BreezTranslations texts, AccountModel acc, Int64 sats) {
  if (acc == null) {
    return sats.toString();
  }
  final satsString = acc.currency.format(sats);
  if (acc.fiatCurrency == null || sats <= 0) {
    return texts.satscard_balance_value_no_fiat(satsString);
  } else {
    final fiat = acc.fiatCurrency.format(sats);
    return texts.satscard_balance_value_with_fiat(satsString, fiat);
  }
}
