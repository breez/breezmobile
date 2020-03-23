import 'dart:math';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class PaymentDetailsForm extends StatefulWidget {
  final AccountModel _account;
  final PaymentSessionState _sessionState;
  final Function(Int64 amount, {String description}) _onSubmitPaymentDetails;

  PaymentDetailsForm(
      this._account, this._sessionState, this._onSubmitPaymentDetails);

  @override
  State<StatefulWidget> createState() {
    return _PaymentDetailsFormState();
  }
}

class _PaymentDetailsFormState extends State<PaymentDetailsForm> {
  TextEditingController _invoiceDescriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  double _maxHeight = 0.0;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _amountFocusNode = FocusNode();
  KeyboardDoneAction _doneAction;

  @override
  void initState() {
    super.initState();
    _doneAction = KeyboardDoneAction(<FocusNode>[_amountFocusNode]);
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double bottomBarHeight = 96.0;
    //const double bottomBarTopMargin = 24.0;
    const double formMinHeight = 250.0;

    return LayoutBuilder(builder: (context, constraints) {
      print("constraints biggest = " + constraints.biggest.toString());
      _maxHeight = max(_maxHeight, constraints.maxHeight);
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: max(formMinHeight, constraints.maxHeight - bottomBarHeight),
            width: constraints.maxWidth,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AmountFormField(
                      context: context,
                      accountModel: widget._account,
                      focusNode: _amountFocusNode,
                      controller: _amountController,
                      validatorFn: widget._account.validateOutgoingPayment,
                    ),
                    TextFormField(
                      controller: _invoiceDescriptionController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      maxLines: null,
                      maxLength: 90,
                      maxLengthEnforced: true,
                      decoration: InputDecoration(
                        labelText: "Note (optional)",
                      ),
                      style: theme.FieldTextStyle.textStyle,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 36.0),
                      child: Row(
                        children: <Widget>[
                          Text("Available:", style: theme.textStyle),
                          Padding(
                            padding: EdgeInsets.only(left: 3.0),
                            child: Text(
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 36.0),
            child: SubmitButton(
                widget._sessionState.paymentFulfilled ? "Close" : "Pay", () {
              if (widget._sessionState.paymentFulfilled) {
                Navigator.pop(context);
              } else {
                if (_formKey.currentState.validate()) {
                  Int64 satoshies =
                      widget._account.currency.parse(_amountController.text);
                  widget._onSubmitPaymentDetails(satoshies,
                      description: _invoiceDescriptionController.text);
                }
              }
            }),
          )
        ],
      );
    });
  }
}
