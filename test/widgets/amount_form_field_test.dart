import 'package:breez/widgets/amount_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

TextSelection selection(int offset) => TextSelection.collapsed(offset: offset);

TextEditingValue textEditingValue(String text, {int offset}) =>
    TextEditingValue(text: text, selection: selection(offset ?? text.length));

void main() {
  group('SatAmountFormFieldFormatter', () {
    test('should format empty correctly', () {
      final formatter = SatAmountFormFieldFormatter();
      final oldValue = textEditingValue('');
      final newValue = textEditingValue('');
      final formatted = formatter.formatEditUpdate(oldValue, newValue);
      expect(formatted, textEditingValue(''));
    });

    test('should format invalid chars correctly', () {
      final formatter = SatAmountFormFieldFormatter();
      final oldValue = textEditingValue('');
      final newValue = textEditingValue('invalid characters');
      final formatted = formatter.formatEditUpdate(oldValue, newValue);
      expect(formatted, textEditingValue(''));
    });

    test('should format small numbers correctly', () {
      final formatter = SatAmountFormFieldFormatter();
      final oldValue = textEditingValue('12');
      final newValue = textEditingValue('123');
      final formatted = formatter.formatEditUpdate(oldValue, newValue);
      expect(formatted, textEditingValue('123', offset: 3));
    });

    test('should format big numbers correctly', () {
      final formatter = SatAmountFormFieldFormatter();
      final oldValue = textEditingValue('123 456 78');
      final newValue = textEditingValue('123 456 789');
      final formatted = formatter.formatEditUpdate(oldValue, newValue);
      expect(formatted, textEditingValue('123 456 789', offset: 11));
    });

    test('should remove invalid chars and format correctly', () {
      final formatter = SatAmountFormFieldFormatter();
      final oldValue = textEditingValue('12');
      final newValue = textEditingValue('12#');
      final formatted = formatter.formatEditUpdate(oldValue, newValue);
      expect(formatted, textEditingValue('12', offset: 2));
    });

    test('should remove dot and format correctly', () {
      final formatter = SatAmountFormFieldFormatter();
      final oldValue = textEditingValue('1');
      final newValue = textEditingValue('1.');
      final formatted = formatter.formatEditUpdate(oldValue, newValue);
      expect(formatted, textEditingValue('1', offset: 1));
    });

    test('delete should behavior and format properly', () {
      final formatter = SatAmountFormFieldFormatter();
      final oldValue = textEditingValue('123');
      final newValue = textEditingValue('12');
      final formatted = formatter.formatEditUpdate(oldValue, newValue);
      expect(formatted, textEditingValue('12', offset: 2));
    });

    test('delete on space should behavior and format properly', () {
      final formatter = SatAmountFormFieldFormatter();
      final oldValue = textEditingValue('1 234');
      final newValue = textEditingValue('123');
      final formatted = formatter.formatEditUpdate(oldValue, newValue);
      expect(formatted, textEditingValue('123', offset: 2));
    });

    test('insert with space should behavior and format properly', () {
      final formatter = SatAmountFormFieldFormatter();
      final oldValue = textEditingValue('1 234');
      final newValue = textEditingValue('12 345');
      final formatted = formatter.formatEditUpdate(oldValue, newValue);
      expect(formatted, textEditingValue('12 345', offset: 6));
    });

    test('insert should keep 18 digits to avoid overflow', () {
      final formatter = SatAmountFormFieldFormatter();
      final bigNumber = '123 456 789 123 456 789';
      final oldValue = textEditingValue(bigNumber);
      final newValue = textEditingValue('$bigNumber 123');
      final formatted = formatter.formatEditUpdate(oldValue, newValue);
      expect(formatted, textEditingValue(bigNumber, offset: 23));
    });

    test('insert in the middle should keep the cursor on the right place', () {
      final formatter = SatAmountFormFieldFormatter();
      final oldValue = textEditingValue('13', offset: 2);
      final newValue = textEditingValue('123', offset: 2);
      final formatted = formatter.formatEditUpdate(oldValue, newValue);
      expect(formatted, textEditingValue('123', offset: 2));
    });

    test('delete in the middle should keep the cursor on the right place', () {
      final formatter = SatAmountFormFieldFormatter();
      final oldValue = textEditingValue('123', offset: 3);
      final newValue = textEditingValue('13', offset: 1);
      final formatted = formatter.formatEditUpdate(oldValue, newValue);
      expect(formatted, textEditingValue('13', offset: 1));
    });
  });
}
