import 'package:breez/services/injector.dart';
import 'package:sqflite/sqflite.dart';

Future<void> fromVersion1ToVersion2(Database db) async {
  await db.execute(
    """
    ALTER TABLE sale_payments ADD COLUMN paid_date INTEGER
    """,
  );

  final breez = ServiceInjector().breezBridge;
  final payments = await breez.getPayments();

  for (final payment in payments.paymentsList) {
    final date = payment.creationTimestamp.toInt() * 1000;
    final hash = payment.paymentHash;
    await db.execute(
      """
      UPDATE sale_payments SET paid_date = $date WHERE payment_hash = "$hash"
      """,
    );
  }
}
