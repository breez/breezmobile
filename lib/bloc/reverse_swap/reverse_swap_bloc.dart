import 'dart:async';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_actions.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/routes/user/withdraw_funds/swap_in_progress.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ReverseSwapBloc with AsyncActionsHandler {
  final StreamController<InProgressReverseSwaps> _swapsInProgressController =
      BehaviorSubject<InProgressReverseSwaps>();
  Stream<InProgressReverseSwaps> get swapInProgressStream =>
      _swapsInProgressController.stream;

  final Stream<PaymentsModel> _paymentsStream;
  BreezBridge _breezLib;
  int refreshInProgressIndex = 0;

  ReverseSwapBloc(this._paymentsStream) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;

    registerAsyncHandlers({
      NewReverseSwap: _newReverseSwap,
      PayReverseSwap: _payReverseSwap,
      GetClaimFeeEstimates: _getFeeClaimEstimates,
      FetchInProgressSwap: _fetchInProgressSwap,
    });

    // refresh reverse swaps in progress stream    
    _breezLib.notificationStream
        .where((n) {
          return [
            NotificationEvent_NotificationType.REVERSE_SWAP_CLAIM_CONFIRMED,
            NotificationEvent_NotificationType.REVERSE_SWAP_CLAIM_FAILED,
            NotificationEvent_NotificationType.REVERSE_SWAP_CLAIM_STARTED,
            NotificationEvent_NotificationType.REVERSE_SWAP_CLAIM_SUCCEEDED,
            NotificationEvent_NotificationType.ACCOUNT_CHANGED
          ].contains(n.type);
        })
        .transform(DebounceStreamTransformer(Duration(milliseconds: 500)))
        .listen((_) {
          _refreshInProgressSwaps();
        });

    listenActions();
    _refreshInProgressSwaps();
  }

  Future _refreshInProgressSwaps() async { 
    var currentRefresh = this.refreshInProgressIndex;
    var status = await _fetchInProgressSwap(FetchInProgressSwap());

    // only push to the stream if we didn't get another refresh request.
    if (currentRefresh == this.refreshInProgressIndex) {
      _swapsInProgressController.add(status);
    }
  }

  Future _getFeeClaimEstimates(GetClaimFeeEstimates action) async {
    var estimates =
        await _breezLib.reverseSwapClaimFeeEstimates(action.claimAddress);
    action.resolve(ReverseSwapClaimFeeEstimates(estimates));
  }

  Future _fetchInProgressSwap(FetchInProgressSwap action) async {    
    String unconfirmedTx =
        await _breezLib.unconfirmedReverseSwapClaimTransaction();
    ReverseSwapPaymentStatuses payments = await _breezLib.reverseSwapPayments();
    InProgressReverseSwaps swap = InProgressReverseSwaps(null, null);
    if (unconfirmedTx.isNotEmpty || payments.paymentsStatus.length > 0) {         
      swap = InProgressReverseSwaps(payments, unconfirmedTx);
    }
    _swapsInProgressController.add(swap);    
    action.resolve(swap);
    return swap;
  }

  Future _newReverseSwap(NewReverseSwap action) async {
    action.resolve(await _breezLib
        .newReverseSwap(action.address, action.amount)
        .then((hash) {
      return _breezLib
          .fetchReverseSwap(hash)
          .then((resp) => ReverseSwapInfo(hash, resp));
    }));
  }

  Future _payReverseSwap(PayReverseSwap action) async {
    var resultCompletor = Completer();
    StreamSubscription<PaymentsModel> paymentsSubscription;
    var onComplete = ({String error}) {
      if (resultCompletor.isCompleted) {
        return;
      }
      if (error != null) {
        resultCompletor.completeError(error);
      } else {
        resultCompletor.complete();
      }
      paymentsSubscription.cancel();
    };

    await _breezLib.setReverseSwapClaimFee(action.swap.hash, action.claimFee);

    action.resolve(await _breezLib.payReverseSwap(action.swap.hash).then((_) {
      Future.any([
        _breezLib.waitPayment(action.swap.paymentRequest),
        _paymentsStream
            .where((payments) =>
                payments.nonFilteredItems.length > 0 &&
                payments.nonFilteredItems[0].paymentHash == action.swap.hash)
            .first
      ]).then((_) => onComplete()).catchError((err) {
        onComplete(error: "failed to initiate payment");
      });

      return resultCompletor.future;
    }));
  }
}
