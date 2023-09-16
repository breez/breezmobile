import 'package:breez/routes/security_pin/remote_server_auth/widgets/auth_form/widgets/remote_server_password.dart';
import 'package:breez/routes/security_pin/remote_server_auth/widgets/auth_form/widgets/remote_server_url.dart';
import 'package:breez/routes/security_pin/remote_server_auth/widgets/auth_form/widgets/remote_server_username.dart';
import 'package:flutter/material.dart';

class RemoteServerAuthForm extends StatefulWidget {
  const RemoteServerAuthForm({
    Key key,
    @required this.formKey,
    @required this.urlController,
    @required this.failDiscoverURL,
    @required this.failNoBackupFound,
    @required this.userController,
    @required this.failAuthenticate,
    @required this.passwordController,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController urlController;
  final TextEditingController userController;
  final TextEditingController passwordController;
  final bool failDiscoverURL;
  final bool failNoBackupFound;
  final bool failAuthenticate;

  @override
  State<RemoteServerAuthForm> createState() => _RemoteServerAuthFormState();
}

class _RemoteServerAuthFormState extends State<RemoteServerAuthForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RemoteServerURL(
              urlController: widget.urlController,
              failDiscoverURL: widget.failDiscoverURL,
              failNoBackupFound: widget.failNoBackupFound,
            ),
            RemoteServerUserName(
              userController: widget.userController,
              failAuthenticate: widget.failAuthenticate,
            ),
            RemoteServerPassword(
              passwordController: widget.passwordController,
              failAuthenticate: widget.failAuthenticate,
            ),
          ],
        ),
      ),
    );
  }
}
