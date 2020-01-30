import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

import 'create_invoice/create_invoice_page.dart';

class LNURLHandler {
  final BuildContext _context;
  final LNUrlBloc lnurlBloc;

  LNURLHandler(this._context, this.lnurlBloc) {    
    lnurlBloc.lnurlWitdrawStream.listen((withdrawResponse) async {
      Navigator.of(_context).push(FadeInRoute(
        builder: (_) => CreateInvoicePage(lnurlWithdraw: withdrawResponse),
      ));
    }).onError((err) async {
      promptError(
          this._context,
          "Link Error",
          Text("Failed to process link: " + err.toString(),
              style: Theme.of(this._context).dialogTheme.contentTextStyle));
    });
  }
}
