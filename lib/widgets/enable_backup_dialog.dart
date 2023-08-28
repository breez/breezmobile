import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/initial_walkthrough/dialogs/select_backup_provider_dialog.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class EnableBackupDialog extends StatefulWidget {
  final bool signInNeeded;

  const EnableBackupDialog({
    this.signInNeeded = false,
  });

  @override
  EnableBackupDialogState createState() {
    return EnableBackupDialogState();
  }
}

class EnableBackupDialogState extends State<EnableBackupDialog> {
  final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    final texts = context.texts();
    final themeData = Theme.of(context);
    final contentTextStyle = themeData.primaryTextTheme.displaySmall.copyWith(
      fontSize: 16,
    );

    return Theme(
      data: themeData.copyWith(
        unselectedWidgetColor: themeData.canvasColor,
      ),
      child: StreamBuilder<BackupSettings>(
        stream: backupBloc.backupSettingsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Loader();
          }

          final backupSettings = snapshot.data;
          bool isRemoteServer = backupSettings.backupProvider?.isRemoteServer;

          return AlertDialog(
            titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
            title: Text(
              texts.backup_dialog_title,
              style: themeData.dialogTheme.titleTextStyle,
            ),
            contentPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 12.0),
                    child: AutoSizeText(
                      isRemoteServer
                          ? texts.backup_dialog_message_remote_server
                          : texts.backup_dialog_message_default,
                      style: contentTextStyle,
                      minFontSize: MinFontSize(context).minFontSize,
                      stepGranularity: 0.1,
                      group: _autoSizeGroup,
                    ),
                  ),
                  if (!isRemoteServer) ...[
                    _DoNotPromptAgainCheckbox(
                      backupSettings: backupSettings,
                      autoSizeGroup: _autoSizeGroup,
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  texts.backup_dialog_option_cancel,
                  style: themeData.primaryTextTheme.labelLarge,
                  maxLines: 1,
                ),
              ),
              _BackupNowButton(
                backupSettings: backupSettings,
                signInNeeded: widget.signInNeeded,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DoNotPromptAgainCheckbox extends StatefulWidget {
  final BackupSettings backupSettings;
  final AutoSizeGroup autoSizeGroup;

  const _DoNotPromptAgainCheckbox({
    Key key,
    this.autoSizeGroup,
    @required this.backupSettings,
  }) : super(key: key);

  @override
  State<_DoNotPromptAgainCheckbox> createState() =>
      _DoNotPromptAgainCheckboxState();
}

class _DoNotPromptAgainCheckboxState extends State<_DoNotPromptAgainCheckbox> {
  @override
  Widget build(BuildContext context) {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    final texts = context.texts();
    final themeData = Theme.of(context);
    final contentTextStyle = themeData.primaryTextTheme.displaySmall.copyWith(
      fontSize: 16,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: <Widget>[
          Theme(
            data: themeData.copyWith(
              unselectedWidgetColor: themeData.textTheme.labelLarge.color,
            ),
            child: Checkbox(
              activeColor: Colors.white,
              checkColor: themeData.canvasColor,
              value: !widget.backupSettings.promptOnError,
              onChanged: (v) {
                backupBloc.backupSettingsSink.add(
                  widget.backupSettings.copyWith(
                    promptOnError: !v,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: AutoSizeText(
              texts.backup_dialog_do_not_prompt_again,
              style: contentTextStyle,
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              group: widget.autoSizeGroup,
            ),
          )
        ],
      ),
    );
  }
}

class _BackupNowButton extends StatefulWidget {
  final BackupSettings backupSettings;
  final bool signInNeeded;

  const _BackupNowButton({
    Key key,
    @required this.backupSettings,
    @required this.signInNeeded,
  }) : super(key: key);

  @override
  State<_BackupNowButton> createState() => _BackupNowButtonState();
}

class _BackupNowButtonState extends State<_BackupNowButton> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    bool isRemoteServer = widget.backupSettings.backupProvider?.isRemoteServer;

    return TextButton(
      onPressed: (() async {
        final currentProvider = widget.backupSettings.backupProvider;

        await _showSelectProviderDialog(widget.backupSettings).then(
          (selectedProvider) async {
            if (selectedProvider != null) {
              if (widget.signInNeeded) {
                if (selectedProvider.isGDrive) {
                  await _logoutWarningDialog(currentProvider).then((ok) async {
                    if (ok) {
                      await _signOut();
                      await _signIn();
                    } else {
                      return;
                    }
                  });
                }

                if (selectedProvider.isICloud) {
                  await _showSignInNeededDialog(selectedProvider);
                  return;
                }
              }
              await _updateBackupProvider(selectedProvider);
            }
          },
        );
      }),
      child: Text(
        isRemoteServer
            ? texts.backup_dialog_option_ok_remote_server
            : texts.backup_dialog_option_ok_default,
        style: themeData.primaryTextTheme.labelLarge,
        maxLines: 1,
      ),
    );
  }

  Future<BackupProvider> _showSelectProviderDialog(
    BackupSettings backupSettings,
  ) {
    return showDialog<BackupProvider>(
      useRootNavigator: false,
      context: context,
      builder: (_) => SelectBackupProviderDialog(
        backupSettings: backupSettings,
      ),
    );
  }

  Future _logoutWarningDialog(BackupProvider previousProvider) async {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    return await backupBloc.backupStateStream.first.then((backupState) async {
      if (backupState != BackupState.start() && previousProvider.isGDrive) {
        return await promptAreYouSure(
          context,
          "Logout Warning",
          const Text("Do you want to switch to another account?"),
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
      await _backupNow(
        widget.backupSettings.copyWith(backupProvider: selectedProvider),
      ).then((_) => Navigator.pop(context));
    } catch (error) {
      _handleError(error);
      rethrow;
    }
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

  Future _backupNow(BackupSettings backupSettings) async {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);

    final updateBackupSettings = UpdateBackupSettings(backupSettings);
    final backupAction = BackupNow(updateBackupSettings);
    backupBloc.backupActionsSink.add(backupAction);
    return backupAction.future;
  }

  void _handleError(dynamic error) async {
    Navigator.of(context).pop();

    switch (error.runtimeType) {
      case SignInFailedException:
        _handleSignInException(error);
        return;
      case InsufficientPermissionException:
      default:
        showFlushbar(
          context,
          duration: const Duration(seconds: 3),
          message: error.toString(),
        );
    }
  }

  Future _handleSignInException(SignInFailedException e) async {
    if (e.provider == BackupProvider.iCloud()) {
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
}
