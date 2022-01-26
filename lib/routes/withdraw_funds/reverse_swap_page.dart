import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_actions.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/payment_details_dialog.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/l10n/locales.dart';
import 'package:rxdart/subjects.dart';

import '../sync_progress_dialog.dart';
import 'reverse_swap_confirmation.dart';
import 'swap_in_progress.dart';
import 'withdraw_funds_page.dart';

class ReverseSwapPage extends StatefulWidget {
  final String userAddress;
  final String requestAmount;
  final bool isMax;

  const ReverseSwapPage({
    Key key,
    this.userAddress,
    this.requestAmount,
    this.isMax,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReverseSwapPageState();
  }
}

class ReverseSwapPageState extends State<ReverseSwapPage> {
  final _reverseSwapsStream = BehaviorSubject<ReverseSwapRequest>();
  final _pageController = PageController();
  final _policyCompleter = Completer();

  ReverseSwapBloc _reverseSwapBloc;
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
    final reverseSwapBloc = AppBlocsProvider.of<ReverseSwapBloc>(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (context, accSnapshot) {
        final accountModel = accSnapshot.data;
        final unconfirmedChannels = accountModel?.unconfirmedChannels;
        final hasUnconfirmed = (unconfirmedChannels?.length ?? 0) > 0;

        return Scaffold(
          appBar: !_policyCompleter.isCompleted ||
                  _loadingError != null ||
                  hasUnconfirmed
              ? AppBar(
                  iconTheme: Theme.of(context).appBarTheme.iconTheme,
                  textTheme: Theme.of(context).appBarTheme.textTheme,
                  backgroundColor: Theme.of(context).canvasColor,
                  leading: backBtn.BackButton(
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(
                    context.l10n.reverse_swap_title,
                    style: Theme.of(context).appBarTheme.textTheme.headline6,
                  ),
                  elevation: 0.0,
                )
              : null,
          body: FutureBuilder<Object>(
            future: _policyCompleter.future,
            builder: (context, snapshot) {
              if (hasUnconfirmed) {
                return UnconfirmedChannels(
                  accountModel: accountModel,
                  unconfirmedChannels: unconfirmedChannels,
                );
              }
              if (snapshot.error != null) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              if (snapshot.data == null) {
                return Center(
                  child: Loader(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                );
              }
              final policy = snapshot.data as ReverseSwapPolicy;

              return StreamBuilder<InProgressReverseSwaps>(
                stream: reverseSwapBloc.swapInProgressStream,
                builder: (context, snapshot) {
                  final swapInProgress = snapshot.data;
                  if (swapInProgress == null || !swapInProgress.isEmpty) {
                    return SwapInProgress(swapInProgress: swapInProgress);
                  }

                  return StreamBuilder<ReverseSwapRequest>(
                    stream: _reverseSwapsStream.stream,
                    builder: (context, swapSnapshot) {
                      String initialAddress, initialAmount;
                      bool initialIsMax;
                      final currentSwap = swapSnapshot.data;
                      if (widget.userAddress != null) {
                        initialAddress = widget.userAddress;
                      }
                      if (widget.requestAmount != null) {
                        initialAmount = widget.requestAmount;
                      }
                      if (widget.isMax != null) {
                        initialIsMax = widget.isMax;
                      }
                      if (currentSwap != null) {
                        initialAddress = currentSwap.claimAddress;
                        initialAmount = accountModel.currency.format(
                          currentSwap.amount,
                          userInput: true,
                          includeDisplayName: false,
                        );
                        initialIsMax = currentSwap.isMax;
                      }

                      return _pageView(
                        context,
                        reverseSwapBloc,
                        policy,
                        accountModel,
                        initialAddress,
                        initialAmount,
                        initialIsMax,
                        currentSwap,
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _pageView(
    BuildContext context,
    ReverseSwapBloc reverseSwapBloc,
    ReverseSwapPolicy policy,
    AccountModel accountModel,
    String initialAddress,
    String initialAmount,
    bool initialIsMax,
    ReverseSwapRequest currentSwap,
  ) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        WithdrawFundsPage(
          title: context.l10n.reverse_swap_title,
          policy: WithdrawFundsPolicy(
            policy.minValue,
            policy.maxValue,
            accountModel.balance,
            policy.maxAmount,
          ),
          initialAddress: initialAddress,
          initialAmount: initialAmount,
          initialIsMax: initialIsMax,
          onNext: (amount, address, isMax) {
            var action = GetReverseSwapPolicy();
            reverseSwapBloc.actionsSink.add(action);
            return action.future.then((pol) {
              _reverseSwapsStream.add(ReverseSwapRequest(
                address,
                amount,
                isMax,
                policy.maxAmount,
                pol,
              ));
              _pageController.nextPage(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
            });
          },
        ),
        currentSwap == null
            ? SizedBox()
            : ReverseSwapConfirmation(
                swap: currentSwap,
                bloc: reverseSwapBloc,
                onFeeConfirmed: _onFeeConfirmed,
                onPrevious: () => _pageController
                    .previousPage(
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    )
                    .then((_) => _reverseSwapsStream.add(null)),
              ),
      ],
    );
  }

  Future<dynamic> _onFeeConfirmed(
    String address,
    Int64 toSend,
    Int64 boltzFees,
    Int64 claimFees,
    Int64 received,
    String feesHash,
  ) {
    final swap = NewReverseSwap(toSend, address, feesHash, claimFees, received);
    _reverseSwapBloc.actionsSink.add(swap);
    return swap.future.then((value) {
      Navigator.of(context).pop();
    }).catchError((err) async {
      await promptError(context, null, Text(err.toString()));
    });
  }
}

class UnconfirmedChannels extends StatelessWidget {
  final AccountModel accountModel;
  final List<String> unconfirmedChannels;

  const UnconfirmedChannels({
    Key key,
    this.accountModel,
    this.unconfirmedChannels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rows = unconfirmedChannels.map((chainPoint) {
      final tx = chainPoint.split(":")[0];
      return TxWidget(
        txLabel: context.l10n.reverse_swap_funding_transaction,
        txID: tx,
        txURL: "https://blockstream.info/tx/$tx",
      );
    }).toList();
    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 16, right: 16),
      child: AnimatedCrossFade(
        duration: Duration(milliseconds: 300),
        crossFadeState: this.accountModel.synced
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SyncProgressDialog(
                    progressColor: Colors.white,
                    closeOnSync: false,
                  ),
                ),
              ],
            ),
          ],
        ),
        secondChild: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    context.l10n.reverse_swap_waiting_channels,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            ...rows
          ],
        ),
      ),
    );
  }
}
