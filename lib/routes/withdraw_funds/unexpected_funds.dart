import 'dart:async';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';

import 'sweep_all_coins_confirmation.dart';
import 'withdraw_funds_page.dart';

class UnexpectedFunds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UnexpectedFundsState();
  }
}

class UnexpectedFundsState extends State<UnexpectedFunds> {
  String _destAddress;
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
  Widget build(BuildContext context) {
    var accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return Scaffold(
        body: StreamBuilder<AccountModel>(
            stream: accountBloc.accountStream,
            builder: (context, accSnapshot) {
              if (accSnapshot.data == null) {
                return Center(
                    child: Loader(
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.5)));
              }
              return PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  WithdrawFundsPage(
                      title: "Unexpected Funds",
                      optionalMessage:
                          "Breez found unexpected funds in its underlying wallet (probably due to a closed channel). It is highly recommended you send these fund to a BTC address as soon as possible.",
                      policy: WithdrawFundsPolicy(
                          accSnapshot.data.walletBalance,
                          accSnapshot.data.walletBalance,
                          accSnapshot.data.walletBalance),
                      initialAddress: _destAddress,
                      initialAmount: accSnapshot.data.currency.format(
                          accSnapshot.data.walletBalance,
                          userInput: true,
                          includeDisplayName: false),
                      onNext: (amount, address) {
                        setState(() {
                          this._destAddress = address;
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 250),
                              curve: Curves.easeInOut);
                        });
                        return Future.value(null);
                      }),
                  _destAddress == null
                      ? SizedBox()
                      : SweepAllCoinsConfirmation(
                          accountBloc: accountBloc,
                          address: _destAddress,
                          onConfirm: (txDetails) {
                            var action = PublishTransaction(txDetails.txBytes);
                            accountBloc.userActionsSink.add(action);
                            return action.future
                                .then((value) => Navigator.of(context).pop());
                          },
                          onPrevious: () {
                            _pageController.previousPage(
                                duration: Duration(milliseconds: 250),
                                curve: Curves.easeInOut);
                          }),
                ],
              );
            }));
  }
}
