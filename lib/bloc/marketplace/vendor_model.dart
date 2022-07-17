class VendorModel {
  final String url;
  final String id;
  final String displayName;
  final String logo;
  final bool onlyShowLogo;
  final String endpointURI;
  final String responseID;

  const VendorModel(
    this.url,
    this.id,
    this.displayName, {
    this.logo,
    this.onlyShowLogo,
    this.endpointURI,
    this.responseID,
  });
}
