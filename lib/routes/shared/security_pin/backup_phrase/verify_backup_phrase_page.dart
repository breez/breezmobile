import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/shared/backup_in_progress_dialog.dart';
import 'package:breez/routes/shared/security_pin/backup_phrase/generate_backup_phrase_page.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

class VerifyBackupPhrasePage extends StatefulWidget {
  final String _mnemonics;
  final List randomlySelectedIndexes;
  final List<String> verificationFormValues;

  VerifyBackupPhrasePage(this._mnemonics, {this.randomlySelectedIndexes, this.verificationFormValues});

  @override
  VerifyBackupPhrasePageState createState() => new VerifyBackupPhrasePageState();
}

class VerifyBackupPhrasePageState extends State<VerifyBackupPhrasePage> {
  final _formKey = GlobalKey<FormState>();
  String _title;
  List _randomlySelectedIndexes = List();
  List<String> _verificationFormValues;
  List<String> _mnemonicsList;

  @override
  void initState() {
    _verificationFormValues = widget.verificationFormValues ?? List();
    _mnemonicsList = widget._mnemonics.split(" ");
    _title = "Let's verify";
    if (widget.randomlySelectedIndexes != null) {
      _randomlySelectedIndexes = widget.randomlySelectedIndexes;
    } else {
      _selectIndexes();
    }
    super.initState();
  }

  _selectIndexes() {
    List list = List.generate(23, (i) => i);
    list.shuffle();
    for (var i = 0; i < 3; i++) {
      _randomlySelectedIndexes.add(list[i]);
    }
    _randomlySelectedIndexes.sort();
  }

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
          leading: backBtn.BackButton(
            onPressed: () {
              Navigator.push(
                context,
                FadeInRoute(
                  builder: (_) => GenerateBackupPhrasePage(
                    mnemonics: widget._mnemonics,
                    page: 2,
                    randomlySelectedIndexes: _randomlySelectedIndexes,
                    verificationFormValues: _verificationFormValues,
                  ),
                ),
              );
            },
          ),
          title: new Text(
            _title,
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0),
      body: Column(
        children: <Widget>[
          _buildForm(),
          _buildInstructions(),
        ],
      ),
      bottomNavigationBar: StreamBuilder<BreezUserModel>(
        stream: userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return _buildBackupBtn(snapshot.data.securityModel, userProfileBloc, backupBloc);
        },
      ),
    );
  }

  Padding _buildInstructions() {
    return Padding(
      padding: EdgeInsets.only(left: 72, top: 96, right: 72),
      child: Text(
        "Type the ${_randomlySelectedIndexes[0] + 1}, ${_randomlySelectedIndexes[1] + 1} and the ${_randomlySelectedIndexes[2] + 1} words of your generated backup phrase",
        style: theme.backupPhraseInformationTextStyle.copyWith(color: theme.BreezColors.white[300]),
        textAlign: TextAlign.center,
      ),
    );
  }

  _buildForm() {
    return Form(
      key: _formKey,
      onChanged: () => _formKey.currentState.save(),
      child: new Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            _randomlySelectedIndexes.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  initialValue: exceptionAware<String>(() => widget.verificationFormValues.elementAt(index)) ?? "",
                  decoration: new InputDecoration(
                    labelText: "${_randomlySelectedIndexes[index] + 1}",
                  ),
                  style: theme.FieldTextStyle.textStyle,
                  onSaved: (text) => _verificationFormValues.insert(index, text),
                  validator: (text) {
                    if (text.length == 0) {
                      return "Please fill all fields";
                    }
                    if (text.toLowerCase().trim() != _mnemonicsList[_randomlySelectedIndexes[index]]) {
                      return "False word";
                    }
                    return null;
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  T exceptionAware<T>(T Function() f) {
    try {
      return f();
    } catch (_) {
      return null;
    }
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
              if (_formKey.currentState.validate()) {
                _updateBackupPhrase(userProfileBloc, backupBloc);
              }
            },
          ),
        )
      ]),
    );
  }

  Future _updateBackupPhrase(UserProfileBloc userProfileBloc, BackupBloc backupBloc) async {
    var action = UpdateBackupPhrase(widget._mnemonics);
    userProfileBloc.userActionsSink.add(action);
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
      promptError(
          context,
          "Internal Error",
          Text(
            err.toString(),
            style: theme.alertStyle,
          ));
    });
  }
}
