import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class AmountForm extends StatefulWidget {
  final AccountModel _account;
  final PaymentSessionState _sessionState;
  final Function(Int64 amount) _onSubmitAmount;

  AmountForm(this._account, this._sessionState, this._onSubmitAmount);

  @override
  State<StatefulWidget> createState() {
    return new _AmountFormState();
  }
}

class _AmountFormState extends State<AmountForm> {
  TextEditingController _amountController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }  

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(child: Container(height: 120.0)),
            Positioned(
                child: Form(
              key: _formKey,
              child: AmountFormField(
                maxPaymentAmount: widget._account.maxPaymentAmount,
                currency: widget._account.currency,
                controller: _amountController,
                maxAmount: widget._account.balance,
                decoration: new InputDecoration(labelText: widget._account.currency.displayName + " Amount"),
              ),
            )),
            Positioned(
                top: 50.0,
                left: 0.0,
                child: Container(
                  padding: new EdgeInsets.only(top: 36.0),
                  child: new Row(
                    children: <Widget>[
                      new Text("Available:", style: theme.textStyle),
                      new Padding(
                        padding: EdgeInsets.only(left: 3.0),
                        child: new Text(widget._account.currency.format(widget._account.balance), style: theme.textStyle),
                      )
                    ],
                  ),
                ))
          ],
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 56.0),
                child: SubmitButton(widget._sessionState.paymentFulfilled ? "Close" : "Pay", () {
                  if (widget._sessionState.paymentFulfilled) {
                    Navigator.pop(context);
                  } else {
                    if (_formKey.currentState.validate()) {
                      Int64 satoshies = widget._account.currency.parse(_amountController.text);
                      widget._onSubmitAmount(satoshies);
                    }
                  }
                }),
              )
            ],
          ),
        )
      ],
    );
  }
}
