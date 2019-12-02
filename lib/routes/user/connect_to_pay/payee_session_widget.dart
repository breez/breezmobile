import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/bloc/connect_pay/payee_session.dart';
import 'package:breez/routes/user/connect_to_pay/peers_connection.dart';
import 'package:breez/routes/user/connect_to_pay/session_instructions.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class PayeeSessionWidget extends StatelessWidget {
  final PayeeRemoteSession _currentSession;
  final AccountModel _account;

  PayeeSessionWidget(this._currentSession, this._account);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PaymentSessionState>(
        stream: _currentSession.paymentSessionStateStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Loader());
          }
          PaymentSessionState sessionState = snapshot.data;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SessionInstructions(_PayeeInstructions(sessionState, _account),
                  actions: _getActions(sessionState),
                  onAction: (action) => _onAction(context, action),
                  disabledActions: _getDisabledActions(sessionState)),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0, bottom: 21.0, top: 25.0),
                child: PeersConnection(sessionState),
              ),
            ],
          );
        });
  }

  _onAction(BuildContext context, String action) {
    if (action == "Reject") {
      _currentSession.rejectPaymentSink.add(null);
    } else {
      _currentSession.approvePaymentSink.add(null);
    }
  }

  _getActions(PaymentSessionState sessionState) {
    if (_account.synced) {
      if (sessionState.payerData.amount != null &&
          sessionState.payeeData.paymentRequest == null) {
        return ["Reject", "Approve"];
      }
    }
    return null;
  }

  List<String> _getDisabledActions(PaymentSessionState sessionState) {
    if (sessionState.payerData.amount != null &&
        _account.maxAllowedToReceive < sessionState.payerData.amount) {
      return ["Approve"];
    }
    return [];
  }
}

class _PayeeInstructions extends StatelessWidget {
  final PaymentSessionState _sessionState;
  final AccountModel _account;

  _PayeeInstructions(this._sessionState, this._account);

  @override
  Widget build(BuildContext context) {
    String message = "";
    if (_sessionState.paymentFulfilled) {
      message = "You've successfully got " +
          _account.currency.format(Int64(_sessionState.settledAmount));
    } else if (_sessionState.payerData.amount == null) {
      return LoadingAnimatedText(
          'Waiting for ${_sessionState.payerData.userName ?? "payer"} to enter an amount',
          textStyle: theme.sessionNotificationStyle);
    } else if (!_account.synced) {
      return LoadingAnimatedText('Please wait while Breez is synchronizing');
    } else if (_sessionState.payerData.amount != null &&
        _sessionState.payeeData.paymentRequest == null) {
      message =
          '${_sessionState.payerData.userName} wants to pay you ${_account.currency.format(Int64(_sessionState.payerData.amount))}';
      if (_account.fiatCurrency != null) {
        message = "$message"
            " (${_account.fiatCurrency.format(Int64(_sessionState.payerData.amount))}).";
      }
      if (_account.maxAllowedToReceive <
          Int64(_sessionState.payerData.amount)) {
        return Column(
          children: <Widget>[
            Text(message, style: theme.sessionNotificationStyle),
            Text(
                'This payment exceeds your limit (${_account.currency.format(_account.maxAllowedToReceive)}).',
                style: theme.sessionNotificationWarningStyle
                    .copyWith(color: Theme.of(context).errorColor),
                textAlign: TextAlign.center)
          ],
        );
      }
    } else if (_sessionState.payeeData.paymentRequest != null) {
      return LoadingAnimatedText(
          'Processing ${_sessionState.payerData.userName} payment',
          textStyle: theme.sessionNotificationStyle);
    }
    return Text(message, style: theme.sessionNotificationStyle);
  }
}
