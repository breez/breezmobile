import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

import 'create_invoice/create_invoice_page.dart';

class LNURLHandler {
  final BuildContext _context;
  final UserProfileBloc _userProfileBloc;

  LNURLHandler(this._context, this._userProfileBloc) {
    LNUrlBloc bloc = LNUrlBloc();
    bloc.lnurlWithdrawStream.listen((withdrawResponse) async {
      await _userProfileBloc.userStream.where((u) => u.locked == false).first;
      Navigator.of(_context).push(FadeInRoute(
        builder: (_) => CreateInvoicePage(lnurlWithdraw: withdrawResponse),
      ));
    }).onError((err) async {
      await _userProfileBloc.userStream.where((u) => u.locked == false).first;
      promptError(
          this._context,
          "Link Error",
          Text("Failed to process link: " + err.toString(),
              style: Theme.of(this._context).dialogTheme.contentTextStyle));
    });
  }
}
