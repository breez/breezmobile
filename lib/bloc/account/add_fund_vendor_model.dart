import 'package:breez/l10n/text_uri.dart';

class AddFundVendorModel {
  final String name;
  final String shortName;
  final String icon;
  final String route;
  final bool isAllowed;
  final bool enabled;
  final bool requireActiveChannel;
  final bool showLSPFee;
  final TextUri textUri;

  AddFundVendorModel(
    this.name,
    this.icon,
    this.route, {
    this.isAllowed = true,
    this.enabled = true,
    this.requireActiveChannel = false,
    this.shortName,
    this.showLSPFee = false,
    this.textUri,
  });

  AddFundVendorModel copyWith({
    bool isAllowed,
  }) {
    return AddFundVendorModel(
      this.name,
      this.icon,
      this.route,
      isAllowed: isAllowed ?? this.isAllowed,
      enabled: this.enabled,
      textUri: this.textUri,
    );
  }
}
