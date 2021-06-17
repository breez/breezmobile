import 'package:breez/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

CurrencyFormatter make() => CurrencyFormatter();

void main() {
  test('CurrencyFormatter formatter should format values properly', () {
    final formatted = make().formatter.format(1.23);
    expect(formatted, '1.23');
  });

  test('CurrencyFormatter formatter should format zeros properly', () {
    final formatted = make().formatter.format(0);
    expect(formatted, '0');
  });

  test('CurrencyFormatter formatter should format negatives properly', () {
    final formatted = make().formatter.format(-4.56);
    expect(formatted, '-4.56');
  });

  test('CurrencyFormatter formatter should format big numbers properly', () {
    final formatted = make().formatter.format(12345678.90);
    expect(formatted, '12 345 678.9');
  });
}
