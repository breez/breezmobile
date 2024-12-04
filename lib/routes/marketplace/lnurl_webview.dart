import 'package:breez/bloc/marketplace/vendor_model.dart';
import 'package:breez/routes/marketplace/vendor_webview.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

import 'lnurl_auth.dart';

class LNURLWebViewPage extends StatefulWidget {
  final VendorModel vendorModel;

  const LNURLWebViewPage({Key key, this.vendorModel}) : super(key: key);

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
      handleLNUrlAuth(context, vendor: widget.vendorModel).then((jwt) {
        if (mounted) {
          setState(() => jwtToken = jwt);
        }
      }).catchError(
        (err) {
          final texts = context.texts();

          return promptError(
            context,
            texts.lnurl_webview_error_title,
            Text(err.toString()),
            okFunc: () => Navigator.of(context).pop(),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (jwtToken == null) {
      return Material(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(widget.vendorModel.displayName),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () => Navigator.pop(context))
            ],
          ),
          body: const Center(child: Loader()),
        ),
      );
    }

    return VendorWebViewPage(
      "${widget.vendorModel.url}?token=$jwtToken",
      widget.vendorModel.displayName,
    );
  }
}
