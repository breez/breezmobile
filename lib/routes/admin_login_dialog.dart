import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

Future protectAdminAction(
  BuildContext context,
  BreezUserModel user,
  Future Function() onNext,
) async {
  if (user.appMode == AppMode.pos && user.hasAdminPassword) {
    bool loggedIn = await showDialog(
      useRootNavigator: false,
      context: context,
      builder: (c) => _AdminLoginDialog(),
    );
    if (!loggedIn) {
      return;
    }
  }
  return onNext();
}

Future protectAdminRoute(
  BuildContext context,
  BreezUserModel user,
  String route,
) async {
  if (user.appMode == AppMode.pos && user.hasAdminPassword) {
    final texts = context.texts();
    bool loggedIn = await showDialog(
      useRootNavigator: false,
      context: context,
      builder: (c) => _AdminLoginDialog(),
    );
    if (!loggedIn) {
      return Future.error(texts.admin_login_dialog_error_authenticate);
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
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
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
    final themeData = Theme.of(context);
    final texts = context.texts();
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    return AlertDialog(
      title: Text(
        texts.admin_login_dialog_manager_password,
      ),
      content: Theme(
        data: themeData.copyWith(
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: theme.greyBorderSide,
            ),
          ),
          hintColor: themeData.dialogTheme.contentTextStyle.color,
          colorScheme: ColorScheme.dark(
            primary: themeData.textTheme.labelLarge.color,
            error: theme.themeId == "BLUE"
                ? Colors.red
                : themeData.colorScheme.error,
          ),
          primaryColor: themeData.textTheme.labelLarge.color,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 100.0,
          child: ListView(
            shrinkWrap: true,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  style: TextStyle(
                    color: themeData.primaryTextTheme.headlineMedium.color,
                  ),
                  focusNode: _passwordFocus,
                  obscureText: _passwordObscured,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                  onChanged: (_) {
                    if (_lastError != null) {
                      setState(() {
                        _lastError = null;
                      });
                    }
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return texts.admin_login_dialog_error_password_required;
                    }
                    return _lastError;
                  },
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: texts.admin_login_dialog_password_label,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      onPressed: () => setState(() {
                        _passwordObscured = !_passwordObscured;
                      }),
                    ),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            texts.admin_login_dialog_action_cancel,
            style: themeData.primaryTextTheme.labelLarge,
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: Text(
            texts.admin_login_dialog_action_ok,
            style: themeData.primaryTextTheme.labelLarge,
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              try {
                var action = VerifyAdminPassword(_passwordController.text);
                userProfileBloc.userActionsSink.add(action);
                bool verified = await action.future;
                if (!verified) {
                  throw texts.admin_login_dialog_error_password_incorrect;
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
