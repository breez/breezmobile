import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/routes/marketplace/vendor_webview.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter/material.dart';

import 'lnurl_auth.dart';

class LNURLWebViewPage extends StatefulWidget {
  final AccountBloc accountBloc;
  final VendorModel vendorModel;
  final LNUrlBloc lnurlBloc;
  final Uri endpointURI;
  final String responseID;

  const LNURLWebViewPage({
    Key key,
    this.accountBloc,
    this.vendorModel,
    this.lnurlBloc,
    this.endpointURI,
    this.responseID,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LNURLWebViewPageState();
  }
}

class LNURLWebViewPageState extends State<LNURLWebViewPage> {
  String jwtToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleLNUrlAuth(context, widget.vendorModel, widget.endpointURI, widget.lnurlBloc, widget.responseID).then((jwt) {
        if (this.mounted) {
          setState(() => jwtToken = jwt);
        }
      }).catchError(
        (err) => promptError(
          context,
          BreezTranslations.of(context).lnurl_webview_error_title,
          Text(err.toString()),
          okFunc: () => Navigator.of(context).pop(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (jwtToken == null) {
      return const Material(child: Loader());
    }
    return VendorWebViewPage(
      widget.accountBloc,
      "${widget.vendorModel.url}?token=$jwtToken",
      widget.vendorModel.displayName,
    );
  }
}
