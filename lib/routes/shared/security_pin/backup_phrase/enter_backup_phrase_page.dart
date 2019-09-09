import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
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
  int _currentPage;
  List<String> _mnemonics = List();

  @override
  void initState() {
    _currentPage = 1;
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
              if (_currentPage == 1) {
                Navigator.pop(context);
              } else if (_currentPage > 1) {
                setState(() {
                  _currentPage--;
                });
              }
            },
          ),
          title: new Text(
            "Enter your backup phrase ($_currentPage/4)",
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0),
      body: _buildForm(),
      bottomNavigationBar: _buildBottomBtn(userProfileBloc),
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
          children: List.generate(6, (index) {
            return TextFormField(
              decoration: new InputDecoration(
                labelText: "${index + (6 * (_currentPage - 1)) + 1}",
              ),
              style: theme.FieldTextStyle.textStyle,
              validator: (text) {
                if (text.length == 0) {
                  return "Please fill all fields";
                }
                _mnemonics.add(text);
                return null;
              },
            );
          }),
        ),
      ),
    );
  }

  _buildBottomBtn(UserProfileBloc userProfileBloc) {
    return Padding(
      padding: new EdgeInsets.only(bottom: 40),
      child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        SizedBox(
          height: 48.0,
          width: 168.0,
          child: new RaisedButton(
            child: new Text(
              _currentPage + 1 == 5 ? "RESTORE" : "NEXT",
              style: theme.buttonStyle,
            ),
            color: theme.BreezColors.white[500],
            elevation: 0.0,
            shape: const StadiumBorder(),
            onPressed: () {
              if (_currentPage + 1 == 5) {
                if (_formKey.currentState.validate()) {
                  _validateBackupPhrase(userProfileBloc);
                }
              } else {
                setState(() {
                  _currentPage++;
                });
              }
            },
          ),
        )
      ]),
    );
  }

  Future _validateBackupPhrase(UserProfileBloc userProfileBloc) async {
    var validateAction = ValidateBackupPhrase(_mnemonics.join(" "));
    userProfileBloc.userActionsSink.add(validateAction);
    return validateAction.future.then((_) => Navigator.pop(context));
  }
}
