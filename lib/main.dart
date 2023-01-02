import 'dart:async';
import 'dart:convert';

import 'package:clovrlabs_wallet/services/breezlib/breez_bridge.dart';
import 'package:clovrlabs_wallet/services/injector.dart';
import 'package:clovrlabs_wallet/utils/date.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:clovrlabs_wallet/bloc/app_blocs.dart';
import 'package:clovrlabs_wallet/bloc/backup/backup_bloc.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/logger.dart';
import 'package:clovrlabs_wallet/wallet_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/backup/backup_model.dart';
import 'bloc/user_profile/user_profile_bloc.dart';

void main() async {
  // runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    BreezLogger();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    BreezDateUtils.setupLocales();
    await Firebase.initializeApp();
    SharedPreferences.getInstance().then((preferences) async {
       await runMigration(preferences);
      runApp(AppBlocsProvider(
          child: WalletManager(), appBlocs: AppBlocs()));
    });
  // }, (error, stackTrace) async {
  //   stackTrace.toString();
  //   print(error.toString());
  //   BreezBridge breezBridge = ServiceInjector().breezBridge;
  //   if (error is! FlutterErrorDetails) {
  //     breezBridge.log(
  //         error.toString() + '\n' + stackTrace.toString(), "FlutterError");
  //   }
  // });
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
