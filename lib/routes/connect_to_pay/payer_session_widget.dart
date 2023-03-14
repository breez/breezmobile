import 'dart:async';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/bloc/connect_pay/payer_session.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/delay_render.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez/widgets/sync_loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:rxdart/subjects.dart';

import 'payment_details_form.dart';
import 'peers_connection.dart';
import 'session_instructions.dart';

class PayerSessionWidget extends StatelessWidget {
  final PayerRemoteSession _currentSession;
  final AccountModel _account;

  const PayerSessionWidget(
    this._currentSession,
    this._account,
  );

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
          children: [
            SessionInstructions(
              _PayerInstructions(sessionState, _account),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: PeersConnection(sessionState, onShareInvite: () {
                _currentSession.sentInvitesSink.add(null);
              }),
            ),
            waitingFormPayee(sessionState)
                ? Container()
                : _waitingFormPayee(sessionState),
          ],
        );
      },
    );
  }

  Widget _waitingFormPayee(PaymentSessionState sessionState) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
        child: DelayRender(
          duration: PaymentSessionState.connectionEmulationDuration,
          child: PaymentDetailsForm(
            _account,
            sessionState,
            (amountToPay, {description}) =>
                _currentSession.paymentDetailsSink.add(
              PaymentDetails(amountToPay, description),
            ),
          ),
        ),
      ),
    );
  }

  bool waitingFormPayee(PaymentSessionState sessionState) {
    final online = sessionState.payeeData.status.online;
    final amount = sessionState.payerData.amount;
    return !online && amount == null || amount != null;
  }
}

class _PayerInstructions extends StatelessWidget {
  final PaymentSessionState sessionState;
  final AccountModel _account;

  const _PayerInstructions(
    this.sessionState,
    this._account,
  );

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    final payeeData = sessionState.payeeData;
    final payerData = sessionState.payerData;

    var message = "";
    if (sessionState.paymentFulfilled) {
      message = texts.connect_to_pay_payer_success(
        _account.currency.format(Int64(payerData.amount)),
      );
    } else if (payerData.amount == null) {
      if (payeeData.status.online) {
        message = texts.connect_to_pay_payer_enter_amount(payeeData.userName);
      } else if (!sessionState.invitationSent && payeeData.userName == null) {
        message = texts.connect_to_pay_payer_share_link;
      } else {
        final name = payeeData.userName;
        return LoadingAnimatedText(
          name != null
              ? texts.connect_to_pay_payer_waiting_join_with_name(name)
              : texts.connect_to_pay_payer_waiting_join_no_name,
          textStyle: theme.sessionNotificationStyle,
        );
      }
    } else if (payeeData.paymentRequest == null) {
      final name = payeeData.userName;
      return LoadingAnimatedText(
        name != null
            ? texts.connect_to_pay_payer_waiting_approve_with_name(name)
            : texts.connect_to_pay_payer_waiting_approve_no_name,
        textStyle: theme.sessionNotificationStyle,
      );
    } else {
      final progress = payerData.unconfirmedChannelsProgress;
      if (progress != null && progress < 1.0) {
        return WaitingChannelsSyncUI(
          progress: progress,
          onClose: () => Navigator.of(context).pop(),
        );
      }
      message = texts.connect_to_pay_payer_sending;
    }

    return Text(
      message,
      style: theme.sessionNotificationStyle,
    );
  }
}

class WaitingChannelsSyncUI extends StatefulWidget {
  final double progress;
  final Function onClose;

  const WaitingChannelsSyncUI({
    Key key,
    this.progress,
    this.onClose,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WaitingChannelsSyncUIState();
  }
}

class WaitingChannelsSyncUIState extends State<WaitingChannelsSyncUI> {
  ModalRoute dialogRoute;
  StreamController<double> progress = BehaviorSubject.seeded(0);

  @override
  void didUpdateWidget(WaitingChannelsSyncUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      progress.add(widget.progress);
    }
  }

  @override
  void dispose() {
    progress?.close();
    if (dialogRoute?.isActive == true) {
      Navigator.of(context).removeRoute(dialogRoute);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final defaultTextStyle = DefaultTextStyle.of(context);

    return LoadingAnimatedText(
      "",
      textElements: [
        TextSpan(
          text: texts.connect_to_pay_payer_wait_sync,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              showDialog(
                useRootNavigator: false,
                context: context,
                builder: (context) => AlertDialog(
                  content: StreamBuilder<Object>(
                    stream: progress.stream,
                    builder: (context, snapshot) {
                      return SyncProgressLoader(
                        value: snapshot.data ?? 0,
                        title: texts.connect_to_pay_payer_synchronizing,
                      );
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        texts.connect_to_pay_payer_action_close,
                        style: themeData.primaryTextTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              );
            },
          style: defaultTextStyle.style,
        ),
      ],
    );
  }
}
