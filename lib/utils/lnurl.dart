import 'dart:async';

import 'package:breez/bloc/lnurl/lnurl_actions.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/handlers/lnurl_handler.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

RegExp _lnurlPrefix = new RegExp(",*?((lnurl)([0-9]{1,}[a-z0-9]+){1})");
String _lightningProtoclPrefix = "lightning:";

bool isLNURL(String url) {
  var lower = url.toLowerCase();
  if (lower.startsWith(_lightningProtoclPrefix)) {
    lower = lower.substring(_lightningProtoclPrefix.length);
  }
  var firstMatch = _lnurlPrefix.firstMatch(lower);
  if (firstMatch != null && firstMatch.start == 0) {
    return true;
  }
  try {
    Uri uri = Uri.parse(lower);
    String lightning = uri.queryParameters["lightning"];
    return lightning != null && _lnurlPrefix.firstMatch(lightning) != null;
  } on FormatException {} // do nothing.
  return false;
}

Future handleLNUrl(
  LNUrlBloc lnurlBloc,
  BuildContext context,
  String lnurl,
) async {
  Fetch fetchAction = Fetch(lnurl);
  var cancelCompleter = Completer();
  var loaderRoute = createLoaderRoute(context, onClose: () {
    cancelCompleter.complete();
  });
  Navigator.of(context).push(loaderRoute);

  lnurlBloc.actionsSink.add(fetchAction);
  await Future.any([cancelCompleter.future, fetchAction.future]).then(
    (response) {
      Navigator.of(context).removeRoute(loaderRoute);
      if (cancelCompleter.isCompleted) {
        return;
      }

      LNURLHandler(context, lnurlBloc)
          .executeLNURLResponse(context, lnurlBloc, response);
    },
  ).catchError((err) {
    Navigator.of(context).removeRoute(loaderRoute);
    promptError(
      context,
      "Link Error",
      Text(
        "Failed to process link: " + err.toString(),
        style: Theme.of(context).dialogTheme.contentTextStyle,
      ),
    );
  });
}
