import 'dart:async';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_actions.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ReverseSwapBloc with AsyncActionsHandler {
  static const NTFN_TITLE = "Action Required";
  static const NTFN_BODY =
      "Please open Breez to complete your requested transaction.";

  final StreamController<InProgressReverseSwaps> _swapsInProgressController =
      BehaviorSubject<InProgressReverseSwaps>();
  Stream<InProgressReverseSwaps> get swapInProgressStream =>
      _swapsInProgressController.stream;

  final StreamController<void> _broadcastTxStreamController =
      StreamController<void>.broadcast();
  Stream<void> get broadcastTxStream => _broadcastTxStreamController.stream;

  final Stream<PaymentsModel> _paymentsStream;
  final Stream<BreezUserModel> _userStream;
  BreezBridge _breezLib;
  BreezUserModel _currentUser;
  int refreshInProgressIndex = 0;
  Notifications _notificationsService;

  ReverseSwapBloc(this._paymentsStream, this._userStream) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    _notificationsService = injector.notifications;

    registerAsyncHandlers({
      NewReverseSwap: _newReverseSwap,
      PayReverseSwap: _payReverseSwap,
      GetClaimFeeEstimates: _getFeeClaimEstimates,
      FetchInProgressSwap: _fetchInProgressSwap,
      GetReverseSwapPolicy: _reverseSwapPolicy,
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
    _userStream.listen((u) => _currentUser = u);
    listenActions();
    _refreshInProgressSwaps();
    _listenPushNotification();
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

  Future _reverseSwapPolicy(GetReverseSwapPolicy action) async {
    action.resolve(await _breezLib.getReverseSwapPolicy().then((policy) {
      return ReverseSwapPolicy(policy);
    }));
  }

  Future _newReverseSwap(NewReverseSwap action) async {
    action.resolve(await _breezLib
        .newReverseSwap(action.address, action.amount)
        .then((hash) {
      return _breezLib.fetchReverseSwap(hash).then((resp) {
        return ReverseSwapDetails(hash, resp);
      });
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

    action.resolve(await _breezLib
        .payReverseSwap(
            action.swap.hash, _currentUser.token ?? "", NTFN_TITLE, NTFN_BODY)
        .then((_) {
      Future.any([
        _breezLib.waitPayment(action.swap.paymentRequest),
        _paymentsStream
            .where((payments) =>
                payments.nonFilteredItems.length > 0 &&
                payments.nonFilteredItems[0].paymentHash == action.swap.hash)
            .first
      ]).then((_) => onComplete()).catchError((err) {
        onComplete(error: "Failed to execute payment.");
      });

      return resultCompletor.future;
    }));
  }

  void _listenPushNotification() {
    _notificationsService.notifications
        .where((message) =>
            message["title"] == NTFN_TITLE && message["body"] == NTFN_BODY)
        .listen((message) {
      _broadcastTxStreamController.add(null);
    });
  }
}
