import 'dart:async';

import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class MarketplaceBloc {
  final _vendorController = BehaviorSubject<List<VendorModel>>();
  Stream<List<VendorModel>> get vendorsStream => _vendorController.stream;

  MarketplaceBloc() {
    loadVendors();
  }

  Future loadVendors() async {
    String jsonVendors = await rootBundle.loadString('src/json/vendors.json');
    _vendorController.add(vendorListFromJson(jsonVendors));
  }

  close() {
    _vendorController.close();
  }
}
