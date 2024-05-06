import 'dart:async';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/withdraw_funds/sweep_all_coins_confirmation.dart';
import 'package:breez/routes/withdraw_funds/withdraw_funds_page.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _log = Logger("UnexpectedFunds");

class UnexpectedFunds extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UnexpectedFundsState();
  }
}

class UnexpectedFundsState extends State<UnexpectedFunds> {
  String _destAddress;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      _log.info("Page ${_pageController.page}");
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
    _log.info("build address: $_destAddress");
    final themeData = Theme.of(context);
    final texts = context.texts();
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return Scaffold(
      body: StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, accSnapshot) {
          if (accSnapshot.data == null) {
            _log.info("No account yet");
            return Center(
              child: Loader(
                color: themeData.primaryColor.withOpacity(0.5),
              ),
            );
          }

          final balance = accSnapshot.data.walletBalance;
          _log.info("balance: $balance");
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
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
                  _log.info("onNext: $amount, $address");
                  setState(() {
                    _destAddress = address;
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  });
                  return Future.value(null);
                },
              ),
              _destAddress == null
                  ? const SizedBox()
                  : SweepAllCoinsConfirmation(
                      accountBloc: accountBloc,
                      address: _destAddress,
                      onConfirm: (txDetails) {
                        _log.info("onConfirm: ${txDetails.txHash}}");
                        var action = PublishTransaction(txDetails.txBytes);
                        accountBloc.userActionsSink.add(action);
                        return action.future.then((value) => Navigator.of(context).pop());
                      },
                      onPrevious: () {
                        _log.info("onPrevious");
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 250),
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
