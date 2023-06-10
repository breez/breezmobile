import 'dart:async';

import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class MarketplaceBloc {
  final _vendorController = BehaviorSubject<List<VendorModel>>();
  Stream<List<VendorModel>> get vendorsStream => _vendorController.stream;

  bool isVendorToggle = true;

  MarketplaceBloc() {
    loadVendors();
  }

  Future loadVendors() async {
    String jsonVendors = await rootBundle.loadString('src/json/vendors.json');
    // _vendorController.add(vendorListFromJson(jsonVendors));

    // To display and hide Snort
    List<VendorModel> vendorList = vendorListFromJson(jsonVendors);
    if (isVendorToggle) {
      vendorList.removeWhere((element) => element.displayName == "Snort");
      _vendorController.add(vendorList);
    } else {
      _vendorController.add(vendorListFromJson(jsonVendors));
    }
    _vendorController.value;
  }

  close() {
    _vendorController.close();
  }
}
