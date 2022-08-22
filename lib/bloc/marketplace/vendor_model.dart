import 'dart:convert';
import 'dart:core';

List<VendorModel> vendorListFromJson(String str) {
  List<VendorModel> vendorList = [];
  Map.from(json.decode(str))
      .map((k, v) =>
          MapEntry<String, VendorModel>(k, VendorModel.fromJson(k, v)))
      .forEach((k, v) => vendorList.add(v));
  return vendorList;
}

class VendorModel {
  final String url;
  final String id;
  final String displayName;
  final bool onlyShowLogo;
  final String endpointURI;
  final String responseID;

  const VendorModel(
    this.id,
    this.url,
    this.displayName, {
    this.onlyShowLogo,
    this.endpointURI,
    this.responseID,
  });

  String get logo => 'src/icon/vendors/${id.toLowerCase()}_logo_lg.png';

  VendorModel.fromJson(String id, Map<String, dynamic> json)
      : this(
          id,
          json["url"],
          json["displayName"] ?? id,
          endpointURI: json["endpointURI"],
          onlyShowLogo: json["onlyShowLogo"] ?? true,
          responseID: json["endpointURI"] != null && json["responseID"] != null
              ? json["responseID"]
              : "lnurl_auth",
        );
}
