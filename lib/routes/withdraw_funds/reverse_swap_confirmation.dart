import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_actions.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/fee_chooser.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class ReverseSwapConfirmation extends StatefulWidget {
  final ReverseSwapRequest swap;
  final ReverseSwapBloc bloc;
  final Function() onPrevious;
  final Future Function(String address, Int64 toSend, Int64 boltzFees,
      Int64 claimFees, Int64 received, String feesHash) onFeeConfirmed;

  const ReverseSwapConfirmation(
      {Key key, this.swap, this.onPrevious, this.onFeeConfirmed, this.bloc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReverseSwapConfirmationState();
  }
}

class ReverseSwapConfirmationState extends State<ReverseSwapConfirmation> {
  List<FeeOption> feeOptions;
  Map<int, ReverseSwapAmounts> amounts;
  int selectedFeeIndex = 1;
  Future _claimFeeFuture;
  bool _showConfirm = false;

  @override
  void initState() {
    super.initState();
    var action = GetClaimFeeEstimates(widget.swap.claimAddress);
    widget.bloc.actionsSink.add(action);
    _claimFeeFuture = action.future.then((r) {
      ReverseSwapClaimFeeEstimates feeEstimates =
          r as ReverseSwapClaimFeeEstimates;
      List<int> targetConfirmations = feeEstimates.fees.keys.toList()..sort();
      var trimmedTargetConfirmations = targetConfirmations.reversed.toList();
      if (trimmedTargetConfirmations.length > 3) {
        var middle = (targetConfirmations.length / 2).floor();
        trimmedTargetConfirmations = [
          targetConfirmations.last,
          targetConfirmations[middle],
          targetConfirmations.first
        ];
      }

      if (widget.swap.isMax) {
        amounts = new Map.fromIterable(trimmedTargetConfirmations,
            key: (e) => e,
            value: (e) {
              var toSend = widget.swap.amount;
              var boltzFees = Int64(
                      (toSend.toDouble() * widget.swap.policy.percentage / 100)
                          .ceil()) +
                  widget.swap.policy.lockup;
              var received = toSend - boltzFees - feeEstimates.fees[e];
              return ReverseSwapAmounts(
                  toSend, boltzFees, feeEstimates.fees[e], received);
            });
      } else {
        amounts = new Map.fromIterable(trimmedTargetConfirmations,
            key: (e) => e,
            value: (e) {
              var received = widget.swap.amount;
              //(bt + cl)*pe/(1-pe) + lo/(1-pe)
              var p = widget.swap.policy.percentage / 100;
              var boltzFees = Int64(
                  ((received + feeEstimates.fees[e]).toDouble() * p / (1 - p) +
                          widget.swap.policy.lockup.toDouble() / (1 - p))
                      .ceil());
              var toSend = received + boltzFees + feeEstimates.fees[e];

              return ReverseSwapAmounts(
                  toSend, boltzFees, feeEstimates.fees[e], received);
            });
      }
      feeOptions = trimmedTargetConfirmations
          .map((e) => FeeOption(feeEstimates.fees[e].toInt(), e))
          .where((e) =>
              amounts[e.confirmationTarget].received > 0 &&
              amounts[e.confirmationTarget].toSend <= widget.swap.available)
          .toList();

      if (feeOptions.length > 0) {
        setState(() {
          _showConfirm = true;
        });
      }
      selectedFeeIndex = (feeOptions.length / 2).floor();
      while (feeOptions.length < 3) {
        feeOptions.add(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var rsAmounts = feeOptions[selectedFeeIndex] != null
        ? amounts[feeOptions[selectedFeeIndex].confirmationTarget]
        : null;

    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          leading: backBtn.BackButton(onPressed: () {
            widget.onPrevious();
          }),
          title: Text("Choose Processing Speed",
              style: Theme.of(context).appBarTheme.textTheme.headline6),
          elevation: 0.0),
      body: StreamBuilder<AccountModel>(
          stream: AppBlocsProvider.of<AccountBloc>(context).accountStream,
          builder: (context, snapshot) {
            AccountModel acc = snapshot.data;
            return FutureBuilder(
                future: _claimFeeFuture,
                builder: (context, futureSnapshot) {
                  if (futureSnapshot.error != null) {
                    //render error
                    return _ErrorMessage(
                        message:
                            "Failed to retrieve fees. Please try again later.");
                  }
                  if (futureSnapshot.connectionState != ConnectionState.done ||
                      acc == null) {
                    //render loader
                    return SizedBox();
                  }

                  if (feeOptions.where((f) => f != null).length == 0) {
                    return _ErrorMessage(
                        message:
                            "The amount is too small to broadcast. Please try again later.");
                  }

                  return Container(
                    height: 500.0,
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      //mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: FeeChooser(
                            economyFee: feeOptions[0],
                            regularFee: feeOptions[1],
                            priorityFee: feeOptions[2],
                            selectedIndex: this.selectedFeeIndex,
                            onSelect: (index) {
                              this.setState(() {
                                this.selectedFeeIndex = index;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 36.0),
                        buildSummary(acc, rsAmounts.toSend, rsAmounts.boltzFees,
                            rsAmounts.received),
                      ],
                    ),
                  );
                });
          }),
      bottomNavigationBar: !_showConfirm
          ? null
          : SingleButtonBottomBar(
              text: "CONFIRM",
              onPressed: () {
                Navigator.of(context).push(createLoaderRoute(context));
                widget
                    .onFeeConfirmed(
                        widget.swap.claimAddress,
                        rsAmounts.toSend,
                        rsAmounts.boltzFees,
                        rsAmounts.claimFees,
                        rsAmounts.received,
                        widget.swap.policy.feesHash)
                    .then((_) {
                  Navigator.of(context).pop();
                }).catchError((error) {
                  Navigator.of(context).pop();
                  promptError(
                      context,
                      null,
                      Text(error.toString(),
                          style:
                              Theme.of(context).dialogTheme.contentTextStyle));
                });
              },
            ),
    );
  }

  Widget buildSummary(AccountModel acc, Int64 toSend, boltzFees, received) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4))),
      child: ListView(shrinkWrap: true, children: <Widget>[
        ListTile(
            title: Container(
              child: AutoSizeText(
                "You send:",
                style: TextStyle(color: Colors.white),
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
            ),
            trailing: Container(
              child: AutoSizeText(
                acc.currency.format(toSend),
                style: TextStyle(color: Theme.of(context).errorColor),
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
            )),
        ListTile(
            title: Container(
              child: AutoSizeText(
                "Boltz service fee:",
                style: TextStyle(color: Colors.white.withOpacity(0.4)),
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
            ),
            trailing: Container(
              child: AutoSizeText(
                "-" + acc.currency.format(boltzFees),
                style: TextStyle(
                    color: Theme.of(context).errorColor.withOpacity(0.4)),
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
            )),
        ListTile(
            title: Container(
              child: AutoSizeText(
                "Transaction fee:",
                style: TextStyle(color: Colors.white.withOpacity(0.4)),
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
            ),
            trailing: Container(
              child: AutoSizeText(
                "-${acc.currency.format(Int64(feeOptions[selectedFeeIndex].sats))}",
                style: TextStyle(
                    color: Theme.of(context).errorColor.withOpacity(0.4)),
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
            )),
        ListTile(
            title: Container(
              child: AutoSizeText(
                "You receive:",
                style: TextStyle(color: Colors.white),
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
            ),
            trailing: Container(
              child: AutoSizeText(
                acc.currency.format(received) +
                    (acc.fiatCurrency == null
                        ? ""
                        : " (${acc.fiatCurrency.format(received)})"),
                style: TextStyle(color: Theme.of(context).errorColor),
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
            )),
      ]),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40.0, left: 40.0, right: 40.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                message,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ));
  }
}

class ReverseSwapAmounts {
  final Int64 toSend;
  final Int64 boltzFees;
  final Int64 claimFees;
  final Int64 received;

  ReverseSwapAmounts(
      this.toSend, this.boltzFees, this.claimFees, this.received);
}
