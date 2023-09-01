import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/logger.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BackupProviderTile extends StatefulWidget {
  final BackupSettings backupSettings;
  final AutoSizeGroup autoSizeGroup;
  final Future Function() enterRemoteServerCredentials;
  final Future Function(BackupSettings backupSettings) backupNow;
  final Function(dynamic exception) onError;

  const BackupProviderTile({
    @required this.backupSettings,
    @required this.autoSizeGroup,
    @required this.enterRemoteServerCredentials,
    @required this.backupNow,
    @required this.onError,
  });

  @override
  State<BackupProviderTile> createState() => _BackupProviderTileState();
}

class _BackupProviderTileState extends State<BackupProviderTile> {
  @override
  Widget build(BuildContext context) {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);

    final texts = context.texts();
    final currentProvider = widget.backupSettings.backupProvider;

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
          value: currentProvider,
          isDense: true,
          onChanged: (BackupProvider selectedProvider) async {
            if (selectedProvider.isGDrive) {
              await _logoutWarningDialog(currentProvider).then(
                (logoutApproved) async {
                  if (logoutApproved) {
                    try {
                      EasyLoading.show();

                      backupBloc.backupServiceNeedLoginSink.add(true);
                      await _updateBackupProvider(selectedProvider);
                    } catch (e) {
                      log.warning("Failed to re-login & backup.", e);
                      widget.onError(e);
                    }
                  }
                },
              );
            }
            if (currentProvider != selectedProvider) {
              await _updateBackupProvider(selectedProvider);
            }
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

  Future _logoutWarningDialog(BackupProvider previousProvider) async {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    return await backupBloc.backupStateStream.first.then(
      (backupState) async {
        if ((backupState != BackupState.start() && previousProvider.isGDrive) ||
            previousProvider.isGDrive) {
          return await promptAreYouSure(
            context,
            "Logout Warning",
            const Text(
              "You are already signed into a Google Drive account. Would you like to switch to a different account?",
            ),
            contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          ).then((ok) => ok);
        } else if (!previousProvider.isGDrive ||
            backupState == BackupState.start()) {
          // When switching from another provider,
          // On a new account on Android(where GDrive is default provider)
          return true;
        }
        return false;
      },
      onError: (e) {
        log.warning("Failed to get backup state.", e);
        // If GDrive backup has failed.
        // Mostly for new accounts on Android(where GDrive is default provider)
        // where a backup was triggered before setting up a backup provider.
        if (e is BackupFailedException && previousProvider.isGDrive) {
          return true;
        }
        return false;
      },
    );
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
      log.warning("Failed to update backup provider.", e);
      EasyLoading.dismiss();
      rethrow;
    }
  }
}
