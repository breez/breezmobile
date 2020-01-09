import 'dart:async';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_actions.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';

class ReverseSwapBloc with AsyncActionsHandler {
  final Stream<PaymentsModel> _paymentsStream;
  BreezBridge _breezLib;

  ReverseSwapBloc(this._paymentsStream) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;

    registerAsyncHandlers({
      NewReverseSwap: _newReverseSwap,
      PayReverseSwap: _payReverseSwap,
      GetClaimFeeEstimates: _getFeeClaimEstimates,
    });
    listenActions();
  }

  Future _getFeeClaimEstimates(GetClaimFeeEstimates action) async {
    var estimates =
        await _breezLib.reverseSwapClaimFeeEstimates(action.claimAddress);
    action.resolve(ReverseSwapClaimFeeEstimates(estimates));
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
