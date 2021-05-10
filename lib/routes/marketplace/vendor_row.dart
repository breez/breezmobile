import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

import 'lnmarkets_webview.dart';
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
              var lnurlBloc = AppBlocsProvider.of<LNUrlBloc>(context);
              if (_vendor.id == "lnmarkets") {
                return LNMarketsWebViewPage(
                    accountBloc: accountBloc,
                    lnMarketModel: _vendor,
                    lnurlBloc: lnurlBloc);
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
              gradient: (_vendor.id == "lnmarkets")
                  ? LinearGradient(
                      colors: [
                        Color.fromRGBO(0, 113, 189, 1),
                        Color.fromRGBO(4, 81, 161, 1),
                        Color.fromRGBO(6, 56, 145, 1),
                        Color.fromRGBO(9, 31, 130, 1)
                      ],
                      stops: [0.0, 0.3, 0.6, 0.8],
                      begin: Alignment(-1, 1),
                      end: Alignment(1, -1),
                    )
                  : null,
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
        Padding(padding: EdgeInsets.only(left: 4.0)),
        Text(_vendor.displayName,
            style: theme.vendorTitleStyle.copyWith(color: _vendorTextColor)),
      ];
    }
  }
}
