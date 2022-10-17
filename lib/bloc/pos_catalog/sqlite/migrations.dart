import 'package:clovrlabs_wallet/services/injector.dart';
import 'package:sqflite/sqflite.dart';

Future<void> fromVersion1ToVersion2(Database db) async {
  await db.execute(
    """
    ALTER TABLE sale_payments ADD COLUMN paid_date INTEGER
    """,
  );

  final ElenPayWallet= ServiceInjector().breezBridge;
  final payments = await ElenPayWallet.getPayments();

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
