import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_actions.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/routes/user/withdraw_funds/reverse_swap_confirmation.dart';
import 'package:breez/routes/user/withdraw_funds/swap_in_progress.dart';
import 'package:breez/routes/user/withdraw_funds/withdraw_funds_page.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;

class ReverseSwapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReverseSwapPageState();
  }
}

class ReverseSwapPageState extends State<ReverseSwapPage> {
  StreamController<ReverseSwapInfo> _reverseSwapsStream =
      BehaviorSubject<ReverseSwapInfo>();
  PageController _pageController = PageController();

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
    AppBlocsProvider.of<ReverseSwapBloc>(context)
        .actionsSink
        .add(FetchInProgressSwap());
  }

  @override
  Widget build(BuildContext context) {
    var reverseSwapBloc = AppBlocsProvider.of<ReverseSwapBloc>(context);
    var accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return Scaffold(
        body: StreamBuilder<AccountModel>(
            stream: accountBloc.accountStream,
            builder: (context, accSnapshot) {
              return StreamBuilder<InProgressReverseSwaps>(
                  stream: reverseSwapBloc.swapInProgressStream,
                  builder: (context, snapshot) {
                    var swapInProgress = snapshot.data;
                    if (swapInProgress == null || !swapInProgress.isEmpty) {
                      return SwapInProgress(swapInProgress: swapInProgress);
                    }
                    return StreamBuilder<ReverseSwapInfo>(
                        stream: _reverseSwapsStream.stream,
                        builder: (context, swapSnapshot) {
                          String initialAddress, initialAmount;
                          var currentSwap = swapSnapshot.data;
                          if (currentSwap != null) {
                            initialAddress = currentSwap.claimAddress;
                            initialAmount = accSnapshot.data.currency.format(
                                currentSwap.amount,
                                userInput: true,
                                includeSymbol: false);
                          }
                          return PageView(
                            controller: _pageController,
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              WithdrawFundsPage(
                                  initialAddress: initialAddress,
                                  initialAmount: initialAmount,
                                  onNext: (swap) {
                                    _reverseSwapsStream.add(swap);
                                    _pageController.nextPage(
                                        duration: Duration(milliseconds: 250),
                                        curve: Curves.easeInOut);
                                  }),
                              currentSwap == null
                                  ? SizedBox()
                                  : ReverseSwapConfirmation(
                                      swap: swapSnapshot.data,
                                      bloc: reverseSwapBloc,
                                      onSuccess: () {
                                        Navigator.of(context).pop();
                                      },
                                      onPrevious: () {
                                        _pageController
                                            .previousPage(
                                                duration:
                                                    Duration(milliseconds: 250),
                                                curve: Curves.easeInOut)
                                            .then((_) {
                                          _reverseSwapsStream.add(null);
                                        });
                                      }),
                            ],
                          );
                        });
                  });
            }));
  }
}
