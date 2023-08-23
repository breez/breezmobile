import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BackupProviderTile extends StatefulWidget {
  final BackupSettings backupSettings;
  final AutoSizeGroup autoSizeGroup;
  final Future Function() enterRemoteServerCredentials;
  final Future Function(BackupSettings backupSettings) backupNow;

  const BackupProviderTile({
    @required this.backupSettings,
    @required this.autoSizeGroup,
    @required this.enterRemoteServerCredentials,
    @required this.backupNow,
  });

  @override
  State<BackupProviderTile> createState() => _BackupProviderTileState();
}

class _BackupProviderTileState extends State<BackupProviderTile> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return ListTile(
      title: AutoSizeText(
        texts.security_and_backup_store_location,
        style: const TextStyle(color: Colors.white),
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
        group: widget.autoSizeGroup,
      ),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<BackupProvider>(
          iconEnabledColor: Colors.white,
          value: widget.backupSettings.backupProvider,
          isDense: true,
          onChanged: (BackupProvider selectedProvider) async {
            // Sign out if the user switches to GDrive from another provider
            if (!widget.backupSettings.backupProvider.isGDrive &&
                selectedProvider.isGDrive) {
              await _signOut();
              await _signIn();
            }
            await _updateBackupProvider(selectedProvider);
          },
          items: BackupSettings.availableBackupProviders().map(
            (provider) {
              return DropdownMenuItem(
                value: provider,
                child: AutoSizeText(
                  provider.displayName,
                  style: theme.FieldTextStyle.textStyle,
                  maxLines: 1,
                  minFontSize: MinFontSize(context).minFontSize,
                  stepGranularity: 0.1,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Future _signOut() {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    var signOutAction = SignOut();
    backupBloc.backupActionsSink.add(signOutAction);
    return signOutAction.future;
  }

  Future _signIn() {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    var signInAction = SignIn(force: false);
    backupBloc.backupActionsSink.add(signInAction);
    return signInAction.future;
  }

  Future<void> _updateBackupProvider(
    BackupProvider selectedProvider,
  ) async {
    try {
      EasyLoading.show();

      if (selectedProvider.isRemoteServer) {
        EasyLoading.dismiss();

        await widget.enterRemoteServerCredentials();
      } else {
        await widget.backupNow(
          widget.backupSettings.copyWith(backupProvider: selectedProvider),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      rethrow;
    }
  }
}