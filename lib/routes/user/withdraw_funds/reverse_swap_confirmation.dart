import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_actions.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/fee_chooser.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:fixnum/fixnum.dart';

class ReverseSwapConfirmation extends StatefulWidget {
  final ReverseSwapInfo swap;
  final ReverseSwapBloc bloc;
  final Function() onPrevious;
  final Function() onSuccess;

  const ReverseSwapConfirmation(
      {Key key, this.swap, this.onPrevious, this.onSuccess, this.bloc})
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

  @override
  void initState() {
    super.initState();
    var action = GetClaimFeeEstimates(widget.swap.claimAddress);
    widget.bloc.actionsSink.add(action);
    _claimFeeFuture = action.future.then((r) {
      ReverseSwapClaimFeeEstimates feeEstimates =
          r as ReverseSwapClaimFeeEstimates;
      List<int> targetConfirmations = feeEstimates.fees.keys.toList()..sort();
      var middle = (targetConfirmations.length / 2).floor();
      feeOptions = [
        FeeOption(feeEstimates.fees[targetConfirmations.last].toInt(),
            targetConfirmations.last),
        FeeOption(feeEstimates.fees[targetConfirmations[middle]].toInt(),
            targetConfirmations[middle]),
        FeeOption(feeEstimates.fees[targetConfirmations.first].toInt(),
            targetConfirmations.first)
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    ReverseSwapBloc reverseSwapBloc =
        AppBlocsProvider.of<ReverseSwapBloc>(context);
    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          leading: backBtn.BackButton(onPressed: () {
            widget.onPrevious();
          }),
          title: Text("Confirm",
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
                    return Center(
                        child: Text(
                            "Failed to retrive fees. Please try again later: ${futureSnapshot.error.toString()}"));
                  }
                  if (futureSnapshot.connectionState != ConnectionState.done ||
                      acc == null) {
                    //render loader
                    return SizedBox();
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
      bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 40.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            SizedBox(
              height: 48.0,
              width: 168.0,
              child: RaisedButton(
                child: Text(
                  "PAY",
                  style: Theme.of(context).textTheme.button,
                ),
                color: Theme.of(context).buttonColor,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(42.0)),
                onPressed: () {
                  Navigator.of(context).push(createLoaderRoute(context));
                  var action = PayReverseSwap(
                      widget.swap, Int64(feeOptions[selectedFeeIndex].sats));
                  reverseSwapBloc.actionsSink.add(action);
                  action.future.then((_) {
                    Navigator.of(context).pop();
                    widget.onSuccess();
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
                    feeOptions[selectedFeeIndex].sats),
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
