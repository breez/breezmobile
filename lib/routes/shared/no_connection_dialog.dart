import 'package:breez/bloc/account/account_actions.dart';
import 'package:flutter/gestures.dart';
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
      RichText(
      text: TextSpan(
        style: theme.dialogGrayStyle,
        text: "You can try:\n",
        children:<TextSpan>[
          TextSpan(text: "• Turning off airplane mode\n", style: theme.dialogGrayStyle),
          TextSpan(text: "• Turning on mobile data or Wi-Fi\n", style: theme.dialogGrayStyle),
          TextSpan(text: "• Checking the signal in your area\n", style: theme.dialogGrayStyle),        
          TextSpan(text: "• ", style: theme.dialogGrayStyle),  
          TextSpan(
            text: "Reset ", 
            style: theme.blueLinkStyle,
            recognizer: TapGestureRecognizer()..onTap = () async {
              ResetNetwork resetAction = ResetNetwork();
              accountBloc.userActionsSink.add(resetAction);
              await resetAction.future;
              Navigator.pop(context);
              accountBloc.userActionsSink.add(RestartDaemon());
            }), 
          TextSpan(text: "bitcoin node\n", style: theme.dialogGrayStyle),
        ]), 
      ),
      // Text(
      //     "You can try:\n• Turning off airplane mode\n• Turning on mobile data or Wi-Fi\n• Checking the signal in your area",
      //     style: theme.alertStyle),
      okText: "Try Again",
      okFunc: () => accountBloc.userActionsSink.add(RestartDaemon()),
      optionText: "Exit",
      optionFunc: () => exit(0),      
      disableBack: true,
    );
  });
}
