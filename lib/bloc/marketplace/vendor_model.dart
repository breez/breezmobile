import 'package:flutter/material.dart';

class VendorModel {
  final String url;
  final String name;
  final String logo;
  final Color bgColor;

  VendorModel(this.url, this.name, {this.logo, this.bgColor});
}
