import 'package:breez/bloc/user_profile/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:fixnum/fixnum.dart';


class AmountFormField extends TextFormField {
  final Currency currency;
  final Int64 maxAmount;
  final Int64 maxPaymentAmount;  

  AmountFormField({    
    this.maxPaymentAmount,
    this.currency,
    this.maxAmount,
    TextEditingController controller,
    Key key,
    String initialValue,
    FocusNode focusNode,
    InputDecoration decoration: const InputDecoration(),
    TextStyle style,
    TextAlign textAlign: TextAlign.start,
    int maxLines: 1,
    int maxLength,
    ValueChanged<String> onFieldSubmitted,
    FormFieldSetter<String> onSaved,
    bool enabled,    
  }) : super(
            keyboardType: TextInputType.number,
            decoration: decoration,
            style: style,
            enabled: enabled,
            controller: controller,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            onFieldSubmitted: onFieldSubmitted,
            onSaved: onSaved);

  @override
  FormFieldValidator<String> get validator {
    return (value) {
      if (value.isEmpty) {
        return "Please enter the amount in " + currency.displayName;
      }
      Int64 intAmount = currency.parse(value);
      if (intAmount <= 0) {
        return "Invalid amount";
      }

      if (maxAmount != null && intAmount > maxAmount) {
        return "Not enough funds";
      } 

      if (maxPaymentAmount != null && intAmount > maxPaymentAmount) {
        return 'Payment exceeds the limit (${currency.format(maxPaymentAmount)})';
      }     
    };
  }
}
