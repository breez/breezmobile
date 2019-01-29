import 'dart:async';
import "package:ini/ini.dart";
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';

class MarketplaceBloc {
  final _vendorController = new BehaviorSubject<VendorModel>();
  Stream<VendorModel> get vendorsStream => _vendorController.stream;

  MarketplaceBloc() {
    // ToDo
    initMarketplace();
    _vendorController.stream.listen((vendor) async {
      if (vendor.vendorsList.isNotEmpty) {
        print(vendor.vendorsList[0].name);
      }
    });
  }

  Future initMarketplace() async {
    Config config = await _readConfig();
    String _marketplacePassword =
        config.get('Application Options', 'marketplacepassword');
    String _apiKey = config.get('Application Options', 'bitrefillapikey');
    List<VendorInfo> vendorList = [
      VendorInfo(
          "https://www.bitrefill.com/embed/lightning/?apiKey=$_apiKey&hideQr",
          "Bitrefill")
    ];
    _vendorController.add(VendorModel(vendorList));

    // ToDo
    //_setMarketplacePassword(_marketplacePassword);
    //_generateURLs(_apiKey);
  }

  Future<Config> _readConfig() async {
    String lines = await rootBundle.loadString('conf/breez.conf');
    return Config.fromString(lines);
  }

  void _setMarketplacePassword(String password) {
    // ToDO set password of marketplace
  }

  void _generateURLs(String apiKey) {
    // ToDO generate vendor urls
  }

  close() {
    _vendorController.close();
  }
}
