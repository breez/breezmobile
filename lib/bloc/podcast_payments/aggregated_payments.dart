import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../logger.dart';

class AggregatedPayments {
  static const String AGGREGATED_PAYMENTS_KEY = "AGGREGATED_PAYMENTS_KEY";

  Map<String, double> aggregatedAmount = <String, double>{};
  SharedPreferences sharedPreferences;

  AggregatedPayments(this.sharedPreferences) {
    var persistedAggregation =
        sharedPreferences.getString(AGGREGATED_PAYMENTS_KEY);
    if (persistedAggregation != null) {
      try {
        Map<String, dynamic> amounts = json.decode(persistedAggregation);
        aggregatedAmount = amounts.cast<String, double>();
        log.info("loaded persisted aggregation: $aggregatedAmount");
      } catch (err) {
        log.severe("failed to load persisted aggregation", err);
      }
    }
  }

  Future<double> addAmount(String destination, double amount) async {
    aggregatedAmount[destination] =
        (aggregatedAmount[destination] ?? 0) + amount;
    await sharedPreferences
        .setString(AGGREGATED_PAYMENTS_KEY, json.encode(aggregatedAmount));
    return aggregatedAmount[destination];
  }

  double getAmount(String destination) {
    return aggregatedAmount[destination] ?? 0;
  }
}
