class VendorModel {
  final List<VendorInfo> vendorsList;

  VendorModel(this.vendorsList);
}

class VendorInfo {
  final String _url;
  final String _name;
  final String logo;

  String get url => _url;
  String get name => _name;

  VendorInfo(this._url, this._name, {this.logo});
}
