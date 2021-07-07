import 'package:breez/bloc/user_profile/currency.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parse sat', () {
    test('small number should be parsed correctly', () {
      final parsed = Currency.SAT.parse('1');
      expect(parsed, Int64(1));
    });

    test('big number should be parsed correctly', () {
      final parsed = Currency.SAT.parse('123456789');
      expect(parsed, Int64(123456789));
    });

    test('number with space should be parsed correctly', () {
      final parsed = Currency.SAT.parse('123 456 789');
      expect(parsed, Int64(123456789));
    });

    test('number with non breaking space should be parsed correctly', () {
      final parsed = Currency.SAT.parse('123 456 789');
      expect(parsed, Int64(123456789));
    });
  });
}
