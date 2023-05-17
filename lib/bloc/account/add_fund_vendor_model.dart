class AddFundVendorModel {
  final String name;
  final String icon;
  final String route;
  final bool isAllowed;
  final bool enabled;
  final bool requireActiveChannel;
  final String? shortName;
  final bool showLSPFee;

  AddFundVendorModel(
    this.name,
    this.icon,
    this.route, {
    this.isAllowed = true,
    this.enabled = true,
    this.requireActiveChannel = false,
    this.shortName,
    this.showLSPFee = false,
  });

  AddFundVendorModel copyWith({
    bool? isAllowed,
  }) {
    return AddFundVendorModel(
      name,
      icon,
      route,
      isAllowed: isAllowed ?? this.isAllowed,
      enabled: enabled,
    );
  }
}
