import 'dart:async';

import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import 'nostr_settings.dart';

class MarketplaceBloc {
  final _vendorController = BehaviorSubject<List<VendorModel>>();
  Stream<List<VendorModel>> get vendorsStream => _vendorController.stream;

  bool isSnortToggle;

  final _nostrSettingsController = BehaviorSubject<NostrSettings>();
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
    _nostrSettingsController.add(NostrSettings.start());
  }

  _listenNostrSettings() async {
    nostrSettingsStream.listen((settings) async {
      isSnortToggle = settings.showSnort;
      await loadVendors();
    });
  }

  Future loadVendors() async {
    String jsonVendors = await rootBundle.loadString('src/json/vendors.json');

    // To display and hide Snort
    List<VendorModel> vendorList = vendorListFromJson(jsonVendors);
    if (isSnortToggle) {
      vendorList.removeWhere((element) => element.displayName == "Snort");
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
