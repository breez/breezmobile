import 'package:flutter/material.dart';

class VendorModel {
  final String url;
  final String name;
  final String logo;

  VendorModel(this.url, this.name, {this.logo});
}

class VendorTheme {
  final Color iconBgColor;
  final Color iconFgColor;
  final Color textColor;

  VendorTheme({this.iconBgColor,this.iconFgColor,this.textColor});

  VendorTheme copyWith({ Color iconBgColor, Color iconFgColor, Color textColor}) {
    return VendorTheme(
        iconBgColor: iconBgColor ?? this.iconBgColor,
        iconFgColor: iconFgColor ?? this.iconFgColor,
        textColor: textColor ?? this.textColor
    );
  }
}