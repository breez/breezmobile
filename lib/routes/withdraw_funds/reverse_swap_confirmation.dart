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
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class ReverseSwapConfirmation extends StatefulWidget {
  final ReverseSwapDetails swap;
  final ReverseSwapBloc bloc;
  final Function() onPrevious;
  final Future Function(Int64 fee) onFeeConfirmed;

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

      feeOptions = trimmedTargetConfirmations
          .map((e) => FeeOption(feeEstimates.fees[e].toInt(), e))
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
    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          leading: backBtn.BackButton(onPressed: () {
            widget.onPrevious();
          }),
          title: Text("Choose Processing Speed",
              style: Theme.of(context).appBarTheme.textTheme.title),
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
                        buildSummary(acc),
                      ],
                    ),
                  );
                });
          }),
      bottomNavigationBar: !_showConfirm
          ? null
          : Padding(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                SizedBox(
                  height: 48.0,
                  width: 168.0,
                  child: RaisedButton(
                    child: Text(
                      "CONFIRM",
                      style: Theme.of(context).textTheme.button,
                    ),
                    color: Theme.of(context).buttonColor,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(42.0)),
                    onPressed: () {
                      Navigator.of(context).push(createLoaderRoute(context));
                      widget
                          .onFeeConfirmed(
                              Int64(feeOptions[selectedFeeIndex].sats))
                          .then((_) {
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        Navigator.of(context).pop();
                        promptError(
                            context,
                            null,
                            Text(error.toString(),
                                style: Theme.of(context)
                                    .dialogTheme
                                    .contentTextStyle));
                      });
                    },
                  ),
                ),
              ])),
    );
  }

  Widget buildSummary(AccountModel acc) {
    var receive = widget.swap.onChainAmount - feeOptions[selectedFeeIndex].sats;
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
                acc.currency.format(widget.swap.amount),
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
                "-${acc.currency.format(widget.swap.amount - widget.swap.onChainAmount)}",
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
                acc.currency.format(widget.swap.onChainAmount -
                        feeOptions[selectedFeeIndex].sats) +
                    (acc.fiatCurrency == null
                        ? ""
                        : " (${acc.fiatCurrency.format(receive)})"),
                style: TextStyle(color: Theme.of(context).errorColor),
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
            ))
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
