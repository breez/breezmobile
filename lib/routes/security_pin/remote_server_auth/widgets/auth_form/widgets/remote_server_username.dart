import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class RemoteServerUserName extends StatelessWidget {
  const RemoteServerUserName({
    Key key,
    @required this.failAuthenticate,
    @required this.userController,
  }) : super(key: key);

  final bool failAuthenticate;
  final TextEditingController userController;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return TextFormField(
      validator: (value) {
        if (failAuthenticate) {
          return texts.remote_server_error_invalid_username_or_password;
        }
        return null;
      },
      controller: userController,
      minLines: 1,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: texts.remote_server_server_username_hint,
        labelText: texts.remote_server_server_username_label,
      ),
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}
