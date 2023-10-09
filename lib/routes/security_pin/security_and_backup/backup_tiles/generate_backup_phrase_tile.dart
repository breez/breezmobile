import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/routes/security_pin/backup_phrase/backup_phrase_confirmation_page.dart';
import 'package:breez/routes/security_pin/backup_phrase/backup_phrase_warning_dialog.dart';
import 'package:breez/widgets/designsystem/switch/simple_switch.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class GenerateBackupPhraseTile extends StatefulWidget {
  final BackupSettings backupSettings;
  final AutoSizeGroup autoSizeGroup;
  final Future Function(BackupSettings backupSettings) backupNow;

  const GenerateBackupPhraseTile({
    @required this.backupSettings,
    @required this.autoSizeGroup,
    @required this.backupNow,
  });

  @override
  State<GenerateBackupPhraseTile> createState() =>
      _GenerateBackupPhraseTileState();
}

class _GenerateBackupPhraseTileState extends State<GenerateBackupPhraseTile> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return SimpleSwitch(
      text: texts.security_and_backup_encrypt,
      switchValue: widget.backupSettings.backupKeyType == BackupKeyType.PHRASE,
      group: widget.autoSizeGroup,
      onChanged: (bool value) async {
        if (mounted) {
          if (value) {
            Navigator.push(
              context,
              FadeInRoute(
                builder: (BuildContext context) => withBreezTheme(
                  context,
                  BackupPhraseGeneratorConfirmationPage(),
                ),
              ),
            );
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return BackupPhraseWarningDialog();
              },
            ).then(
              (approved) async {
                if (approved) await _disableEncryption();
              },
            );
          }
        }
      },
    );
  }

  Future<void> _disableEncryption() async {
    try {
      EasyLoading.show();

      await widget.backupNow(
        widget.backupSettings.copyWith(keyType: BackupKeyType.NONE),
      );
    } catch (e) {
      EasyLoading.dismiss();
      rethrow;
    }
  }
}
