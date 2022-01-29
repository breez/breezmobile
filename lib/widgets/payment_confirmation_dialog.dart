import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/utils/build_context.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class PaymentConfirmationDialog extends StatelessWidget {
  final AccountBloc accountBloc;
  final PaymentRequestModel invoice;
  final Int64 _amountToPay;
  final String _amountToPayStr;
  final Function() _onCancel;
  final Function(SendPayment payment) _onPaymentApproved;
  final double minHeight;

  const PaymentConfirmationDialog(
    this.accountBloc,
    this.invoice,
    this._amountToPay,
    this._amountToPayStr,
    this._onCancel,
    this._onPaymentApproved,
    this.minHeight,
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        width: context.mediaQuerySize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: _buildConfirmationDialog(context),
        ),
      ),
    );
  }

  List<Widget> _buildConfirmationDialog(BuildContext context) {
    return [
      _buildTitle(context),
      _buildContent(context),
      _buildActions(context),
    ];
  }

  Container _buildTitle(BuildContext context) {
    return Container(
      height: 64.0,
      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      child: Text(
        context.l10n.payment_confirmation_dialog_title,
        style: context.dialogTheme.titleTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    var l10n = context.l10n;
    DialogTheme dialogTheme = context.dialogTheme;

    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Container(
          width: context.mediaQuerySize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.payment_confirmation_dialog_confirmation,
                style: dialogTheme.contentTextStyle,
                textAlign: TextAlign.center,
              ),
              AutoSizeText.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: _amountToPayStr,
                      style: dialogTheme.contentTextStyle.copyWith(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: l10n.payment_confirmation_dialog_confirmation_end,
                    )
                  ],
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
                style: dialogTheme.contentTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildActions(BuildContext context) {
    var l10n = context.l10n;
    TextTheme primaryTextTheme = context.primaryTextTheme;

    List<Widget> children = [
      TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed))
              return Colors.transparent;
            return null; // Defer to the widget's default.
          }),
        ),
        child: Text(
          l10n.payment_confirmation_dialog_action_no,
          style: primaryTextTheme.button,
        ),
        onPressed: () => _onCancel(),
      ),
      TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed))
              return Colors.transparent;
            return null; // Defer to the widget's default.
          }),
        ),
        child: Text(
          l10n.payment_confirmation_dialog_action_yes,
          style: primaryTextTheme.button,
        ),
        onPressed: () {
          _onPaymentApproved(SendPayment(PayRequest(
            invoice.rawPayReq,
            _amountToPay,
          )));
        },
      ),
    ];

    return Container(
      height: 64.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: children,
        ),
      ),
    );
  }
}
