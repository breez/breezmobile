import 'dart:math';

import 'package:bip39/bip39.dart' as bip39;
import 'package:clovrlabs_wallet/bloc/backup/backup_actions.dart';
import 'package:clovrlabs_wallet/bloc/backup/backup_bloc.dart';
import 'package:clovrlabs_wallet/bloc/backup/backup_model.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/routes/backup_in_progress_dialog.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/widgets/back_button.dart' as backBtn;
import 'package:clovrlabs_wallet/widgets/error_dialog.dart';
import 'package:clovrlabs_wallet/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  List _randomlySelectedIndexes = [];
  List<String> _mnemonicsList;
  bool _hasError;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final query = MediaQuery.of(context);
    final texts = AppLocalizations.of(context);
    final backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: themeData.appBarTheme.iconTheme,
        textTheme: themeData.appBarTheme.textTheme,
        backgroundColor: themeData.canvasColor,
        automaticallyImplyLeading: false,
        leading: backBtn.BackButton(),
        title: Text(
          texts.backup_phrase_generation_verify,
          // style: themeData.appBarTheme.textTheme.headline6,
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                  return _buildBackupBtn(context, snapshot.data, backupBloc);
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
    BuildContext context,
    BackupSettings backupSettings,
    BackupBloc backupBloc,
  ) {
    final texts = AppLocalizations.of(context);
    return SingleButtonBottomBar(
      text: texts.backup_phrase_warning_action_backup,
      onPressed: () {
        setState(() {
          _hasError = false;
        });
        if (_formKey.currentState.validate() && !_hasError) {
          _createBackupPhrase(context, backupSettings, backupBloc);
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
    final texts = AppLocalizations.of(context);
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
          color: theme.ClovrLabsWalletColors.white[300],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildVerificationFormContent(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
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
              if (text.length == 0 ||
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
      selectedWordList
        ..add(Text(
          texts.backup_phrase_generation_verification_failed,
          style: themeData.textTheme.headline4.copyWith(
            fontSize: 12,
          ),
        ));
    }
    return selectedWordList;
  }

  Future _createBackupPhrase(
    BuildContext context,
    BackupSettings backupSettings,
    BackupBloc backupBloc,
  ) async {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    final saveBackupKey = SaveBackupKey(
      bip39.mnemonicToEntropy(widget._mnemonics),
    );
    backupBloc.backupActionsSink.add(saveBackupKey);
    saveBackupKey.future.then((_) {
      _updateBackupSettings(
        context,
        backupSettings.copyWith(
          keyType: BackupKeyType.PHRASE,
        ),
        backupBloc,
      );
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
    BuildContext context,
    BackupSettings backupSettings,
    BackupBloc backupBloc,
  ) async {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);
    var action = UpdateBackupSettings(backupSettings);
    backupBloc.backupActionsSink.add(action);
    Navigator.popUntil(context, ModalRoute.withName("/security"));
    action.future.then((_) {
      backupBloc.backupNowSink.add(true);
      backupBloc.backupStateStream.firstWhere((s) => s.inProgress).then((s) {
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
      });
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
}
