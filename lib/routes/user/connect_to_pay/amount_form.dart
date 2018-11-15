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
  TextEditingController _descriptionController = new TextEditingController();
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
          children: <Widget>[
            Positioned(
                child: Form(
                    key: _formKey,
                    child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: AmountFormField(
                              maxPaymentAmount: widget._account.maxPaymentAmount,
                              currency: widget._account.currency,
                              controller: _amountController,
                              maxAmount: widget._account.balance,
                              decoration: InputDecoration(labelText: widget._account.currency.displayName + " Amount"),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 16.0,),
                            child: Text("Available: ${widget._account.currency.format(widget._account.balance)}",
                                style: theme.textStyle),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 16.0,),
                            child: TextFormField(
                              controller: _descriptionController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              maxLines: null,
                              maxLength: 90,
                              maxLengthEnforced: true,
                              decoration: InputDecoration(
                                labelText: "Description (Optional)",
                              ),
                              style: theme.transactionTitleStyle,
                            ),
                          ),
                        ]
                    ))),
          ],
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 48.0),
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
