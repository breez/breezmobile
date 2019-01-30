import 'package:flutter/material.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/theme_data.dart' as theme;

class VendorRow extends StatelessWidget {
  final VendorModel _vendor;

  VendorRow(this._vendor);

  @override
  Widget build(BuildContext context) {
    final _vendorLogo = _vendor.logo != null
        ? Image(
            image: AssetImage(_vendor.logo),
            height: 55.0,
            width: 55.0,
          )
        : Container();

    final _vendorCard = Container(
      margin: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
      constraints: BoxConstraints.expand(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _vendorLogo,
          Text(_vendor.name, style: theme.vendorTitleStyle),
        ],
      ),
    );

    return _vendorCard;
  }
}
