import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'dart:io';

import 'package:share_extend/share_extend.dart';

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
              ResetChainService resetAction = ResetChainService();
              accountBloc.userActionsSink.add(resetAction);
              await resetAction.future;
              _promptForRestart(context);
            }),
          TextSpan(text: "chain information\n", style: theme.dialogGrayStyle),
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
          TextSpan(text: "your Bitcoin node\n", style: theme.dialogGrayStyle),
          TextSpan(text: "• ", style: theme.dialogGrayStyle),  
          TextSpan(
            text: "View ", 
            style: theme.blueLinkStyle,
            recognizer: TapGestureRecognizer()..onTap = () async {
              var logPath = await ServiceInjector().breezBridge.getLogPath();
              ShareExtend.share(logPath, "file");
            }), 
          TextSpan(text: "your logs \n", style: theme.dialogGrayStyle),
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

Future _promptForRestart(BuildContext context) {
    return promptAreYouSure(context, null,
            Text("Please restart to reset chain information.", style: theme.alertStyle),
            cancelText: "Cancel", okText: "Exit Breez")
        .then((shouldExit) {
      if (shouldExit) {
        exit(0);
      }
      return;
    });
  }
