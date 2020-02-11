import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:breez/theme_data.dart' as theme;

class CheckVersionHandler {
  final BuildContext context;
  final UserProfileBloc userProfileBloc;

  CheckVersionHandler(this.context, this.userProfileBloc) {
    CheckVersion action = CheckVersion();
    userProfileBloc.userActionsSink.add(action);
    action.future.catchError((err) {
      showFlushbar(context, buttonText: "UPDATE", onDismiss: () {
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          launch("https://testflight.apple.com/join/wPju2Du7");
        }
        if (defaultTargetPlatform == TargetPlatform.android) {
          launch("https://play.google.com/apps/testing/com.breez.client");
        }
        return false;
      },
          position: FlushbarPosition.TOP,
          duration: Duration.zero,
          messageWidget: Text("Please update Breez to the latest version.",
              style: theme.snackBarStyle, textAlign: TextAlign.center));
    });
  }
}
