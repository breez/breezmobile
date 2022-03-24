import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/add_funds_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

void showMonpayWebview(context) {
  AddFundsBloc addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
  bool cancelled = false;
  addFundsBloc.addFundRequestSink.add(AddFundsInfo(true, true));
  var loaderRoute = createLoaderRoute(context,
      message: "Loading...", opacity: 0.8, onClose: () => cancelled = true);
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
        addDefaultShareMenuItem: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }).whenComplete(() => {Navigator.of(context).removeRoute(loaderRoute)});
}
