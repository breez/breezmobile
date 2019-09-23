import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/shared/backup_in_progress_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;

class VerifyBackupPhrasePage extends StatefulWidget {
  final String _mnemonics;

  VerifyBackupPhrasePage(this._mnemonics);

  @override
  VerifyBackupPhrasePageState createState() => new VerifyBackupPhrasePageState();
}

class VerifyBackupPhrasePageState extends State<VerifyBackupPhrasePage> {
  final _formKey = GlobalKey<FormState>();
  List _randomlySelectedIndexes = List();
  List<String> _mnemonicsList;
  bool _hasError;

  @override
  Widget build(BuildContext context) {
    UserProfileBloc userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    BackupBloc backupBloc = AppBlocsProvider.of<BackupBloc>(context);
    return Scaffold(
      appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: theme.BreezColors.blue[500],
          automaticallyImplyLeading: false,
          leading: backBtn.BackButton(),
          title: new Text(
            "Let's verify",
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildForm(),
              _buildInstructions(),
              StreamBuilder<BreezUserModel>(
                stream: userProfileBloc.userStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(padding: EdgeInsets.only(bottom: 88));
                  }
                  return _buildBackupBtn(snapshot.data.securityModel, userProfileBloc, backupBloc);
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

  _buildBackupBtn(SecurityModel securityModel, UserProfileBloc userProfileBloc, BackupBloc backupBloc) {
    return Padding(
      padding: new EdgeInsets.only(bottom: 40),
      child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        SizedBox(
          height: 48.0,
          width: 168.0,
          child: new RaisedButton(
            child: new Text(
              "BACKUP",
              style: theme.buttonStyle,
            ),
            color: theme.BreezColors.white[500],
            elevation: 0.0,
            shape: const StadiumBorder(),
            onPressed: () {
              // reset state
              setState(() {
                _hasError = false;
              });
              if (_formKey.currentState.validate() && !_hasError) {
                _createBackupPhrase(securityModel, userProfileBloc, backupBloc);
              }
            },
          ),
        )
      ]),
    );
  }

  _buildForm() {
    return Form(
      key: _formKey,
      onChanged: () => _formKey.currentState.save(),
      child: new Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
        child: new Column(
            mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: _buildVerificationFormContent()),
      ),
    );
  }

  Padding _buildInstructions() {
    return Padding(
      padding: EdgeInsets.only(left: 72, right: 72),
      child: Text(
        "Please type words number ${_randomlySelectedIndexes[0] + 1}, ${_randomlySelectedIndexes[1] + 1} and ${_randomlySelectedIndexes[2] + 1} of the generated backup phrase.",
        style: theme.backupPhraseInformationTextStyle.copyWith(color: theme.BreezColors.white[300]),
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
            decoration: new InputDecoration(
              labelText: "${_randomlySelectedIndexes[index] + 1}",
            ),
            style: theme.FieldTextStyle.textStyle,
            validator: (text) {
              if (text.length == 0 || text.toLowerCase().trim() != _mnemonicsList[_randomlySelectedIndexes[index]]) {
                setState(() {
                  _hasError = true;
                });
              }
              return null;
            },
          ),
        );
      },
    );
    if (_hasError)
      selectedWordList
        ..add(Text(
          "Failed to verify words. Please write down the words and try again.",
          style: theme.errorStyle,
        ));
    return selectedWordList;
  }

  Future _createBackupPhrase(SecurityModel securityModel, UserProfileBloc userProfileBloc, BackupBloc backupBloc) async {
    var createBackupPhraseAction = CreateBackupPhrase(bip39.mnemonicToEntropy(widget._mnemonics));
    userProfileBloc.userActionsSink.add(createBackupPhraseAction);
    createBackupPhraseAction.future.then((_) {
      _updateSecurityModel(securityModel, securityModel.copyWith(backupKeyType: BackupKeyType.PHRASE), userProfileBloc, backupBloc);
    }).catchError((err) {
      promptError(context, "Internal Error", Text(err.toString(), style: theme.alertStyle,));
    });
  }

  _selectIndexes() {
    List list = List.generate(23, (i) => i);
    list.shuffle();
    for (var i = 0; i < 3; i++) {
      _randomlySelectedIndexes.add(list[i]);
    }
    _randomlySelectedIndexes.sort();
  }

  Future _updateSecurityModel(
      SecurityModel oldModel, SecurityModel newModel, UserProfileBloc userProfileBloc, BackupBloc backupBloc) async {
    var action = UpdateSecurityModel(newModel);
    userProfileBloc.userActionsSink.add(action);
    Navigator.popUntil(context, ModalRoute.withName("/security"));
    action.future.then((_) {
      backupBloc.backupNowSink.add(true);
      backupBloc.backupStateStream.firstWhere((s) => s.inProgress).then((s) {
        if (mounted) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) => buildBackupInProgressDialog(ctx, backupBloc.backupStateStream));
        }
      });
    }).catchError((err) {
      promptError(context, "Internal Error", Text(err.toString(), style: theme.alertStyle,));
    });
  }
}
