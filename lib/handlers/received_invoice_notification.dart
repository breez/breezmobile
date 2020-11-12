import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/admin_login_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/payment_request_dialog.dart' as paymentRequest;
import 'package:flutter/material.dart';

class InvoiceNotificationsHandler {
  final BuildContext _context;
  final UserProfileBloc _userProfileBloc;
  final AccountBloc _accountBloc;
  final Stream<PaymentRequestModel> _receivedInvoicesStream;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldController;

  ModalRoute _loaderRoute;
  bool _handlingRequest = false;

  InvoiceNotificationsHandler(
      this._context,
      this._userProfileBloc,
      this._accountBloc,
      this._receivedInvoicesStream,
      this.firstPaymentItemKey,
      this.scrollController,
      this.scaffoldController) {
    _listenPaymentRequests();
    _listenCompletedPayments();
  }

  _listenCompletedPayments() {
    _accountBloc.completedPaymentsStream.listen((completedPayment) {
      _handlingRequest = false;
    }, onError: (err) {
      _handlingRequest = false;
    });
  }

  _listenPaymentRequests() {
    // show payment request dialog for decoded requests
    _receivedInvoicesStream
        .where((payreq) => payreq != null && !_handlingRequest)
        .listen((payreq) async {
      var account = await _accountBloc.accountStream.first;
      if (!account.connected) {
        return;
      }
      if (!payreq.loaded) {
        _setLoading(true);
        return;
      }
      var user = await _userProfileBloc.userStream.firstWhere((u) => u != null);
      _setLoading(false);
      _handlingRequest = true;

      // Close the drawer before showing payment request dialog
      if (scaffoldController.currentState.isDrawerOpen) {
        Navigator.pop(_context);
      }

      protectAdminAction(_context, user, () {
        return showDialog(
            useRootNavigator: false,
            context: _context,
            barrierDismissible: false,
            builder: (_) => paymentRequest.PaymentRequestDialog(_context,
                _accountBloc, payreq, firstPaymentItemKey, scrollController));
      });
    }).onError((error) {
      _setLoading(false);
      _handlingRequest = false;
      if (error is PaymentRequestError) {
        showFlushbar(_context, message: error.message);
      }
    });
  }

  _setLoading(bool visible) {
    if (visible && _loaderRoute == null) {
      _loaderRoute = createLoaderRoute(_context);
      Navigator.of(_context).push(_loaderRoute);
      return;
    }

    if (!visible && _loaderRoute != null) {
      Navigator.removeRoute(_context, _loaderRoute);
      _loaderRoute = null;
    }
  }
}
