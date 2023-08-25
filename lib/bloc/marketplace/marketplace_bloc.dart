import 'dart:async';
import 'dart:convert';

import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/bloc/nostr/nostr_model.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarketplaceBloc {
  final _vendorController = BehaviorSubject<List<VendorModel>>();
  Stream<List<VendorModel>> get vendorsStream => _vendorController.stream;

  bool _isSnortToggled;
  SharedPreferences pref;

  final _nostrSettingsController =
      BehaviorSubject<NostrSettings>.seeded(NostrSettings.initial());
  Stream<NostrSettings> get nostrSettingsStream =>
      _nostrSettingsController.stream;
  Sink<NostrSettings> get nostrSettingsSettingsSink =>
      _nostrSettingsController.sink;

  MarketplaceBloc() {
    loadVendors();

    _listenNostrSettings();
    _initNostrSettings();
  }

  _initNostrSettings() async {
    pref = await SharedPreferences.getInstance();

    var nostrSettings =
        pref.getString(NostrSettings.NOSTR_SETTINGS_PREFERENCES_KEY);

    if (nostrSettings != null) {
      Map<String, dynamic> settings = json.decode(nostrSettings);
      _nostrSettingsController.add(NostrSettings.fromJson(settings));
    }
  }

  _listenNostrSettings() async {
    pref = await SharedPreferences.getInstance();
    nostrSettingsStream.listen((settings) async {
      _isSnortToggled = settings.enableNostr;
      pref.setString(NostrSettings.NOSTR_SETTINGS_PREFERENCES_KEY,
          json.encode(settings.toJson()));
      await loadVendors();
    });
  }

  Future loadVendors() async {
    String jsonVendors = await rootBundle.loadString('src/json/vendors.json');

    // To display and hide Snort
    List<VendorModel> vendorList = vendorListFromJson(jsonVendors);
    if (_isSnortToggled) {
      vendorList.removeWhere((element) => element.displayName == "Snort");
      vendorList.removeWhere((element) => element.displayName == "Primal");
      _vendorController.add(vendorList);
    } else {
      _vendorController.add(vendorListFromJson(jsonVendors));
    }
    _vendorController.value;
  }

  close() {
    _vendorController.close();
    _nostrSettingsController.close();
  }
}
