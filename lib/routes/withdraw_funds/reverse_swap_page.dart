import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_actions.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/routes/home/widgets/payments_list/dialog/tx_widget.dart';
import 'package:breez/routes/sync_progress_dialog.dart';
import 'package:breez/routes/withdraw_funds/reverse_swap_confirmation.dart';
import 'package:breez/routes/withdraw_funds/swap_in_progress.dart';
import 'package:breez/routes/withdraw_funds/withdraw_funds_page.dart';
import 'package:breez/utils/exceptions.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

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
    final themeData = Theme.of(context);
    final texts = context.texts();

    final reverseSwapBloc = AppBlocsProvider.of<ReverseSwapBloc>(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (context, accSnapshot) {
        final accountModel = accSnapshot.data;

        return Scaffold(
          appBar: !_policyCompleter.isCompleted || _loadingError != null
              ? AppBar(
                  leading: backBtn.BackButton(
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Text(texts.reverse_swap_title),
                )
              : null,
          body: FutureBuilder<Object>(
            future: _policyCompleter.future,
            builder: (context, snapshot) {
              if (snapshot.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                    child: Text(
                      texts.reverse_swap_upstream_generic_error_message(
                        extractExceptionMessage(
                          snapshot.error,
                          clearTrailingDot: true,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              if (snapshot.data == null) {
                return Center(
                  child: Loader(
                    color: themeData.primaryColor.withOpacity(0.5),
                  ),
                );
              }
              final policy = snapshot.data as ReverseSwapPolicy;

              return StreamBuilder<InProgressReverseSwaps>(
                stream: reverseSwapBloc.swapInProgressStream,
                builder: (context, snapshot) {
                  final swapInProgress = snapshot.data;
                  if (swapInProgress != null && swapInProgress.isNotEmpty) {
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
    final texts = context.texts();

    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        WithdrawFundsPage(
          title: texts.reverse_swap_title,
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
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
            });
          },
        ),
        currentSwap == null
            ? const SizedBox()
            : ReverseSwapConfirmation(
                swap: currentSwap,
                bloc: reverseSwapBloc,
                onFeeConfirmed: _onFeeConfirmed,
                onPrevious: () => _pageController
                    .previousPage(
                      duration: const Duration(milliseconds: 250),
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
      await promptError(context, null, Text(extractExceptionMessage(err)));
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
    final texts = context.texts();

    final rows = unconfirmedChannels.map((chainPoint) {
      final tx = chainPoint.split(":")[0];
      return TxWidget(
        txLabel: texts.reverse_swap_funding_transaction,
        txID: tx,
        txURL: "https://blockstream.info/tx/$tx",
      );
    }).toList();
    return Padding(
      padding: const EdgeInsets.only(top: 48, left: 16, right: 16),
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        crossFadeState: accountModel.synced
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
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
                    texts.reverse_swap_waiting_channels,
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
