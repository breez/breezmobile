import 'dart:math';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/currency_converter_dialog.dart';
import 'package:breez/widgets/form_keyboard_actions.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class PaymentDetailsForm extends StatefulWidget {
  final AccountModel _account;
  final PaymentSessionState _sessionState;
  final Function(Int64 amount, {String description}) _onSubmitPayementDetails;

  PaymentDetailsForm(
      this._account, this._sessionState, this._onSubmitPayementDetails);

  @override
  State<StatefulWidget> createState() {
    return new _PaymentDetailsFormState();
  }
}

class _PaymentDetailsFormState extends State<PaymentDetailsForm> {
  TextEditingController _invoiceDescriptionController =
      new TextEditingController();
  TextEditingController _amountController = new TextEditingController();
  double _maxHeight = 0.0;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _amountFocusNode = FocusNode();
  KeyboardDoneAction _doneAction;

  @override
  void initState() {
    super.initState();
    _doneAction = new KeyboardDoneAction(<FocusNode>[_amountFocusNode]);
  }

  @override 
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double bottomBarHeight = 96.0;
    const double bottomBarTopMargin = 24.0;
    const double formMinHeight = 250.0;
    
    return LayoutBuilder(builder: (context, constraints) {
      print("constraints biggest = " + constraints.biggest.toString());
      _maxHeight = max(_maxHeight, constraints.maxHeight);
      return Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            top: 0.0,        
            bottom: 0.0,    
            child: SingleChildScrollView(
              child: Container(
                height: max(formMinHeight, constraints.maxHeight - bottomBarHeight),                
                width: constraints.maxWidth,            
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AmountFormField(
                        focusNode: _amountFocusNode,
                        validatorFn: widget._account.validateOutgoingPayment,
                        currency: widget._account.currency,
                        controller: _amountController,
                        decoration: new InputDecoration(
                          labelText: widget._account.currency.displayName +
                              " Amount", suffixIcon: IconButton(icon: Icon(Icons.loop, color: theme.BreezColors.white[500],),
                          padding: EdgeInsets.only(top: 21.0),
                          alignment: Alignment.bottomRight,
                          onPressed: () =>
                              showDialog(context: context,
                                  builder: (_) => CurrencyConverterDialog((value) => _amountController.text = value)),),),
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
              ),
            ),
          ),
          Positioned(
            top: _maxHeight - bottomBarHeight + bottomBarTopMargin,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36.0),
              child: SubmitButton(
                  widget._sessionState.paymentFulfilled ? "Close" : "Pay", () {
                if (widget._sessionState.paymentFulfilled) {
                  Navigator.pop(context);
                } else {
                  if (_formKey.currentState.validate()) {
                    Int64 satoshies =
                        widget._account.currency.parse(_amountController.text);
                    widget._onSubmitPayementDetails(satoshies,
                        description: _invoiceDescriptionController.text);
                  }
                }
              }),
            ),
          )
        ],
      );
    });
  }
}
