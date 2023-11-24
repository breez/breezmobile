import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/satscard/satscard_bloc.dart';
import 'package:breez/routes/satscard_balance/slot_balance_page.dart';
import 'package:breez/routes/satscard_balance/sweep_slot_page.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = AppBlocsProvider.of<SatscardBloc>(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SlotBalancePage(
            bloc,
            widget._card,
            widget._slot,
            onBack: () => Navigator.pop(context),
            onSweep: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            ),
          ),
          SweepSlotPage(
            bloc,
            widget._card,
            widget._slot,
            onBack: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }
}
