import 'dart:math';

import 'package:breez/routes/shared/security_pin/backup_phrase/generate_backup_phrase_page.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

class VerifyBackupPhrasePage extends StatefulWidget {
  final List<String> _mnemonics;
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

  @override
  void initState() {
    _verificationFormValues = widget.verificationFormValues ?? List();

    _title = "Let's verify";
    if (widget.randomlySelectedIndexes != null) {
      _randomlySelectedIndexes = widget.randomlySelectedIndexes;
    } else {
      _selectIndexes();
    }
    super.initState();
  }

  _selectIndexes() {
    for (var i = 0; i < 3; i++) {
      int min = 0;
      int max = 23;
      _randomlySelectedIndexes.add(min + Random().nextInt(max - min));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    phase: 2,
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
      bottomNavigationBar: _buildBackupBtn(),
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
                  initialValue: widget.verificationFormValues?.elementAt(index) ?? "",
                  decoration: new InputDecoration(
                    labelText: "${_randomlySelectedIndexes[index] + 1}",
                  ),
                  style: theme.FieldTextStyle.textStyle,
                  onSaved: (text) => _verificationFormValues.insert(index, text),
                  validator: (text) {
                    if (text.length == 0) {
                      return "Please fill all fields";
                    }
                    if (text != widget._mnemonics[_randomlySelectedIndexes[index]]) {
                      print(widget._mnemonics[_randomlySelectedIndexes[index]]);
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

  _buildBackupBtn() {
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
                // Verify
                print("Verified");
              }
            },
          ),
        )
      ]),
    );
  }
}
