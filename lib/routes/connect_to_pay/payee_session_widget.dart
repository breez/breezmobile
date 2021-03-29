import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/bloc/connect_pay/payee_session.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez/widgets/warning_box.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../sync_progress_dialog.dart';
import 'peers_connection.dart';
import 'session_instructions.dart';

class PayeeSessionWidget extends StatelessWidget {
  final PayeeRemoteSession _currentSession;
  final AccountModel _account;
  final LSPStatus _lspStatus;

  PayeeSessionWidget(this._currentSession, this._account, this._lspStatus);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PaymentSessionState>(
        stream: _currentSession.paymentSessionStateStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Loader());
          }
          PaymentSessionState sessionState = snapshot.data;
          var payerAmount = snapshot?.data?.payerData?.amount;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SessionInstructions(
                  _PayeeInstructions(
                    sessionState,
                    _account,
                  ),
                  actions: _getActions(sessionState),
                  onAction: (action) => _onAction(context, action),
                  disabledActions: _getDisabledActions(sessionState)),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0, bottom: 21.0, top: 25.0),
                child: PeersConnection(sessionState),
              ),
              payerAmount == null || _account.maxInboundLiquidity >= payerAmount
                  ? SizedBox()
                  : WarningBox(
                      contentPadding: EdgeInsets.all(8),
                      child: Text(
                          _formatFeeMessage(_account, _lspStatus,
                              snapshot.data.payerData.amount),
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center),
                    )
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
      return LoadingAnimatedText("", textElements: <TextSpan>[
        TextSpan(
            text: "Please wait while Breez is ",
            style: DefaultTextStyle.of(context).style),
        TextSpan(
            text: "synchronizing",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showDialog(
                    useRootNavigator: false,
                    context: context,
                    builder: (context) => AlertDialog(
                          content: SyncProgressDialog(),
                          actions: <Widget>[
                            TextButton(
                              onPressed: (() {
                                Navigator.pop(context);
                              }),
                              child: Text("CLOSE",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .button),
                            )
                          ],
                        ));
              },
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(decoration: TextDecoration.underline)),
      ]);
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
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message, style: theme.sessionNotificationStyle),
            Text(
                'This payment exceeds your limit (${_account.currency.format(_account.maxAllowedToReceive)}).',
                style: theme.sessionNotificationStyle
                    .copyWith(color: theme.errorColor),
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

_formatFeeMessage(AccountModel acc, LSPStatus lspStatus, int amount) {
  num feeSats = 0;
  if (amount > acc.maxInboundLiquidity.toInt()) {
    feeSats = (amount * lspStatus.currentLSP.channelFeePermyriad / 10000);
  }
  var intSats = feeSats.toInt();
  if (intSats == 0) {
    return "";
  }
  var feeFiat = acc.fiatCurrency.format(Int64(intSats));
  var formattedSats = Currency.SAT.format(Int64(intSats));
  return 'A setup fee of $formattedSats ($feeFiat) is applied to this payment.';
}
