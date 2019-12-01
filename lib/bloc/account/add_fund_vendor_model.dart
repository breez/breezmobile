class AddFundVendorModel {
  final String name;
  final String icon;
  final String route;
  final bool isAllowed;
  final bool requireActiveChannel;

  AddFundVendorModel(this.name, this.icon, this.route,
      {this.isAllowed = true, this.requireActiveChannel = false});

  AddFundVendorModel copyWith({bool isAllowed}) {
    return AddFundVendorModel(this.name, this.icon, this.route,
        isAllowed: isAllowed ?? this.isAllowed);
  }
}
