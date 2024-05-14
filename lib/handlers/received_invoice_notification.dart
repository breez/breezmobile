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
  }

  _listenPaymentRequests() {
    // show payment request dialog for decoded requests
    _receivedInvoicesStream.where((payreq) => payreq != null && !_handlingRequest).listen((payreq) async {
      try {
        final navigator = Navigator.of(_context);
        var account = await _accountBloc.accountStream.firstWhere((a) => !a.initial, orElse: () => null);
        if (account == null) {
          return;
        }
        if (!payreq.loaded) {
          _setLoading(true);
          return;
        }
        _setLoading(false);
        _handlingRequest = true;

        // Close the drawer before showing payment request dialog
        if (scaffoldController.currentState.isDrawerOpen) {
          navigator.pop();
        }

        await _userProfileBloc.userStream.firstWhere((u) => u != null).then(
          (user) async {
            await protectAdminAction(
              _context,
              user,
              () {
                return showDialog(
                  useRootNavigator: false,
                  context: _context,
                  barrierDismissible: false,
                  builder: (_) => paymentRequest.PaymentRequestDialog(
                    _context,
                    _accountBloc,
                    payreq,
                    firstPaymentItemKey,
                    scrollController,
                    () {
                      _handlingRequest = false;
                    },
                  ),
                );
              },
            );
          },
        );
      } catch (error) {
        _onError(error);
      }
    }).onError((error) {
      _onError(error);
    });
  }

  void _onError(error) {
    _setLoading(false);
    if (error is PaymentRequestError) {
      showFlushbar(_context, message: error.message);
    }
    _handlingRequest = false;
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
