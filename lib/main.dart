import 'dart:async';
import 'dart:convert';

import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/bloc/settings/settings_bloc.dart';
import 'package:anytime/repository/sembast/sembast_repository.dart';
import 'package:anytime/services/settings/mobile_settings_service.dart';
import 'package:anytime/ui/podcast/now_playing.dart';
import 'package:anytime/ui/podcast/podcast_details.dart';
import 'package:anytime/ui/widgets/episode_tile.dart';
import 'package:anytime/ui/widgets/placeholder_builder.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/podcast_payments/podcast_payments_bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/initial_walkthrough/loaders/loader_indicator.dart';
import 'package:breez/routes/podcast/podcast_loader.dart';
import 'package:breez/routes/podcast/podcast_page.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/user_app.dart';
import 'package:breez/utils/date.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // runZonedGuarded wrapper is required to log Dart errors.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    BreezLogger();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    //initializeDateFormatting(Platform.localeName, null);
    BreezDateUtils.setupLocales();
    var mobileService = await MobileSettingsService.instance();
    mobileService.autoOpenNowPlaying = true;
    mobileService.showFunding = false;
    mobileService.searchProvider = 'podcastindex';
    final repository = SembastRepository();
    await Firebase.initializeApp();
    _configureEasyLoading();
    SharedPreferences.getInstance().then((preferences) async {
      await runMigration(preferences);
      AppBlocs blocs = AppBlocs(repository.backupDatabaseListener);
      runApp(AppBlocsProvider(
          appBlocs: blocs,
          child: AnytimePodcastApp(
              mobileService,
              repository,
              Provider<PodcastPaymentsBloc>(
                lazy: false,
                create: (ctx) => PodcastPaymentsBloc(
                  blocs.userProfileBloc,
                  blocs.accountBloc,
                  Provider.of<SettingsBloc>(ctx, listen: false),
                  Provider.of<AudioBloc>(ctx, listen: false),
                  repository,
                  PodcastIndexClient(),
                ),
                dispose: (_, value) => value.dispose(),
                child: PlayerControlsBuilder(
                    builder: playerBuilder,
                    child: PlaceholderBuilder(
                        builder: placeholderBuilder,
                        errorBuilder: errorPlaceholderBuilder,
                        child: SharePodcastButtonBuilder(
                            builder: sharePodcastButtonBuilder,
                            child: ShareEpisodeButtonBuilder(
                                builder: shareEpisodeButtonBuilder,
                                child: UserApp(repository.reloadDatabaseSink))))),
              ))));
    });
  }, (error, stackTrace) async {
    BreezBridge breezBridge = ServiceInjector().breezBridge;
    if (error is! FlutterErrorDetails) {
      breezBridge.log('$error\n$stackTrace', "FlutterError");
    }
  });
}

void _configureEasyLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.transparent
    ..maskType = EasyLoadingMaskType.custom
    ..boxShadow = []
    ..indicatorWidget = const LoaderIndicator()
    ..indicatorColor = Colors.white
    ..maskColor = Colors.black.withOpacity(0.5)
    ..textColor = Colors.white
    ..textPadding = const EdgeInsets.only(top: 16.0)
    ..userInteractions = false
    ..dismissOnTap = false;
}

Future runMigration(SharedPreferences preferences) async {
  var userJson = preferences.getString(UserProfileBloc.USER_DETAILS_PREFERENCES_KEY);
  Map<String, dynamic> userData = json.decode(userJson ?? "{}");

  var backupJson = preferences.getString(BackupBloc.BACKUP_SETTINGS_PREFERENCES_KEY);
  Map<String, dynamic> backupData = json.decode(backupJson ?? "{}");

  if (userData["securityModel"] != null && userData["securityModel"]["secureBackupWithPin"] == true) {
    backupData["backupKeyType"] = BackupKeyType.PIN.index;
    userData["securityModel"]["secureBackupWithPin"] = null;
    await preferences.setString(BackupBloc.BACKUP_SETTINGS_PREFERENCES_KEY, json.encode(backupData));
    await preferences.setString(UserProfileBloc.USER_DETAILS_PREFERENCES_KEY, json.encode(userData));
  }

  // last backup time migration
  var legacyBackupTime = preferences.getInt(BackupBloc.LAST_BACKUP_TIME_PREFERENCE_KEY);
  if (legacyBackupTime != null) {
    Map<String, dynamic> backupStateData = {"lastBackupTime": legacyBackupTime};
    await preferences.setString(BackupBloc.LAST_BACKUP_STATE_PREFERENCE_KEY, json.encode(backupStateData));
    await preferences.remove(BackupBloc.LAST_BACKUP_TIME_PREFERENCE_KEY);
  }
}
