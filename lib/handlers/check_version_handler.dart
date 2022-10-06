import 'package:another_flushbar/flushbar.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/no_connection_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

void checkVersionDialog(
  BuildContext context,
  UserProfileBloc userProfileBloc,
) {
  final texts = AppLocalizations.of(context);

  CheckVersion action = CheckVersion();
  userProfileBloc.userActionsSink.add(action);
  action.future.catchError((err) {
    if (err.contains('connection error')) {
      showNoConnectionDialog(context).then((retry) {
        print("-- showNoConnectionDialog --");
        print(retry);
        if (retry == true) {
          Future.delayed(Duration(seconds: 1), () {
            checkVersionDialog(context, userProfileBloc);
          });
        }
      });
    } else if (err.contains('bad version')) {
      showFlushbar(
        context,
        buttonText: texts.handler_check_version_action_update,
        onDismiss: () {
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            launchUrlString('https://testflight.apple.com/join/wPju2Du7');
          }
          if (defaultTargetPlatform == TargetPlatform.android) {
            launchUrlString(
                'https://play.google.com/apps/testing/com.breez.client');
          }
          return false;
        },
        position: FlushbarPosition.TOP,
        duration: Duration.zero,
        messageWidget: Text(
          texts.handler_check_version_message,
          style: theme.snackBarStyle,
          textAlign: TextAlign.center,
        ),
      );
    }
  });
}
