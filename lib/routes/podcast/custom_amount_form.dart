import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/widgets/sat_amount_form_field_formatter.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomAmountFormField extends TextFormField {
  final List<int> preset;

  CustomAmountFormField({
    Key key,
    FocusNode focusNode,
    TextEditingController controller,
    InputDecoration decoration,
    TextStyle style,
    this.preset,
  }) : super(
          key: key,
          autovalidateMode: AutovalidateMode.disabled,
          focusNode: focusNode,
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: decoration,
          style: style,
          inputFormatters: [
            SatAmountFormFieldFormatter(),
          ],
        );

  @override
  FormFieldValidator<String> get validator {
    return (value) {
      if (value.isEmpty) {
        return "Please enter a custom amount";
      }
      int valueInt = Currency.SAT.parseToInt(value);
      if (valueInt < preset[0]) {
        return "Please enter at least ${preset[0]} sats.";
      }
      return null;
    };
  }
}

class CustomAmountTextEditingController extends TextEditingController {
  CustomAmountTextEditingController(
    int customAmount,
  ) : super() {
    this.text = _initialCustomAmount(customAmount);
  }

  String _initialCustomAmount(int customAmount) {
    final initial = customAmount;
    if (initial == null) {
      return null;
    }
    return Currency.SAT.format(
      Int64(initial),
      includeDisplayName: false,
      includeCurrencySymbol: false,
    );
  }
}
