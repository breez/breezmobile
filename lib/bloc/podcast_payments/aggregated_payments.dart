import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../logger.dart';

class AggregatedPayments {
  static const String AGGREGATED_PAYMENTS_KEY = "AGGREGATED_PAYMENTS_KEY";

  Map<String, double> aggregatedAmount = Map<String, double>();
  SharedPreferences sharedPreferences;

  AggregatedPayments(SharedPreferences sharedPreferences) {
    this.sharedPreferences = sharedPreferences;
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
    this.aggregatedAmount[destination] =
        (this.aggregatedAmount[destination] ?? 0) + amount;
    await this
        .sharedPreferences
        .setString(AGGREGATED_PAYMENTS_KEY, json.encode(this.aggregatedAmount));
    return this.aggregatedAmount[destination];
  }

  double getAmount(String destination) {
    return this.aggregatedAmount[destination] ?? 0;
  }
}
