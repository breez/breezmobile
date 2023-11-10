import 'dart:math';

import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpendCodeFormField extends TextFormField {
  final String Function(String) validatorFn;
  final BreezTranslations texts;

  SpendCodeFormField({
    this.validatorFn,
    this.texts,
    BuildContext context,
    TextEditingController controller,
    InputDecoration decoration = const InputDecoration(),
    bool enabled,
    Key key,
    FocusNode focusNode,
    int maxLength = 6,
    int maxLines = 1,
    ValueChanged<String> onFieldSubmitted,
    FormFieldSetter<String> onSaved,
    ValueChanged<String> onChanged,
    TextStyle style,
  }) : super(
          autocorrect: false,
          controller: controller,
          decoration: InputDecoration(
            labelText: texts.satscard_spend_code_label,
          ),
          enabled: enabled,
          enableSuggestions: false,
          focusNode: focusNode,
          inputFormatters: [SpendCodeFieldFormatter()],
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
            decimal: false,
          ),
          maxLength: maxLength,
          maxLines: maxLines,
          obscureText: true,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          onSaved: onSaved,
          style: style,
        );

  @override
  FormFieldValidator<String> get validator {
    return (value) {
      if (value.length != 6) {
        return texts.satscard_spend_code_wrong_hint;
      } else {
        try {
          if (validatorFn != null) {
            return validatorFn(value);
          }
        } catch (_) {}

        return null;
      }
    };
  }
}

class SpendCodeFieldFormatter extends TextInputFormatter {
  final RegExp _pattern = RegExp(r'\D');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    const maxLength = 6;

    var text = newValue.text.replaceAll(_pattern, "");
    var offset = min(min(newValue.selection.start, maxLength), text.length);
    if (text.isEmpty) {
      return newValue.copyWith(
        text: "",
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else if (text.length > maxLength) {
      text = text.substring(0, maxLength);
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
