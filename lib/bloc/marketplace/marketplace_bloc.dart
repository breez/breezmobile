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
  }

  Future initMarketplace() async {
    Config config = await _readConfig();
    String marketplacePassword = config.get('Application Options', 'marketplacepassword');
    String apiKey = config.get('Application Options', 'apikey');
    // ToDo
    _setMarketplacePassword(marketplacePassword);
    _generateURLs(apiKey);
  }

  Future<Config> _readConfig() async {
    String lines = await rootBundle.loadString('conf/breez.conf');
    return Config.fromString(lines);
  }

  void _setMarketplacePassword(String password){
    // ToDO set password of marketplace
  }

  void _generateURLs(String apiKey){
    // ToDO generate vendor urls
  }
}
