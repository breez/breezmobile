import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/security_pin/remote_server_auth/remote_server_auth.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/backup_provider_selection_dialog.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class EnableBackupDialog extends StatefulWidget {
  final BackupSettings backupSettings;
  final bool signInNeeded;

  const EnableBackupDialog({
    @required this.backupSettings,
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
    final texts = context.texts();
    final themeData = Theme.of(context);
    final contentTextStyle = themeData.primaryTextTheme.displaySmall.copyWith(
      fontSize: 16,
    );

    bool isRemoteServer = widget.backupSettings.backupProvider ==
        BackupSettings.remoteServerBackupProvider();

    return Theme(
      data: themeData.copyWith(
        unselectedWidgetColor: themeData.canvasColor,
      ),
      child: AlertDialog(
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
                  backupSettings: widget.backupSettings,
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
            backupSettings: widget.backupSettings,
            signInNeeded: widget.signInNeeded,
          ),
        ],
      ),
    );
  }
}

class _DoNotPromptAgainCheckbox extends StatelessWidget {
  final BackupSettings backupSettings;
  final AutoSizeGroup autoSizeGroup;

  const _DoNotPromptAgainCheckbox({
    Key key,
    this.autoSizeGroup,
    @required this.backupSettings,
  }) : super(key: key);

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
              value: !backupSettings.promptOnError,
              onChanged: (v) {
                backupBloc.backupSettingsSink.add(
                  backupSettings.copyWith(
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
              group: autoSizeGroup,
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
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    final texts = context.texts();
    final themeData = Theme.of(context);

    bool isRemoteServer = widget.backupSettings.backupProvider ==
        BackupSettings.remoteServerBackupProvider();

    return TextButton(
      onPressed: (() async {
        Navigator.pop(context);
        var provider = widget.backupSettings.backupProvider;

        _showSelectProviderDialog(widget.backupSettings).then(
          (selectedProvider) async {
            provider ??= selectedProvider;
            if (provider != null) {
              if (widget.signInNeeded &&
                  provider == BackupSettings.icloudBackupProvider()) {
                return await _showSignInNeededDialog();
              }
              if (provider == BackupSettings.remoteServerBackupProvider()) {
                return await _enterRemoteServerCredentials(backupBloc);
              }

              backupBloc.backupNowSink.add(
                const BackupNowAction(recoverEnabled: true),
              );
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
      builder: (_) => BackupProviderSelectionDialog(
        backupSettings: backupSettings,
      ),
    );
  }

  Future<void> _showSignInNeededDialog() async {
    final texts = context.texts();
    final themeData = Theme.of(context);

    await promptError(
      context,
      texts.backup_dialog_icloud_error_title,
      Text(
        texts.backup_dialog_icloud_error_message,
        style: themeData.dialogTheme.contentTextStyle,
      ),
    );
    return;
  }

  Future<void> _enterRemoteServerCredentials(BackupBloc backupBloc) async {
    await promptAuthData(
      context,
      widget.backupSettings,
      restore: false,
    ).then(
      (auth) {
        if (auth != null) {
          var action = UpdateBackupSettings(
            widget.backupSettings.copyWith(
              remoteServerAuthData: auth,
            ),
          );
          backupBloc.backupActionsSink.add(action);
          backupBloc.backupNowSink.add(
            const BackupNowAction(recoverEnabled: true),
          );
        }
      },
    );
    return;
  }
}
