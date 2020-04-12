class AddFundVendorModel {
  final String name;
  final String shortName;
  final String icon;
  final String route;
  final bool isAllowed;
  final bool enabled;
  final bool requireActiveChannel;

  AddFundVendorModel(this.name, this.icon, this.route,
      {this.isAllowed = true,
      this.enabled = true,
      this.requireActiveChannel = false,
      this.shortName});

  AddFundVendorModel copyWith({bool isAllowed}) {
    return AddFundVendorModel(this.name, this.icon, this.route,
        isAllowed: isAllowed ?? this.isAllowed, enabled: this.enabled);
  }
}
