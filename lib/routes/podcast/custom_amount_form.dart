import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/widgets/sat_amount_form_field_formatter.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

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
    final texts = getSystemAppLocalizations();
    return (value) {
      if (value.isEmpty) {
        return texts.podcast_boost_custom_amount_error_empty;
      }
      int valueInt = Currency.SAT.parseToInt(value);
      if (valueInt < preset[0]) {
        return texts.podcast_boost_custom_amount_error_too_few(preset[0]);
      }
      return null;
    };
  }
}

class CustomAmountTextEditingController extends TextEditingController {
  CustomAmountTextEditingController({
    int customAmount,
  }) : super() {
    text = _initialCustomAmount(customAmount);
  }

  String _initialCustomAmount(int customAmount) {
    if (customAmount == null) {
      return null;
    }
    return Currency.SAT.format(
      Int64(customAmount),
      includeDisplayName: false,
      includeCurrencySymbol: false,
    );
  }
}
