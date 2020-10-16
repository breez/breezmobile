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
import 'package:flutter/material.dart';

class VerifyBackupPhrasePage extends StatefulWidget {
  final String _mnemonics;

  VerifyBackupPhrasePage(this._mnemonics);

  @override
  VerifyBackupPhrasePageState createState() => VerifyBackupPhrasePageState();
}

class VerifyBackupPhrasePageState extends State<VerifyBackupPhrasePage> {
  final _formKey = GlobalKey<FormState>();
  List _randomlySelectedIndexes = List();
  List<String> _mnemonicsList;
  bool _hasError;

  @override
  Widget build(BuildContext context) {
    BackupBloc backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    return Scaffold(
      appBar: AppBar(
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          textTheme: Theme.of(context).appBarTheme.textTheme,
          backgroundColor: Theme.of(context).canvasColor,
          automaticallyImplyLeading: false,
          leading: backBtn.BackButton(),
          title: Text(
            "Let's verify",
            style: Theme.of(context).appBarTheme.textTheme.headline6,
          ),
          elevation: 0.0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              kToolbarHeight -
              MediaQuery.of(context).padding.top,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildForm(),
              _buildInstructions(),
              StreamBuilder<BackupSettings>(
                stream: backupBloc.backupSettingsStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(padding: EdgeInsets.only(bottom: 88));
                  }
                  return _buildBackupBtn(snapshot.data, backupBloc);
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

  _buildBackupBtn(BackupSettings backupSettings, BackupBloc backupBloc) {
    return SingleButtonBottomBar(
      text: "BACKUP",
      onPressed: () {
        // reset state
        setState(() {
          _hasError = false;
        });
        if (_formKey.currentState.validate() && !_hasError) {
          _createBackupPhrase(backupSettings, backupBloc);
        }
      },
    );
  }

  _buildForm() {
    return Form(
      key: _formKey,
      onChanged: () => _formKey.currentState.save(),
      child: Padding(
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildVerificationFormContent()),
      ),
    );
  }

  Padding _buildInstructions() {
    return Padding(
      padding: EdgeInsets.only(left: 72, right: 72),
      child: Text(
        "Please type words number ${_randomlySelectedIndexes[0] + 1}, ${_randomlySelectedIndexes[1] + 1} and ${_randomlySelectedIndexes[2] + 1} of the generated backup phrase.",
        style: theme.backupPhraseInformationTextStyle
            .copyWith(color: theme.BreezColors.white[300]),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildVerificationFormContent() {
    List<Widget> selectedWordList = List.generate(
      _randomlySelectedIndexes.length,
      (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: "${_randomlySelectedIndexes[index] + 1}",
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
    if (_hasError)
      selectedWordList
        ..add(Text(
          "Failed to verify words. Please write down the words and try again.",
          style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 12),
        ));
    return selectedWordList;
  }

  Future _createBackupPhrase(
      BackupSettings backupSettings, BackupBloc backupBloc) async {
    var saveBackupKey =
        SaveBackupKey(bip39.mnemonicToEntropy(widget._mnemonics));
    backupBloc.backupActionsSink.add(saveBackupKey);
    saveBackupKey.future.then((_) {
      _updateBackupSettings(
          backupSettings.copyWith(keyType: BackupKeyType.PHRASE), backupBloc);
    }).catchError((err) {
      promptError(
          context,
          "Internal Error",
          Text(
            err.toString(),
            style: Theme.of(context).dialogTheme.contentTextStyle,
          ));
    });
  }

  _selectIndexes() {
    // Select at least one index from each page(0-11,12-23) randomly
    var firstIndex = Random().nextInt(12);
    var secondIndex = Random().nextInt(12) + 12;
    // Select last index randomly from any page, ensure that there are no duplicates and each option has an ~equally likely chance of being selected
    var thirdIndex = Random().nextInt(22);
    if (thirdIndex >= firstIndex) thirdIndex++;
    if (thirdIndex >= secondIndex) thirdIndex++;
    _randomlySelectedIndexes.addAll([firstIndex, secondIndex, thirdIndex]);
    _randomlySelectedIndexes.sort();
  }

  Future _updateBackupSettings(
      BackupSettings backupSettings, BackupBloc backupBloc) async {
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
                  ctx, backupBloc.backupStateStream));
        }
      });
    }).catchError((err) {
      promptError(
          context,
          "Internal Error",
          Text(
            err.toString(),
            style: Theme.of(context).dialogTheme.contentTextStyle,
          ));
    });
  }
}
