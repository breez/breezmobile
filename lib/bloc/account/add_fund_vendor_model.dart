class AddFundVendorModel {
  String name;
  String url;
  bool isAllowed;

  AddFundVendorModel(this.name, this.url, this.isAllowed);

  AddFundVendorModel copyWith({String url, bool isAllowed}) {
    return new AddFundVendorModel(this.name, url = url ?? this.url, isAllowed = isAllowed ?? this.isAllowed);
  }
}
