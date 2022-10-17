import 'dart:async';

import 'package:clovrlabs_wallet/bloc/account/account_actions.dart';
import 'package:clovrlabs_wallet/bloc/account/account_bloc.dart';
import 'package:clovrlabs_wallet/bloc/account/account_model.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return Scaffold(
      body: StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, accSnapshot) {
          if (accSnapshot.data == null) {
            return Center(
              child: Loader(
                color: themeData.primaryColor.withOpacity(0.5),
              ),
            );
          }
          final balance = accSnapshot.data.walletBalance;
          return PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              WithdrawFundsPage(
                title: texts.unexpected_funds_title,
                optionalMessage: texts.unexpected_funds_message,
                policy: WithdrawFundsPolicy(balance, balance, balance, balance),
                initialAddress: _destAddress,
                initialAmount: accSnapshot.data.currency.format(
                  balance,
                  userInput: true,
                  includeDisplayName: false,
                ),
                onNext: (amount, address, _) {
                  setState(() {
                    this._destAddress = address;
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  });
                  return Future.value(null);
                },
              ),
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
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
            ],
          );
        },
      ),
    );
  }
}
