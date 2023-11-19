import 'package:another_flushbar/flushbar.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/exceptions.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/no_connection_dialog.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logging/logging.dart';
import 'package:store_checker/store_checker.dart';
import 'package:url_launcher/url_launcher_string.dart';

final _log = Logger("CheckVersionHandler");

void checkVersionDialog(
  BuildContext context,
  UserProfileBloc userProfileBloc,
) {
  _log.info("checkVersionDialog");
  CheckVersion action = CheckVersion();
  userProfileBloc.userActionsSink.add(action);
  action.future.then((value) => _log.info("Done $value"), onError: (error) {
    _log.info("checkVersionDialog error: $error");
    bool upgrading = error.contains('upgrading');
    if (upgrading) {
      _handleUpgrading(context, userProfileBloc);
    } else if (error.contains('connection error')) {
      _handleConnectionError(context, userProfileBloc);
    } else if (!upgrading && error.contains('bad version')) {
      _handleBadVersion(context);
    } else {
      _log.info("Unhandled error $error");
    }
  });
}

void _handleUpgrading(
  BuildContext context,
  UserProfileBloc userProfileBloc,
) {
  _log.info("_handleUpgrading");
  final texts = context.texts();
  final themeData = Theme.of(context);

  AccountBloc accBloc = AppBlocsProvider.of<AccountBloc>(context);
  accBloc.setNodeUpgrading(true);

  showFlushbar(
    context,
    isDismissible: false,
    position: FlushbarPosition.TOP,
    duration: Duration.zero,
    messageWidget: Text(
      texts.handler_check_version_error_upgrading_servers,
      style: theme.snackBarStyle,
      textAlign: TextAlign.left,
    ),
    buttonText: "",
    icon: SvgPicture.asset(
      "src/icon/warning.svg",
      colorFilter: ColorFilter.mode(
        themeData.colorScheme.error,
        BlendMode.srcATop,
      ),
    ),
  );
}

void _handleConnectionError(
  BuildContext context,
  UserProfileBloc userProfileBloc,
) {
  _log.info("_handleConnectionError");
  showNoConnectionDialog(context).then((retry) {
    _log.info("-- showNoConnectionDialog --\n$retry");

    if (retry == true) {
      Future.delayed(const Duration(seconds: 1), () {
        checkVersionDialog(context, userProfileBloc);
      });
    }
  });
}

void _handleBadVersion(
  BuildContext context,
) {
  _log.info("_handleBadVersion");
  final texts = context.texts();

  showFlushbar(
    context,
    buttonText: texts.handler_check_version_action_update,
    onDismiss: () {
      _log.info("onDismiss $defaultTargetPlatform");
      StoreChecker.getSource.then((installationSource) {
        _launchStoreForUpdate(installationSource);
      }, onError: (error) {
        _log.warning("StoreChecker.getSource error: $error");
        showFlushbar(
          context,
          position: FlushbarPosition.TOP,
          duration: Duration.zero,
          messageWidget: Text(
            extractExceptionMessage(error),
            style: theme.snackBarStyle,
            textAlign: TextAlign.center,
          ),
        );
      });
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

void _launchStoreForUpdate(Source installationSource) {
  _log.info("_launchStoreForUpdate $installationSource platform: $defaultTargetPlatform");
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    if (installationSource == Source.IS_INSTALLED_FROM_APP_STORE) {
      launchUrlString('https://apps.apple.com/app/breez-lightning-client-pos/id1463604142');
    } else {
      launchUrlString('https://testflight.apple.com/join/wPju2Du7');
    }
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    _log.info("StoreChecker.getSource: $installationSource");
    if (installationSource == Source.IS_INSTALLED_FROM_PLAY_STORE) {
      launchUrlString('https://play.google.com/apps/testing/com.breez.client');
    } else {
      launchUrlString('https://github.com/breez/breezmobile/releases');
    }
  }
}
