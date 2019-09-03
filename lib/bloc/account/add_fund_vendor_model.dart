class AddFundVendorModel {
  final String name;
  final String icon;
  final String route;
  final bool isAllowed;  

  AddFundVendorModel(this.name, this.icon, this.route, {this.isAllowed = true});

  AddFundVendorModel copyWith({bool isAllowed}) {
    return new AddFundVendorModel(this.name, this.icon, this.route, isAllowed: isAllowed ?? this.isAllowed);
  }
}
