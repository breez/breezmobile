import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentConfirmationDialog extends StatefulWidget {
  final AccountBloc accountBloc;
  final PaymentRequestModel invoice;
  final Int64 _amountToPay;
  final String _amountToPayStr;
  final Function() _onCancel;
  final Function(SendPayment payment) _onPaymentApproved;
  final double minHeight;

  PaymentConfirmationDialog(
      this.accountBloc,
      this.invoice,
      this._amountToPay,
      this._amountToPayStr,
      this._onCancel,
      this._onPaymentApproved,
      this.minHeight);

  @override
  PaymentConfirmationDialogState createState() {
    return PaymentConfirmationDialogState();
  }
}

class PaymentConfirmationDialogState extends State<PaymentConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          constraints: BoxConstraints(minHeight: widget.minHeight),
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: _buildConfirmationDialog())),
    );
  }

  List<Widget> _buildConfirmationDialog() {
    List<Widget> _confirmationDialog = <Widget>[];
    _confirmationDialog.add(_buildTitle());
    _confirmationDialog.add(_buildContent());
    _confirmationDialog.add(_buildActions());
    return _confirmationDialog;
  }

  Container _buildTitle() {
    return Container(
      height: 64.0,
      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      child: Text(
        "Payment Confirmation",
        style: Theme.of(context).dialogTheme.titleTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Are you sure you want to pay',
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                  textAlign: TextAlign.center,
                ),
                AutoSizeText.rich(
                    TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: widget._amountToPayStr,
                          style: Theme.of(context)
                              .dialogTheme
                              .contentTextStyle
                              .copyWith(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                      TextSpan(text: " ?")
                    ]),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).dialogTheme.contentTextStyle),
              ]),
        ),
      ),
    );
  }

  Container _buildActions() {
    List<Widget> children = <Widget>[
      FlatButton(
        child: Text("NO", style: Theme.of(context).primaryTextTheme.button),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () => widget._onCancel(),
      ),
      FlatButton(
        child: Text("YES", style: Theme.of(context).primaryTextTheme.button),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          widget._onPaymentApproved(SendPayment(
              PayRequest(widget.invoice.rawPayReq, widget._amountToPay)));
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
