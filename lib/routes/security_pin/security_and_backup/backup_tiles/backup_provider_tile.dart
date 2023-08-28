import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
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
              final accountChanged = await _logoutWarningDialog(currentProvider).then((ok) async {
                if (ok) {
                  await _signOut();
                  await _signIn();
                  return true;
                } else {
                  return false;
                }
              });
              if(!accountChanged){
                return;
              }
            }
            if (selectedProvider.isICloud) {
              await _showSignInNeededDialog(selectedProvider);
              return;
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
    var signInAction = SignIn();
    backupBloc.backupActionsSink.add(signInAction);
    return signInAction.future;
  }

  Future _logoutWarningDialog(BackupProvider previousProvider) async {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    return await backupBloc.backupStateStream.first.then((backupState) async {
      if (backupState != BackupState.start() && previousProvider.isGDrive) {
        return await promptAreYouSure(
          context,
          "Logout Warning",
          const Text(
            "You are already signed into a Google Drive account. Would you like to switch to a different account?",
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        ).then((ok) => ok);
      }
      return true;
    });
  }

  Future _showSignInNeededDialog(BackupProvider provider) async {
    if (provider.isICloud) {
      final texts = context.texts();
      final themeData = Theme.of(context);

      await promptError(
        context,
        texts.initial_walk_through_sign_in_icloud_title,
        Text(
          texts.initial_walk_through_sign_in_icloud_message,
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
    }
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
