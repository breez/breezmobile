import 'package:breez/services/injector.dart';
import 'package:sqflite/sqflite.dart';

Future<void> fromVersion1ToVersion2(Database db) async {
  await db.execute(
    """
    ALTER TABLE sale ADD COLUMN date INTEGER
    """,
  );

  final breez = ServiceInjector().breezBridge;
  final payments = await breez.getPayments();

  for (final payment in payments.paymentsList) {
    final date = payment.creationTimestamp.toInt() * 1000;

    final salePayment = await db.query(
      "sale_payments",
      where: "payment_hash = ?",
      whereArgs: [payment.paymentHash],
    );

    if (salePayment.length > 0) {
      final saleId = salePayment.first["sale_id"];
      await db.execute(
        """
        UPDATE sale SET date = $date WHERE id = $saleId  
        """,
      );
    }
  }
}
