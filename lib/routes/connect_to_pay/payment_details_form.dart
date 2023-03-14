import 'dart:math';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/amount_form_field.dart';
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class PaymentDetailsForm extends StatefulWidget {
  final AccountModel _account;
  final PaymentSessionState _sessionState;
  final Function(Int64 amount, {String description}) _onSubmitPaymentDetails;

  const PaymentDetailsForm(
    this._account,
    this._sessionState,
    this._onSubmitPaymentDetails,
  );

  @override
  State<StatefulWidget> createState() {
    return _PaymentDetailsFormState();
  }
}

class _PaymentDetailsFormState extends State<PaymentDetailsForm> {
  final _invoiceDescriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _amountFocusNode = FocusNode();

  double _maxHeight = 0.0;
  KeyboardDoneAction _doneAction;

  @override
  void initState() {
    super.initState();
    _doneAction = KeyboardDoneAction([_amountFocusNode]);
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double bottomBarHeight = 96.0;
    const double formMinHeight = 250.0;

    final texts = context.texts();

    return LayoutBuilder(builder: (context, constraints) {
      _maxHeight = max(_maxHeight, constraints.maxHeight);
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: max(
                formMinHeight,
                constraints.maxHeight - bottomBarHeight,
              ),
              width: constraints.maxWidth,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AmountFormField(
                        context: context,
                        texts: texts,
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
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: InputDecoration(
                          labelText: texts.connect_to_pay_payment_detail_note,
                        ),
                        style: theme.FieldTextStyle.textStyle,
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 36.0),
                        child: Row(
                          children: [
                            Text(
                              texts.connect_to_pay_payment_available,
                              style: theme.textStyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text(
                                widget._account.currency.format(
                                  widget._account.balance,
                                ),
                                style: theme.textStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 36.0),
              child: SubmitButton(
                widget._sessionState.paymentFulfilled
                    ? texts.connect_to_pay_payment_action_close
                    : texts.connect_to_pay_payment_action_pay,
                () {
                  if (widget._sessionState.paymentFulfilled) {
                    Navigator.pop(context);
                  } else {
                    if (_formKey.currentState.validate()) {
                      widget._onSubmitPaymentDetails(
                        widget._account.currency.parse(
                          _amountController.text,
                        ),
                        description: _invoiceDescriptionController.text,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
