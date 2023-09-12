import 'dart:math';

import 'package:bip39/bip39.dart' as bip39;
import 'package:breez/bloc/backup/backup_actions.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/routes/backup_in_progress_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class VerifyBackupPhrasePage extends StatefulWidget {
  final String _mnemonics;

  const VerifyBackupPhrasePage(
    this._mnemonics,
  );

  @override
  VerifyBackupPhrasePageState createState() => VerifyBackupPhrasePageState();
}

class VerifyBackupPhrasePageState extends State<VerifyBackupPhrasePage> {
  final _formKey = GlobalKey<FormState>();
  final List _randomlySelectedIndexes = [];
  List<String> _mnemonicsList;
  bool _hasError;

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final texts = context.texts();
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const backBtn.BackButton(),
        title: Text(texts.backup_phrase_generation_verify),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: query.size.height - kToolbarHeight - query.padding.top,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildForm(context),
              _buildInstructions(context),
              StreamBuilder<BackupSettings>(
                stream: backupBloc.backupSettingsStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      padding: const EdgeInsets.only(
                        bottom: 88,
                      ),
                    );
                  }
                  return _buildBackupBtn(snapshot.data);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _mnemonicsList = widget._mnemonics.split(" ");
    _hasError = false;
    _selectIndexes();
    super.initState();
  }

  Widget _buildBackupBtn(
    BackupSettings backupSettings,
  ) {
    final texts = context.texts();
    return SingleButtonBottomBar(
      text: texts.backup_phrase_warning_action_backup,
      onPressed: () {
        setState(() {
          _hasError = false;
        });
        if (_formKey.currentState.validate() && !_hasError) {
          _createBackupPhrase(backupSettings);
        }
      },
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () => _formKey.currentState.save(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildVerificationFormContent(context),
        ),
      ),
    );
  }

  Padding _buildInstructions(BuildContext context) {
    final texts = context.texts();
    return Padding(
      padding: const EdgeInsets.only(
        left: 72,
        right: 72,
      ),
      child: Text(
        texts.backup_phrase_generation_type_words(
          _randomlySelectedIndexes[0] + 1,
          _randomlySelectedIndexes[1] + 1,
          _randomlySelectedIndexes[2] + 1,
        ),
        style: theme.backupPhraseInformationTextStyle.copyWith(
          color: theme.BreezColors.white[300],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildVerificationFormContent(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    List<Widget> selectedWordList = List.generate(
      _randomlySelectedIndexes.length,
      (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: texts.backup_phrase_generation_type_step(
                _randomlySelectedIndexes[index] + 1,
              ),
            ),
            style: theme.FieldTextStyle.textStyle,
            validator: (text) {
              if (text.isEmpty ||
                  text.toLowerCase().trim() !=
                      _mnemonicsList[_randomlySelectedIndexes[index]]) {
                setState(() {
                  _hasError = true;
                });
              }
              return null;
            },
            onEditingComplete: () => (index == 2)
                ? FocusScope.of(context).unfocus()
                : FocusScope.of(context).nextFocus(),
          ),
        );
      },
    );
    if (_hasError) {
      selectedWordList.add(
        Text(
          texts.backup_phrase_generation_verification_failed,
          style: themeData.textTheme.headlineMedium.copyWith(
            fontSize: 12,
          ),
        ),
      );
    }
    return selectedWordList;
  }

  Future _createBackupPhrase(
    BackupSettings backupSettings,
  ) async {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    final themeData = Theme.of(context);
    final texts = context.texts();

    final saveBackupKey = SaveBackupKey(
      bip39.mnemonicToEntropy(widget._mnemonics),
    );
    backupBloc.backupActionsSink.add(saveBackupKey);
    saveBackupKey.future.then((_) async {
      try {
        EasyLoading.show();

        await _updateBackupSettings(
          backupSettings.copyWith(keyType: BackupKeyType.PHRASE),
        );

        _triggerBackup();
      } finally {
        EasyLoading.dismiss();
      }
    }).catchError((err) {
      promptError(
        context,
        texts.backup_phrase_generation_generic_error,
        Text(
          err.toString(),
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
    });
  }

  _selectIndexes() {
    // Select at least one index from each page(0-6,6-11) randomly
    var firstIndex = Random().nextInt(6);
    var secondIndex = Random().nextInt(6) + 6;
    // Select last index randomly from any page, ensure that there are no duplicates and each option has an ~equally likely chance of being selected
    var thirdIndex = Random().nextInt(10);
    if (thirdIndex >= firstIndex) thirdIndex++;
    if (thirdIndex >= secondIndex) thirdIndex++;
    _randomlySelectedIndexes.addAll([firstIndex, secondIndex, thirdIndex]);
    _randomlySelectedIndexes.sort();
  }

  Future _updateBackupSettings(
    BackupSettings backupSettings,
  ) async {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    final themeData = Theme.of(context);
    final texts = context.texts();

    var action = UpdateBackupSettings(backupSettings);
    backupBloc.backupActionsSink.add(action);
    Navigator.popUntil(context, ModalRoute.withName("/security"));
    return action.future.catchError((err) {
      promptError(
        context,
        texts.backup_phrase_generation_generic_error,
        Text(
          err.toString(),
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
    });
  }

  void _triggerBackup() {
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    backupBloc.backupNowSink.add(
      const BackupNowAction(recoverEnabled: true),
    );
    backupBloc.backupStateStream.firstWhere((s) => s.inProgress).then(
      (s) {
        if (mounted) {
          showDialog(
            useRootNavigator: false,
            barrierDismissible: false,
            context: context,
            builder: (ctx) => buildBackupInProgressDialog(
              ctx,
              backupBloc.backupStateStream,
            ),
          );
        }
      },
    );
  }
}
