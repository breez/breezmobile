import 'dart:async';
import "package:ini/ini.dart";
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';

class MarketplaceBloc {
  final _vendorController = new BehaviorSubject<List<VendorModel>>();
  Stream<List<VendorModel>> get vendorsStream => _vendorController.stream;

  MarketplaceBloc() {
    print("hello");
    _vendorController.stream.listen((vendor) async {
        print(vendor[0].name);
    });
    initMarketplace();
  }

  Future initMarketplace() async {
    Config config = await _readConfig();
    String _marketplacePassword =
        config.get('Application Options', 'marketplacepassword');
    String _apiKey = config.get('Application Options', 'bitrefillapikey');
    List<VendorModel> vendorList = [
      VendorModel(
          "https://www.bitrefill.com/embed/lightning/?apiKey=$_apiKey&hideQr",
          "Bitrefill")
    ];
    _vendorController.sink.add(vendorList);
    _vendorController.add(vendorList);

  }

  Future<Config> _readConfig() async {
    String lines = await rootBundle.loadString('conf/breez.conf');
    return Config.fromString(lines);
  }

  close() {
    _vendorController.close();
  }
}
