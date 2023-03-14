import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/account/add_funds_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/utils/external_browser.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

void showMoonpayWebview(BuildContext context) {
  final texts = context.texts();
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
      .timeout(const Duration(seconds: 15))
      .then((order) {
    if (cancelled) {
      return;
    }
    launchLinkOnExternalBrowser(order.url);
  }).whenComplete(
    () => Navigator.of(context).removeRoute(loaderRoute),
  );
}
