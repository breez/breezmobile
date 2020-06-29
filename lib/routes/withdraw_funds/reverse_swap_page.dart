import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_actions.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import 'reverse_swap_confirmation.dart';
import 'swap_in_progress.dart';
import 'withdraw_funds_page.dart';

class ReverseSwapPage extends StatefulWidget {
  final String userAddress;
  final String requestAmount;

  const ReverseSwapPage({Key key, this.userAddress, this.requestAmount})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReverseSwapPageState();
  }
}

class ReverseSwapPageState extends State<ReverseSwapPage> {
  ReverseSwapBloc _reverseSwapBloc;
  StreamController<ReverseSwapDetails> _reverseSwapsStream =
      BehaviorSubject<ReverseSwapDetails>();
  PageController _pageController = PageController();
  Completer _policyCompleter = Completer();
  Object _loadingError;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_reverseSwapBloc == null) {
      _reverseSwapBloc = AppBlocsProvider.of<ReverseSwapBloc>(context);
      _reverseSwapBloc.actionsSink.add(FetchInProgressSwap());
      var getPolicyAction = GetReverseSwapPolicy();
      _reverseSwapBloc.actionsSink.add(getPolicyAction);
      getPolicyAction.future.then((res) {
        setState(() {
          _policyCompleter.complete(res);
        });
      }).catchError((err) {
        setState(() {
          _loadingError = err;
          _policyCompleter.completeError(err);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var reverseSwapBloc = AppBlocsProvider.of<ReverseSwapBloc>(context);
    var accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return Scaffold(
        appBar: !_policyCompleter.isCompleted || _loadingError != null
            ? AppBar(
                iconTheme: Theme.of(context).appBarTheme.iconTheme,
                textTheme: Theme.of(context).appBarTheme.textTheme,
                backgroundColor: Theme.of(context).canvasColor,
                leading: backBtn.BackButton(onPressed: () {
                  Navigator.of(context).pop();
                }),
                title: Text("Send to BTC Address",
                    style: Theme.of(context).appBarTheme.textTheme.headline6),
                elevation: 0.0)
            : null,
        body: StreamBuilder<AccountModel>(
            stream: accountBloc.accountStream,
            builder: (context, accSnapshot) {
              return FutureBuilder<Object>(
                  future: _policyCompleter.future,
                  builder: (context, snapshot) {
                    if (snapshot.error != null) {
                      return Center(
                          child: Text(snapshot.error.toString(),
                              textAlign: TextAlign.center));
                    }
                    if (snapshot.data == null) {
                      return Center(
                          child: Loader(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5)));
                    }
                    ReverseSwapPolicy policy =
                        snapshot.data as ReverseSwapPolicy;
                    return StreamBuilder<InProgressReverseSwaps>(
                        stream: reverseSwapBloc.swapInProgressStream,
                        builder: (context, snapshot) {
                          var swapInProgress = snapshot.data;
                          if (swapInProgress == null ||
                              !swapInProgress.isEmpty) {
                            return SwapInProgress(
                                swapInProgress: swapInProgress);
                          }
                          return StreamBuilder<ReverseSwapDetails>(
                              stream: _reverseSwapsStream.stream,
                              builder: (context, swapSnapshot) {
                                String initialAddress, initialAmount;
                                var currentSwap = swapSnapshot.data;
                                if (widget.userAddress != null) {
                                  initialAddress = widget.userAddress;
                                }
                                if (currentSwap != null) {
                                  initialAddress = currentSwap.claimAddress;
                                  initialAmount = accSnapshot.data.currency
                                      .format(currentSwap.amount,
                                          userInput: true,
                                          includeDisplayName: false);
                                } else if (widget.requestAmount != null) {
                                  initialAmount = widget.requestAmount;
                                }

                                return PageView(
                                  controller: _pageController,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    WithdrawFundsPage(
                                        title: "Send to BTC Address",
                                        policy: WithdrawFundsPolicy(
                                            policy.minValue,
                                            policy.maxValue,
                                            accSnapshot.data.balance),
                                        initialAddress: initialAddress,
                                        initialAmount: initialAmount,
                                        onNext: (amount, address) {
                                          var action = NewReverseSwap(
                                              amount, address, Int64(0));
                                          reverseSwapBloc.actionsSink
                                              .add(action);
                                          return action.future.then((swap) {
                                            _reverseSwapsStream.add(swap);
                                            _pageController.nextPage(
                                                duration:
                                                    Duration(milliseconds: 250),
                                                curve: Curves.easeInOut);
                                          });
                                        }),
                                    currentSwap == null
                                        ? SizedBox()
                                        : ReverseSwapConfirmation(
                                            swap: swapSnapshot.data,
                                            bloc: reverseSwapBloc,
                                            onFeeConfirmed: (fee) {
                                              var action = PayReverseSwap(
                                                  swapSnapshot.data, fee);
                                              reverseSwapBloc.actionsSink
                                                  .add(action);
                                              return action.future
                                                  .then((value) {
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            onPrevious: () {
                                              _pageController
                                                  .previousPage(
                                                      duration: Duration(
                                                          milliseconds: 250),
                                                      curve: Curves.easeInOut)
                                                  .then((_) {
                                                _reverseSwapsStream.add(null);
                                              });
                                            }),
                                  ],
                                );
                              });
                        });
                  });
            }));
  }
}
