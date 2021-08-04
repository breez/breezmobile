import 'package:breez/bloc/user_profile/currency.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fixnum/fixnum.dart';

class SatAmountFormFieldFormatter extends TextInputFormatter {
  final RegExp _pattern = RegExp(r'[^\d*]');

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final raw = newValue.text.replaceAll(_pattern, '');
    if (raw.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    var value;
    try {
      value = Int64.parseInt(raw.length > 18 ? raw.substring(0, 18) : raw);
    } catch (ignored) {
      value = Int64(0);
    }

    final formatted = Currency.SAT.format(
      value,
      includeDisplayName: false,
      includeCurrencySymbol: false,
    );

    var diff = formatted.length - oldValue.text.length;
    var newOffset = newValue.selection.start;
    if (formatted != oldValue.text) {
      if (diff > 1) {
        newOffset += 1;
      }
      if (diff < -1) {
        newOffset -= 1;
      }
    } else {
      newOffset = oldValue.selection.start;
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}
