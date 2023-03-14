import 'dart:async';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/bloc/payment_options/payment_options_actions.dart';
import 'package:breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_actions.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/services/notifications.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fixnum/fixnum.dart';
import 'package:rxdart/rxdart.dart';

class ReverseSwapBloc with AsyncActionsHandler {
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
  final PaymentOptionsBloc _paymentOptionsBloc;

  ReverseSwapBloc(
    this._paymentsStream,
    this._userStream,
    this._paymentOptionsBloc,
  ) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    _notificationsService = injector.notifications;

    registerAsyncHandlers({
      NewReverseSwap: _newReverseSwap,
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
        .debounceTime(const Duration(milliseconds: 500))
        .listen((_) {
          _refreshInProgressSwaps();
        });
    _userStream.listen((u) => _currentUser = u);
    listenActions();
    _refreshInProgressSwaps();
    _listenPushNotification();
  }

  Future _refreshInProgressSwaps() async {
    var currentRefresh = refreshInProgressIndex;
    var status = await _fetchInProgressSwap(FetchInProgressSwap());

    // only push to the stream if we didn't get another refresh request.
    if (currentRefresh == refreshInProgressIndex) {
      _swapsInProgressController.add(status);
    }
  }

  Future _getFeeClaimEstimates(GetClaimFeeEstimates action) async {
    var estimates =
        await _breezLib.reverseSwapClaimFeeEstimates(action.claimAddress);
    action.resolve(ReverseSwapClaimFeeEstimates(estimates));
  }

  Future _fetchInProgressSwap(FetchInProgressSwap action) async {
    // We will have to see if there are any in flight payments
    ReverseSwapPaymentStatuses payments = await _breezLib.reverseSwapPayments();
    InProgressReverseSwaps swap;
    // If there are any in flight payments we display the txid to the user.
    if (payments.paymentsStatus.isNotEmpty) {
      swap = InProgressReverseSwaps(payments);
    } else {
      swap = InProgressReverseSwaps(null);
    }
    _swapsInProgressController.add(swap);
    action.resolve(swap);
    return swap;
  }

  Future _reverseSwapPolicy(GetReverseSwapPolicy action) async {
    var maxAmount = await _breezLib.maxReverseSwapAmount();
    action.resolve(await _breezLib.getReverseSwapPolicy().then((policy) {
      return ReverseSwapPolicy(policy, Int64(maxAmount));
    }));
  }

  Future _newReverseSwap(NewReverseSwap action) async {
    var hash = await _breezLib.newReverseSwap(
      action.address,
      action.amount,
      action.feesHash,
    );
    log.info('reverseSwap hash:');
    log.info(hash);

    var reverseSwap = await _breezLib.fetchReverseSwap(hash);
    log.info('reverseSwap data:');
    log.info(reverseSwap);

    await _breezLib.setReverseSwapClaimFee(
      hash,
      reverseSwap.onchainAmount - action.received,
    );

    var resultCompleter = Completer();
    onComplete({String error}) {
      if (resultCompleter.isCompleted) {
        return;
      }
      if (error != null) {
        resultCompleter.completeError(error);
      } else {
        resultCompleter.complete();
      }
    }

    final fee = await _calculateFee(action.amount.toInt());
    Future.any([
      _breezLib.payReverseSwap(
        hash,
        _currentUser.token ?? "",
        _notificationTitle(),
        _notificationBody(),
        fee,
      ),
      _paymentsStream
          .where((payments) => payments.nonFilteredItems
              .any((element) => element.paymentHash == hash))
          .first
    ]).then((_) => onComplete()).catchError((err) {
      onComplete(
        error: PaymentError(
          PayRequest(reverseSwap.invoice, reverseSwap.lnAmount),
          err.toString(),
          null,
        ).toDisplayMessage(_currentUser.currency),
      );
    });

    action.resolve(await resultCompleter.future);
    action.resolve(null);
  }

  void _listenPushNotification() {
    _notificationsService.notifications
        .where((message) =>
            message["title"] == _notificationTitle() &&
            message["body"] == _notificationBody())
        .listen((message) {
      _broadcastTxStreamController.add(null);
    });
  }

  String _notificationTitle() =>
      getSystemAppLocalizations().reverse_swap_notification_title;

  String _notificationBody() =>
      getSystemAppLocalizations().reverse_swap_notification_body;

  Future<int> _calculateFee(int amount) async {
    final calculateFee = CalculateFee(amount);
    _paymentOptionsBloc.actionsSink.add(calculateFee);
    return await calculateFee.future;
  }
}
