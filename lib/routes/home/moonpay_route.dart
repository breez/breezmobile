import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/add_funds_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

void showMoonpayWebview(BuildContext context) {
  final texts = AppLocalizations.of(context);
  final addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
  bool cancelled = false;
  addFundsBloc.addFundRequestSink.add(AddFundsInfo(true, true));
  final loaderRoute = createLoaderRoute(
    context,
    message: texts.add_funds_moonpay_loading,
    opacity: 0.8,
    onClose: () => cancelled = true,
  );
  Navigator.push(context, loaderRoute);
  addFundsBloc.moonpayNextOrderStream.first
      .timeout(Duration(seconds: 15))
      .then((order) {
    if (cancelled) {
      return;
    }
    FlutterWebBrowser.openWebPage(
      url: order.url,
      customTabsOptions: CustomTabsOptions(
        shareState: CustomTabsShareState.on,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }).whenComplete(
    () => Navigator.of(context).removeRoute(loaderRoute),
  );
}
