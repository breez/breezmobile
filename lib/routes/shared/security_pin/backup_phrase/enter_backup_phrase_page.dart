import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/security_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';

class EnterBackupPhrasePage extends StatefulWidget {
  @override
  EnterBackupPhrasePageState createState() => new EnterBackupPhrasePageState();
}

class EnterBackupPhrasePageState extends State<EnterBackupPhrasePage> {
  final _formKey = GlobalKey<FormState>();
  int _phase;

  @override
  void initState() {
    _phase = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProfileBloc userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

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
      body: StreamBuilder<BreezUserModel>(
          stream: userProfileBloc.userStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return _buildForm(snapshot.data.securityModel);
          }),
      bottomNavigationBar: _buildBottomBtn(),
    );
  }

  _buildForm(SecurityModel securityModel) {
    List<String> mnemonics = securityModel.backupPhrase.split(" ");
    return Form(
      key: _formKey,
      child: new Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(mnemonics.length ~/ 4, (index) {
            return TextFormField(
              decoration: new InputDecoration(
                labelText: "${index + (mnemonics.length ~/ 4 * (_phase - 1)) + 1}",
              ),
              style: theme.FieldTextStyle.textStyle,
              validator: (text) {
                if (text.length == 0) {
                  return "Please fill all fields";
                }
                if (text.toLowerCase().trim() != mnemonics[index + (mnemonics.length ~/ 4 * (_phase - 1))]) {
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
                if (_formKey.currentState.validate()) {
                  print("Restore successful");
                }
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
