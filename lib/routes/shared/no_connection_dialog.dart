import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'dart:io';

void listenNoConnection(BuildContext context, AccountBloc accountBloc) {
  accountBloc.lightningDownStream.listen((change) {
    promptError(
      context,
      "No Internet Connection",
      Text(
          "You can try:\n• Turning off airplane mode\n• Turning on mobile data or Wi-Fi\n• Checking the signal in your area",
          style: theme.alertStyle),
      okText: "Try Again",
      okFunc: () => accountBloc.restartLightningSink.add(null),
      optionText: "Exit",
      optionFunc: () => exit(0),      
      disableBack: true,
    );
  });
}
