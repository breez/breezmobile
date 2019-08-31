class AddFundVendorModel {
  String name;
  bool isAllowed;

  AddFundVendorModel(this.name, this.isAllowed);

  AddFundVendorModel copyWith({bool isAllowed}) {
    return new AddFundVendorModel(this.name, isAllowed = isAllowed ?? this.isAllowed);
  }
}
