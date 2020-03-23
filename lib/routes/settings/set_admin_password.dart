import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

class SetAdminPasswordPage extends StatefulWidget {
  final String submitAction;

  const SetAdminPasswordPage({Key key, @required this.submitAction})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SetAdminPasswordState();
  }
}

class _SetAdminPasswordState extends State<SetAdminPasswordPage> {
  TextEditingController _passwordController = new TextEditingController();
  bool _passwordObscured = true;
  bool _repeatPasswordObscured = true;
  TextEditingController _repeatPasswordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _repeatPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _passwordFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    UserProfileBloc userProfileBloc =
        AppBlocsProvider.of<UserProfileBloc>(context);
    return Scaffold(
        appBar: AppBar(
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
            textTheme: Theme.of(context).appBarTheme.textTheme,
            backgroundColor: Theme.of(context).canvasColor,
            automaticallyImplyLeading: false,
            leading: backBtn.BackButton(),
            title: Text(
              "Manager Password",
              style: Theme.of(context).appBarTheme.textTheme.headline6,
            ),
            elevation: 0.0),
        body: Padding(
          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    focusNode: _passwordFocus,
                    obscureText: _passwordObscured,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      _repeatPasswordFocus.requestFocus();
                    },
                    validator: (value) {
                      if (value.length == 0) {
                        return "Password is required";
                      }

                      if (value.length < 8) {
                        return "At least 8 characters are required";
                      }
                    },
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: "Enter a new password",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              _passwordObscured = !_passwordObscured;
                            });
                          },
                        )),
                    style: theme.FieldTextStyle.textStyle,
                    textCapitalization: TextCapitalization.words,
                  ),
                  SizedBox(height: 12.0),
                  TextFormField(
                    obscureText: _repeatPasswordObscured,
                    focusNode: _repeatPasswordFocus,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        labelText: "Confirm password",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              _repeatPasswordObscured =
                                  !_repeatPasswordObscured;
                            });
                          },
                        )),
                    controller: _repeatPasswordController,
                    style: theme.FieldTextStyle.textStyle,
                    textCapitalization: TextCapitalization.words,
                    onFieldSubmitted: (_) {
                      _formKey.currentState.validate();
                    },
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return "Passwords don't match";
                      }
                    },
                  )
                ],
              )),
        ),
        bottomNavigationBar: SingleButtonBottomBar(
            text: widget.submitAction,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                SetAdminPassword action =
                    SetAdminPassword(_passwordController.text);
                userProfileBloc.userActionsSink.add(action);
                await action.future;
                Navigator.of(context).pop();
              }
            }));
  }
}
