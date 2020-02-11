import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/bloc/connect_pay/payer_session.dart';
import 'payment_details_form.dart';
import 'peers_connection.dart';
import 'session_instructions.dart';
import 'package:breez/widgets/delay_render.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class PayerSessionWidget extends StatelessWidget {
  final PayerRemoteSession _currentSession;
  final AccountModel _account;

  PayerSessionWidget(this._currentSession, this._account);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PaymentSessionState>(
        stream: _currentSession.paymentSessionStateStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          PaymentSessionState sessionState = snapshot.data;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SessionInstructions(_PayerInstructions(sessionState, _account)),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: PeersConnection(sessionState, onShareInvite: () {
                  _currentSession.sentInvitesSink.add(null);
                }),
              ),
              waitingFormPayee(sessionState)
                  ? Container()
                  : Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
                        child: DelayRender(
                            child: PaymentDetailsForm(
                                _account,
                                sessionState,
                                (amountToPay, {description}) => _currentSession
                                    .paymentDetailsSink
                                    .add(PaymentDetails(
                                        amountToPay, description))),
                            duration: PaymentSessionState
                                .connectionEmulationDuration),
                      ),
                      flex: 1)
            ],
          );
        });
  }

  bool waitingFormPayee(PaymentSessionState sessionState) {
    return !sessionState.payeeData.status.online &&
            sessionState.payerData.amount == null ||
        sessionState.payerData.amount != null;
  }
}

class _PayerInstructions extends StatelessWidget {
  final PaymentSessionState sessionState;
  final AccountModel _account;

  _PayerInstructions(this.sessionState, this._account);

  @override
  Widget build(BuildContext context) {
    var message = "";
    if (sessionState.paymentFulfilled) {
      message = "You've successfully paid " +
          _account.currency.format(Int64(sessionState.payerData.amount));
    } else if (sessionState.payerData.amount == null) {
      if (sessionState.payeeData.status.online) {
        message =
            '${sessionState.payeeData.userName} joined the session.\nPlease enter an amount and tap Pay to proceed.';
      } else if (!sessionState.invitationSent &&
          sessionState.payeeData.userName == null) {
        message =
            "Tap the Share button to share a link with a person that you want to pay. Then, please wait while this person clicks the link and joins the session.";
      } else {
        return LoadingAnimatedText(
            'Waiting for ${sessionState.payeeData.userName ?? "someone"} to join this session',
            textStyle: theme.sessionNotificationStyle);
      }
    } else if (sessionState.payeeData.paymentRequest == null) {
      return LoadingAnimatedText(
          'Waiting for ${sessionState.payeeData.userName} to approve your payment',
          textStyle: theme.sessionNotificationStyle);
    } else {
      message = "Sending payment...";
    }

    return Text(message, style: theme.sessionNotificationStyle);
  }
}
