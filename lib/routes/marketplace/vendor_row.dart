import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/routes/marketplace/lnurl_auth.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'lnurl_webview.dart';
import 'vendor_webview.dart';

class VendorRow extends StatelessWidget {
  final AccountBloc accountBloc;
  final VendorModel _vendor;

  const VendorRow(this.accountBloc, this._vendor);

  @override
  Widget build(BuildContext context) {
    Color vendorFgColor =
        theme.vendorTheme[_vendor.id.toLowerCase()]?.iconFgColor ??
            Colors.transparent;
    Color vendorBgColor =
        theme.vendorTheme[_vendor.id.toLowerCase()]?.iconBgColor ??
            Colors.white;
    Color vendorTextColor =
        theme.vendorTheme[_vendor.id.toLowerCase()]?.textColor ?? Colors.black;

    final vendorLogo = _vendor.logo != null
        ? Image(
            image: AssetImage(_vendor.logo),
            height: (_vendor.id == 'Wavlake')
                ? 73
                : (_vendor.id == 'LNCal')
                    ? 56
                    : (_vendor.id == 'Snort')
                        ? 100
                        : 48,
            width: _vendor.onlyShowLogo
                ? (_vendor.id == 'Bitrefill')
                    ? 156
                    : 196
                : null,
            color: vendorFgColor,
            colorBlendMode: BlendMode.srcATop,
          )
        : Container();

    final vendorCard = GestureDetector(
      onTap: () async {
        // iOS only
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          final navigator = Navigator.of(context);
          var loaderRoute = createLoaderRoute(context);
          try {
            navigator.push(loaderRoute);
            var url = _vendor.url;
            if (_vendor.webLN) {
              var jwtToken = await handleLNUrlAuth(context, vendor: _vendor);
              url = "$url?token=$jwtToken";
            }
            launchUrl(Uri.parse(url));
          } catch (err) {
            promptError(context, "Error", Text(err.toString()));
          } finally {
            if (loaderRoute.isActive) {
              navigator.removeRoute(loaderRoute);
            }
          }
          return;
        }

        // non iOS
        Navigator.push(
          context,
          FadeInRoute(
            builder: (_) => (_vendor.endpointURI != null)
                ? LNURLWebViewPage(vendorModel: _vendor)
                : VendorWebViewPage(_vendor.url, _vendor.displayName),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 8.0),
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: vendorBgColor,
          boxShadow: [
            BoxShadow(
              color: theme.BreezColors.grey[600],
              blurRadius: 8.0,
            )
          ],
          border: Border.all(
            color: vendorBgColor == Colors.white
                ? Theme.of(context).highlightColor
                : Colors.transparent,
            style: BorderStyle.solid,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildLogo(vendorLogo, vendorTextColor),
        ),
      ),
    );

    return vendorCard;
  }

  List<Widget> _buildLogo(Widget vendorLogo, vendorTextColor) {
    if (_vendor.onlyShowLogo) {
      return <Widget>[vendorLogo];
    } else {
      return <Widget>[
        vendorLogo,
        const Padding(padding: EdgeInsets.only(left: 8.0)),
        Text(
          _vendor.displayName,
          style: theme.vendorTitleStyle.copyWith(color: vendorTextColor),
        ),
      ];
    }
  }
}
