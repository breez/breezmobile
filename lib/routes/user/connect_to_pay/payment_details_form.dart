import 'dart:math';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class PaymentDetailsForm extends StatefulWidget {
  final AccountModel _account;
  final PaymentSessionState _sessionState;
  final Function(Int64 amount, {String description}) _onSubmitPayementDetails;

  PaymentDetailsForm(this._account, this._sessionState, this._onSubmitPayementDetails);

  @override
  State<StatefulWidget> createState() {
    return new _PaymentDetailsFormState();
  }
}

class _PaymentDetailsFormState extends State<PaymentDetailsForm> {
  TextEditingController _invoiceDescriptionController =
      new TextEditingController();
  TextEditingController _amountController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {   
    return LayoutBuilder(builder: (context, constraints) {      
      return SingleChildScrollView(
        child: Container(
          height: max(constraints.maxHeight, 300.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AmountFormField(
                        validatorFn: widget._account.validateOutgoingPayment,
                        currency: widget._account.currency,
                        controller: _amountController,                        
                        decoration: new InputDecoration(
                            labelText: widget._account.currency.displayName +
                                " Amount"),
                      ),
                      TextFormField(
                        controller: _invoiceDescriptionController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        maxLines: null,
                        maxLength: 90,
                        maxLengthEnforced: true,
                        decoration: new InputDecoration(
                          labelText: "Note (optional)",
                        ),
                        style: theme.FieldTextStyle.textStyle,
                      ),
                      Container(
                        padding: new EdgeInsets.only(top: 36.0),
                        child: new Row(
                          children: <Widget>[
                            new Text("Available:", style: theme.textStyle),
                            new Padding(
                              padding: EdgeInsets.only(left: 3.0),
                              child: new Text(
                                  widget._account.currency
                                      .format(widget._account.balance),
                                  style: theme.textStyle),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                        padding: const EdgeInsets.only(bottom: 36.0),
                        child: SubmitButton(
                            widget._sessionState.paymentFulfilled
                                ? "Close"
                                : "Pay", () {
                          if (widget._sessionState.paymentFulfilled) {
                            Navigator.pop(context);
                          } else {
                            if (_formKey.currentState.validate()) {
                              Int64 satoshies = widget._account.currency
                                  .parse(_amountController.text);
                              widget._onSubmitPayementDetails(satoshies,
                                  description:
                                      _invoiceDescriptionController.text);
                            }
                          }
                        }),
                      )
                    ,
              ]),
        ),
      );
    });
  }
}
