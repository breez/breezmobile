import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

import 'lnurl_webview.dart';
import 'vendor_webview.dart';

class VendorRow extends StatelessWidget {
  final AccountBloc accountBloc;
  final VendorModel _vendor;

  VendorRow(this.accountBloc, this._vendor);

  @override
  Widget build(BuildContext context) {
    Color _vendorFgColor =
        theme.vendorTheme[_vendor.id.toLowerCase()]?.iconFgColor ??
            Colors.transparent;
    Color _vendorBgColor =
        theme.vendorTheme[_vendor.id.toLowerCase()]?.iconBgColor ??
            Colors.white;
    Color _vendorTextColor =
        theme.vendorTheme[_vendor.id.toLowerCase()]?.textColor ?? Colors.black;

    final _vendorLogo = _vendor.logo != null
        ? Image(
            image: AssetImage(_vendor.logo),
            height: 48,
            width: _vendor.onlyShowLogo ? 196 : null,
            color: _vendorFgColor,
            colorBlendMode: BlendMode.srcATop,
          )
        : Container();

    final _vendorCard = GestureDetector(
        onTap: () {
          Navigator.push(context, FadeInRoute(
            builder: (_) {
              if (_vendor.id == "lnmarkets" || _vendor.id == "Kollider") {
                var lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);
                return LNURLWebViewPage(
                  accountBloc: accountBloc,
                  vendorModel: _vendor,
                  lnurlBloc: lnurlBloc,
                  endpointURI: _vendor.id == "lnmarkets"
                      ? Uri.https("api.lnmarkets.com", "v1/lnurl/auth")
                      : Uri.https(
                          "api.kollider.xyz", "v1/auth/external/lnurl_auth"),
                  responseID:
                      _vendor.id == "lnmarkets" ? "lnurl" : "lnurl_auth",
                );
              }
              return VendorWebViewPage(
                  accountBloc, _vendor.url, _vendor.displayName);
            },
          ));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 8.0),
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              color: _vendorBgColor,
              boxShadow: [
                BoxShadow(
                  color: theme.BreezColors.grey[600],
                  blurRadius: 8.0,
                )
              ],
              border: Border.all(
                  color: _vendorBgColor == Colors.white
                      ? Theme.of(context).highlightColor
                      : Colors.transparent,
                  style: BorderStyle.solid,
                  width: 1.0),
              borderRadius: BorderRadius.circular(14.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildLogo(_vendorLogo, _vendorTextColor),
          ),
        ));

    return _vendorCard;
  }

  List<Widget> _buildLogo(Widget _vendorLogo, _vendorTextColor) {
    if (_vendor.onlyShowLogo) {
      return <Widget>[_vendorLogo];
    } else {
      return <Widget>[
        _vendorLogo,
        Padding(padding: EdgeInsets.only(left: 8.0)),
        Text(_vendor.displayName,
            style: theme.vendorTitleStyle.copyWith(color: _vendorTextColor)),
      ];
    }
  }
}
