import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/routes/satscard_balance/slot_balance_page.dart';
import 'package:breez/routes/satscard_balance/sweep_slot_page.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:cktap_protocol/cktapcard.dart';
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
            widget._slot,
            onBack: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            ),
            getAddressInfo: () => _recentAddressInfo,
          ),
        ],
      ),
    );
  }
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
