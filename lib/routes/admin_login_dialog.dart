import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

Future protectAdminAction(
    BuildContext context, BreezUserModel user, Future onNext()) async {
  if (user.appMode == AppMode.pos && user.hasAdminPassword) {
    bool loggedIn = await showDialog(
        useRootNavigator: false,
        context: context,
        builder: (c) => _AdminLoginDialog());
    if (!loggedIn) {
      return;
    }
  }
  return onNext();
}

Future protectAdminRoute(
    BuildContext context, BreezUserModel user, String route) async {
  if (user.appMode == AppMode.pos && user.hasAdminPassword) {
    bool loggedIn = await showDialog(
        useRootNavigator: false,
        context: context,
        builder: (c) => _AdminLoginDialog());
    if (!loggedIn) {
      return Future.error("Failed to authenticate as manager");
    }
  }
  Navigator.of(context).pushNamed(route);
}

class _AdminLoginDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AdminLoginDialogState();
  }
}

class _AdminLoginDialogState extends State<_AdminLoginDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _passwordObscured = true;
  String _lastError;

  @override
  void initState() {
    super.initState();
    _passwordFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    UserProfileBloc userProfileBloc =
        AppBlocsProvider.of<UserProfileBloc>(context);
    return AlertDialog(
      title: Text("Manager Password"),
      content: Theme(
        data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
                enabledBorder:
                    UnderlineInputBorder(borderSide: theme.greyBorderSide)),
            hintColor: Theme.of(context).dialogTheme.contentTextStyle.color,
            accentColor: Theme.of(context).textTheme.button.color,
            primaryColor: Theme.of(context).textTheme.button.color,
            errorColor: theme.themeId == "BLUE"
                ? Colors.red
                : Theme.of(context).errorColor),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100.0,
          child: ListView(
            shrinkWrap: true,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  style: TextStyle(
                      color:
                          Theme.of(context).primaryTextTheme.headline4.color),
                  focusNode: _passwordFocus,
                  obscureText: _passwordObscured,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _passwordFocus.requestFocus();
                  },
                  onChanged: (_) {
                    if (_lastError != null) {
                      setState(() {
                        _lastError = null;
                      });
                    }
                  },
                  validator: (value) {
                    if (value.length == 0) {
                      return "Password is required";
                    }
                    return _lastError;
                  },
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: "Enter your password",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            _passwordObscured = !_passwordObscured;
                          });
                        },
                      )),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child:
              Text("CANCEL", style: Theme.of(context).primaryTextTheme.button),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text("OK", style: Theme.of(context).primaryTextTheme.button),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              try {
                var action = VerifyAdminPassword(_passwordController.text);
                userProfileBloc.userActionsSink.add(action);
                bool verified = await action.future;
                if (!verified) {
                  throw "Incorrect Password";
                }
                Navigator.of(context).pop(true);
              } catch (err) {
                setState(() {
                  _lastError = err.toString();
                  _formKey.currentState.validate();
                });
              }
            }
          },
        ),
      ],
    );
  }
}
