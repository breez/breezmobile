import 'package:flutter/material.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez/routes/user/marketplace/vendor_webview.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/bloc/account/account_bloc.dart';

class VendorRow extends StatelessWidget {
  final AccountBloc accountBloc;
  final VendorModel _vendor;

  VendorRow(this.accountBloc,this._vendor);

  @override
  Widget build(BuildContext context) {
    Color _vendorFgColor = Colors.transparent;
    if (_vendor.name.toLowerCase() == "bitrefill") {
      _vendorFgColor = theme.bitrefill.iconFgColor != null ? theme.bitrefill.iconFgColor : Colors.transparent;
    } else if (_vendor.name.toLowerCase() == "ln.pizza") {
      _vendorFgColor = theme.lnpizza.iconFgColor != null ? theme.lnpizza.iconFgColor : Colors.transparent;
    }

    Color _vendorBgColor = Colors.white;
    if (_vendor.name.toLowerCase() == "bitrefill") {
      _vendorBgColor = theme.bitrefill.iconBgColor != null ? theme.bitrefill.iconBgColor : Colors.transparent;
    } else if (_vendor.name.toLowerCase() == "ln.pizza") {
      _vendorBgColor = theme.lnpizza.iconBgColor != null ? theme.lnpizza.iconBgColor : Colors.transparent;
    }

    Color _vendorTextColor = Colors.black;
    if (_vendor.name.toLowerCase() == "bitrefill") {
      _vendorTextColor = theme.bitrefill.textColor != null ? theme.bitrefill.textColor : Colors.black;
    } else if (_vendor.name.toLowerCase() == "ln.pizza") {
      _vendorTextColor = theme.lnpizza.textColor != null ? theme.lnpizza.textColor : Colors.black;
    }

    final _vendorLogo = _vendor.logo != null
        ? Image(
            image: AssetImage(_vendor.logo),
            height: 48.0,
            color: _vendorFgColor,
          )
        : Container();

    final _vendorCard = new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              FadeInRoute(
                builder: (_) => new VendorWebViewPage(accountBloc, _vendor.url, _vendor.name),
              ));
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0.0),
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
                  color: _vendorBgColor == Colors.white ? Theme.of(context).highlightColor : Colors.white, style: BorderStyle.solid, width: 1.0),
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
        Text(_vendor.name, style: theme.vendorTitleStyle.copyWith(color: _vendorTextColor)),
      ];
    }
  }
}
