import 'dart:convert';

import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/repository/sembast/sembast_repository.dart';
import 'package:anytime/ui/podcast/now_playing.dart';
import 'package:anytime/ui/widgets/placeholder_builder.dart';
import 'package:provider/provider.dart';
import 'package:anytime/services/settings/mobile_settings_service.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/podcast_payments/podcast_payments_bloc.dart';
import 'package:breez/logger.dart';
import 'package:breez/routes/podcast/podcast_page.dart';
import 'package:breez/user_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/account/account_bloc.dart';
import 'bloc/backup/backup_model.dart';
import 'bloc/user_profile/user_profile_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BreezLogger();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //initializeDateFormatting(Platform.localeName, null);
  var mobileService = await MobileSettingsService.instance();
  mobileService.autoOpenNowPlaying = true;
  final repository = SembastRepository();
  SharedPreferences.getInstance().then((preferences) async {
    await runMigration(preferences);
    AppBlocs blocs = AppBlocs();
    runApp(AppBlocsProvider(
        child: AnytimePodcastApp(
            mobileService,
            repository,
            Provider<PodcastPaymentsBloc>(
              lazy: false,
              create: (ctx) => PodcastPaymentsBloc(blocs.accountBloc,
                  Provider.of<AudioBloc>(ctx, listen: false), repository),
              dispose: (_, value) => value.dispose(),
              child: PlayerControlsBuilder(
                  builder: playerBuilder,
                  child: PlaceholderBuilder(
                      builder: placeholderBuilder,
                      errorBuilder: errorPlaceholderBuilder,
                      child: UserApp())),
            )),
        appBlocs: blocs));
  });
}

Future runMigration(SharedPreferences preferences) async {
  var userJson =
      preferences.getString(UserProfileBloc.USER_DETAILS_PREFERENCES_KEY);
  Map<String, dynamic> userData = json.decode(userJson ?? "{}");

  var backupJson =
      preferences.getString(BackupBloc.BACKUP_SETTINGS_PREFERENCES_KEY);
  Map<String, dynamic> backupData = json.decode(backupJson ?? "{}");

  if (userData["securityModel"] != null &&
      userData["securityModel"]["secureBackupWithPin"] == true) {
    backupData["backupKeyType"] = BackupKeyType.PIN.index;
    userData["securityModel"]["secureBackupWithPin"] = null;
    await preferences.setString(
        BackupBloc.BACKUP_SETTINGS_PREFERENCES_KEY, json.encode(backupData));
    await preferences.setString(
        UserProfileBloc.USER_DETAILS_PREFERENCES_KEY, json.encode(userData));
  }

  // last backup time migration
  var legacyBackupTime =
      preferences.getInt(BackupBloc.LAST_BACKUP_TIME_PREFERENCE_KEY);
  if (legacyBackupTime != null) {
    Map<String, dynamic> backupStateData = {"lastBackupTime": legacyBackupTime};
    await preferences.setString(BackupBloc.LAST_BACKUP_STATE_PREFERENCE_KEY,
        json.encode(backupStateData));
    await preferences.remove(BackupBloc.LAST_BACKUP_TIME_PREFERENCE_KEY);
  }
}
