class VendorModel {
  final List<VendorInfo> vendorsList;

  VendorModel(this.vendorsList);
}

class VendorInfo {
  final String url;
  final String name;
  final String logo;

  VendorInfo(this.url, this.name, {this.logo});
}
