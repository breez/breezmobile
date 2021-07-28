import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../logger.dart';

class AggregatedPayments {
  static const String AGGREGATED_PAYMENTS_KEY = "AGGREGATED_PAYMENTS_KEY";
  static const String DESTINATIONS_BACKOFF_KEY = "DESTINATIONS_BACKOFF_KEY";

  Map<String, double> aggregatedAmount = Map<String, double>();
  Map<String, int> destinationBakoff = Map<String, int>();
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

    var persistedBackoffs =
        sharedPreferences.getString(DESTINATIONS_BACKOFF_KEY);
    if (persistedBackoffs != null) {
      try {
        Map<String, dynamic> backoffs = json.decode(persistedBackoffs);
        destinationBakoff = backoffs.cast<String, int>();
        log.info("loaded persisted backoff values: $persistedBackoffs");
      } catch (err) {
        log.severe("failed to load persisted backoff values", err);
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

  Future setDestinationBackoff(String destination, int minutesDelay) async {
    this.destinationBakoff[destination] = minutesDelay;
    await this.sharedPreferences.setString(
        DESTINATIONS_BACKOFF_KEY, json.encode(this.destinationBakoff));
  }

  int getDestinationBackoff(String destination) {
    return this.destinationBakoff[destination] ?? 0;
  }
}
