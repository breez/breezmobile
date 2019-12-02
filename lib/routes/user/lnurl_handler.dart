import 'dart:async';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/invoice/invoice_model.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

import 'create_invoice/create_invoice_page.dart';

class LNURLHandler {
  final BuildContext _context;

  LNURLHandler(this._context) {
    LNUrlBloc bloc = LNUrlBloc();
    bloc.lnurlWithdrawStream.listen((withdrawResponse) {
      Navigator.of(_context).push(FadeInRoute(
        builder: (_) => CreateInvoicePage(lnurlWithdraw: withdrawResponse),
      ));
    });
  }
}
