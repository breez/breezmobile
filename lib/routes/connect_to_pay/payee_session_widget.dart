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
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

import '../sync_progress_dialog.dart';
import 'peers_connection.dart';
import 'session_instructions.dart';

class PayeeSessionWidget extends StatelessWidget {
  final PayeeRemoteSession _currentSession;
  final AccountModel _account;
  final LSPStatus _lspStatus;

  const PayeeSessionWidget(
    this._currentSession,
    this._account,
    this._lspStatus,
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PaymentSessionState>(
      stream: _currentSession.paymentSessionStateStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: Loader());

        final sessionState = snapshot.data;
        final payerAmount = snapshot?.data?.payerData?.amount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SessionInstructions(
              _PayeeInstructions(
                sessionState,
                _account,
              ),
              actions: _getActions(context, sessionState),
              onAction: (action) => _onAction(context, action),
              disabledActions: _getDisabledActions(context, sessionState),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 21.0),
              child: PeersConnection(sessionState),
            ),
            payerAmount == null || _account.maxInboundLiquidity >= payerAmount
                ? const SizedBox()
                : WarningBox(
                    contentPadding: const EdgeInsets.all(8),
                    child: Text(
                      _formatFeeMessage(
                        context,
                        _account,
                        _lspStatus,
                        snapshot.data.payerData.amount,
                      ),
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
          ],
        );
      },
    );
  }

  void _onAction(BuildContext context, String action) {
    final texts = context.texts();
    if (action == texts.connect_to_pay_payee_action_reject) {
      _currentSession.rejectPaymentSink.add(null);
    } else {
      _currentSession.approvePaymentSink.add(null);
    }
  }

  List<String> _getActions(
    BuildContext context,
    PaymentSessionState sessionState,
  ) {
    final texts = context.texts();
    if (_account.synced) {
      final payerData = sessionState.payerData;
      final payeeData = sessionState.payeeData;
      if (payerData.amount != null && payeeData.paymentRequest == null) {
        return [
          texts.connect_to_pay_payee_action_reject,
          texts.connect_to_pay_payee_action_approve,
        ];
      }
    }
    return null;
  }

  List<String> _getDisabledActions(
    BuildContext context,
    PaymentSessionState sessionState,
  ) {
    final texts = context.texts();
    final amount = sessionState.payerData.amount;
    if (amount != null && _account.maxAllowedToReceive < amount) {
      return [
        texts.connect_to_pay_payee_action_approve,
      ];
    }
    return [];
  }

  String _formatFeeMessage(
    BuildContext context,
    AccountModel acc,
    LSPStatus lspStatus,
    int amount,
  ) {
    final texts = context.texts();
    final lsp = lspStatus.currentLSP;
    num feeSats = 0;
    if (amount > acc.maxInboundLiquidity.toInt()) {
      feeSats = (amount * lsp.channelFeePermyriad / 10000);
      if (feeSats < lsp.channelMinimumFeeMsat / 1000) {
        feeSats = lsp.channelMinimumFeeMsat / 1000;
      }
    }
    var intSats = feeSats.toInt();
    if (intSats == 0) {
      return "";
    }
    var feeFiat = acc.fiatCurrency.format(Int64(intSats));
    var formattedSats = Currency.SAT.format(Int64(intSats));
    return texts.connect_to_pay_payee_setup_fee(formattedSats, feeFiat);
  }
}

class _PayeeInstructions extends StatelessWidget {
  final PaymentSessionState _sessionState;
  final AccountModel _account;

  const _PayeeInstructions(
    this._sessionState,
    this._account,
  );

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final defaultTextStyle = DefaultTextStyle.of(context);

    final payerData = _sessionState.payerData;
    final payeeData = _sessionState.payeeData;
    final currency = _account.currency;

    String message = "";
    if (_sessionState.paymentFulfilled) {
      final settledAmount = currency.format(Int64(_sessionState.settledAmount));
      message = texts.connect_to_pay_payee_success_received(settledAmount);
    } else if (payerData.amount == null) {
      final name = payerData.userName;
      return LoadingAnimatedText(
        name != null
            ? texts.connect_to_pay_payee_waiting_with_name(name)
            : texts.connect_to_pay_payee_waiting_no_name,
        textStyle: theme.sessionNotificationStyle,
      );
    } else if (!_account.synced) {
      return LoadingAnimatedText(
        "",
        textElements: [
          TextSpan(
            text: texts.connect_to_pay_payee_waiting_sync,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const SyncProgressDialog(),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          texts.connect_to_pay_payee_waiting_sync_action_close,
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
    } else if (payerData.amount != null && payeeData.paymentRequest == null) {
      final name = payerData.userName;
      final amount = currency.format(Int64(payerData.amount));
      if (_account.fiatCurrency != null) {
        message = texts.connect_to_pay_payee_message_with_fiat(
          name,
          amount,
          _account.fiatCurrency.format(Int64(payerData.amount)),
        );
      } else {
        message = texts.connect_to_pay_payee_message_no_fiat(name, amount);
      }
      if (_account.maxAllowedToReceive < Int64(payerData.amount)) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: theme.sessionNotificationStyle),
            Text(
              texts.connect_to_pay_payee_error_limit_exceeds(
                currency.format(_account.maxAllowedToReceive),
              ),
              style: theme.sessionNotificationStyle.copyWith(
                color: theme.errorColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }
    } else if (payeeData.paymentRequest != null) {
      return LoadingAnimatedText(
        texts.connect_to_pay_payee_process(payerData.userName),
        textStyle: theme.sessionNotificationStyle,
      );
    }
    return Text(
      message,
      style: theme.sessionNotificationStyle,
    );
  }
}
