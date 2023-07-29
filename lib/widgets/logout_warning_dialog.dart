import 'package:flutter/material.dart';

class LogoutWarningDialog extends StatefulWidget {
  final Function logout;
  const LogoutWarningDialog({Key key, this.logout}) : super(key: key);

  @override
  State<LogoutWarningDialog> createState() => _LogoutWarningDialogState();
}

class _LogoutWarningDialogState extends State<LogoutWarningDialog> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Theme(
      data: themeData.copyWith(
        unselectedWidgetColor: themeData.canvasColor,
      ),
      child: AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
        title: Text(
          "Logout",
          style: themeData.dialogTheme.titleTextStyle,
        ),
        contentPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
        content: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 12.0),
          child: Text(
            "Important: please export your private key before logging out. You won't be able to login again into your account without it. Are you sure you want to logout now?",
            style: themeData.primaryTextTheme.displaySmall.copyWith(
              fontSize: 16,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'NO',
              style: themeData.primaryTextTheme.labelLarge,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              'YES',
              style: themeData.primaryTextTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
