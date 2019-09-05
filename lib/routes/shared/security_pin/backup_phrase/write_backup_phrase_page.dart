import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';

class WriteBackupPhrasePage extends StatefulWidget {
  final List<String> _mnemonics;

  WriteBackupPhrasePage(this._mnemonics);

  @override
  WriteBackupPhrasePageState createState() => new WriteBackupPhrasePageState();
}

class WriteBackupPhrasePageState extends State<WriteBackupPhrasePage> {
  final _formKey = GlobalKey<FormState>();
  int _phase;

  @override
  void initState() {
    _phase = 1;
    super.initState();
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
              if (_phase == 1) {
                Navigator.pop(context);
              } else if (_phase > 1) {
                setState(() {
                  _phase--;
                });
              }
            },
          ),
          title: new Text(
            "Enter your backup phrase ($_phase/4)",
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0),
      body: _buildForm(),
      bottomNavigationBar: _buildBottomBtn(),
    );
  }

  _buildForm() {
    return Form(
      key: _formKey,
      child: new Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget._mnemonics.length ~/ 4, (index) {
            return TextFormField(
              decoration: new InputDecoration(
                labelText: "${index + (widget._mnemonics.length ~/ 4 * (_phase - 1)) + 1}",
              ),
              style: theme.FieldTextStyle.textStyle,
              validator: (text) {
                if (text.length == 0) {
                  return "Please fill all fields";
                }
                if (text != widget._mnemonics[index + (widget._mnemonics.length ~/ 4 * (_phase - 1))]) {
                  return "False word";
                }
                return null;
              },
            );
          }),
        ),
      ),
    );
  }

  _buildBottomBtn() {
    return Padding(
      padding: new EdgeInsets.only(bottom: 40),
      child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        SizedBox(
          height: 48.0,
          width: 168.0,
          child: new RaisedButton(
            child: new Text(
              _phase + 1 == 5 ? "RESTORE" : "NEXT",
              style: theme.buttonStyle,
            ),
            color: theme.BreezColors.white[500],
            elevation: 0.0,
            shape: const StadiumBorder(),
            onPressed: () {
              if (_phase + 1 == 5) {
                // Restore
                print("Restored");
              } else {
                setState(() {
                  _phase++;
                });
              }
            },
          ),
        )
      ]),
    );
  }
}
