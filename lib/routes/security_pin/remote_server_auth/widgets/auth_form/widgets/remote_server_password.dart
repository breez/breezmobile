import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class RemoteServerPassword extends StatefulWidget {
  final TextEditingController passwordController;
  final bool failAuthenticate;

  const RemoteServerPassword({
    Key key,
    @required this.passwordController,
    @required this.failAuthenticate,
  }) : super(key: key);

  @override
  State<RemoteServerPassword> createState() => _RemoteServerPasswordState();
}

class _RemoteServerPasswordState extends State<RemoteServerPassword> {
  bool passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return TextFormField(
      validator: (value) {
        if (widget.failAuthenticate) {
          return texts.remote_server_error_invalid_username_or_password;
        }
        return null;
      },
      controller: widget.passwordController,
      minLines: 1,
      maxLines: 1,
      obscureText: passwordObscured,
      decoration: InputDecoration(
        hintText: texts.remote_server_server_password_hint,
        labelText: texts.remote_server_server_password_label,
        suffixIcon: IconButton(
          icon: const Icon(Icons.remove_red_eye),
          onPressed: () {
            setState(() {
              passwordObscured = !passwordObscured;
            });
          },
        ),
      ),
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}
