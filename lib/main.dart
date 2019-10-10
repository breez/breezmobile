import 'dart:convert';
import 'dart:io' show Platform;

import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/logger.dart';
import 'package:breez/user_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/backup/backup_model.dart';
import 'bloc/user_profile/user_profile_bloc.dart';

void main() {
  BreezLogger();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  initializeDateFormatting(Platform.localeName, null);
  SharedPreferences.getInstance().then((preferences) async {
    await runMigration(preferences);
    AppBlocs blocs = AppBlocs();
    runApp(AppBlocsProvider(child: UserApp(), appBlocs: blocs));    
  });  
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
