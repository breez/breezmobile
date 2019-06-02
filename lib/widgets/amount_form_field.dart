import 'package:breez/bloc/user_profile/currency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:fixnum/fixnum.dart';


class AmountFormField extends TextFormField {
  final Currency currency;  
  final String Function(Int64 amount) validatorFn;

  AmountFormField({        
    this.currency,    
    this.validatorFn,
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
            keyboardType: defaultTargetPlatform == TargetPlatform.android ? TextInputType.number : TextInputType.text,
            decoration: decoration,
            style: style,
            enabled: enabled,
            controller: controller,
            inputFormatters: currency != Currency.SAT ? [WhitelistingTextInputFormatter(RegExp(r'\d+\.?\d*'))] : [WhitelistingTextInputFormatter.digitsOnly],
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
      String msg;
      if (validatorFn != null) {
        msg = validatorFn(intAmount);
      }   
      return msg;   
    };
  }
}
