import 'dart:async';

import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_actions.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/fee_chooser.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/warning_box.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendOnchainFeeConfirmation extends StatefulWidget {
  final String address;
  final String refundAddress;
  final Int64 amount;
  final Function(Int64 fee) onFeeSelection;
  final Function() onPrevious;

  const SendOnchainFeeConfirmation({
    Key key,
    this.address,
    this.refundAddress,
    this.amount,
    this.onFeeSelection,
    this.onPrevious,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SendOnchainFeeConfirmationState();
  }
}

class SendOnchainFeeConfirmationState
    extends State<SendOnchainFeeConfirmation> {
  ReverseSwapBloc reverseSwapBloc;
  int selectedFeeIndex = 1;
  Future<List> refundFeeList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reverseSwapBloc == null) {
      reverseSwapBloc = AppBlocsProvider.of<ReverseSwapBloc>(context);
      refundFeeList = getRefundFees();
    }
  }

  Future<List> getRefundFees() {
    final economicFeeAction =
        GetRefundFee(widget.address, widget.refundAddress, 3, widget.amount);
    final regularFeeAction =
        GetRefundFee(widget.address, widget.refundAddress, 2, widget.amount);
    final priorityFeeAction =
        GetRefundFee(widget.address, widget.refundAddress, 1, widget.amount);
    reverseSwapBloc.actionsSink.add(economicFeeAction);
    reverseSwapBloc.actionsSink.add(regularFeeAction);
    reverseSwapBloc.actionsSink.add(priorityFeeAction);
    return Future.wait(
      [
        economicFeeAction.future,
        regularFeeAction.future,
        priorityFeeAction.future,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: themeData.appBarTheme.iconTheme,
        textTheme: themeData.appBarTheme.textTheme,
        backgroundColor: themeData.canvasColor,
        leading: backBtn.BackButton(onPressed: () {
          widget.onPrevious();
        }),
        title: Text(
          texts.reverse_swap_confirmation_speed,
          style: themeData.appBarTheme.textTheme.headline6,
        ),
        elevation: 0.0,
      ),
      body: Container(
        height: 500.0,
        padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: refundFeeList,
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasError) {
                  return buildErrorBox(texts, context);
                }

                if (snapshot.hasData) {
                  final List<FeeOption> feeOptions = snapshot.data
                      .map((fee) => FeeOption(fee.toInt(), 3))
                      .toList();

                  return Container(
                    child: FeeChooser(
                      economyFee: feeOptions[0],
                      regularFee: feeOptions[1],
                      priorityFee: feeOptions[2],
                      selectedIndex: this.selectedFeeIndex,
                      onSelect: (index) {
                        this.setState(() {
                          this.selectedFeeIndex = index;
                        });
                        widget.onFeeSelection(snapshot.data[selectedFeeIndex]);
                      },
                    ),
                  );
                }

                return Expanded(child: Center(child: Loader()));
              },
            )
          ],
        ),
      ),
    );
  }

  Expanded buildErrorBox(AppLocalizations texts, BuildContext context) {
    return Expanded(
      child: Center(
        child: WarningBox(
            boxPadding: const EdgeInsets.symmetric(
              horizontal: 0,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  texts.sweep_all_coins_error_retrieve_fees,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).buttonColor,
                    elevation: 0.0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      refundFeeList = getRefundFees();
                    });
                  },
                  child: Text(
                    texts.invoice_btc_address_action_retry,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
