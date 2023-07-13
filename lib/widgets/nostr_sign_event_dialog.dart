import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NostrSignEventDialog extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final String eventContent;
  final String messageKind;
  final String appName;

  const NostrSignEventDialog({
    Key key,
    this.eventData,
    this.eventContent,
    this.messageKind,
    this.appName,
  }) : super(key: key);

  @override
  State<NostrSignEventDialog> createState() => _NostrSignEventDialogState();
}

class _NostrSignEventDialogState extends State<NostrSignEventDialog> {
  bool _rememberChoice = false;

  void _handleRememberMe(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberSignEventChoice', value);
    setState(() {
      _rememberChoice = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Theme(
      data: themeData.copyWith(
        unselectedWidgetColor: themeData.canvasColor,
      ),
      child: AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
        title: Text(
          widget.appName,
          style: themeData.dialogTheme.titleTextStyle,
        ),
        contentPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _getContent(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'CANCEL',
              style: themeData.primaryTextTheme.labelLarge,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              'CONFIRM',
              style: themeData.primaryTextTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getContent(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    return [
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 12.0),
        child: Text(
          '${widget.appName} requires you to sign this ${widget.messageKind} with your nostr key.',
          style: themeData.primaryTextTheme.displaySmall.copyWith(
            fontSize: 16,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 0.0),
        child: Row(
          children: [
            Theme(
              data: themeData.copyWith(
                unselectedWidgetColor: themeData.textTheme.labelLarge.color,
              ),
              child: Checkbox(
                activeColor: themeData.canvasColor,
                value: _rememberChoice,
                onChanged: _handleRememberMe,
              ),
            ),
            Text(
              'Don\'t prompt again',
              style: themeData.primaryTextTheme.displaySmall.copyWith(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
