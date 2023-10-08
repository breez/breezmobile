import 'package:flutter/material.dart';

class NostrConnectDialog extends StatefulWidget {
  final Map<String, dynamic> metadata;
  final bool connect;
  const NostrConnectDialog({
    Key key,
    this.metadata,
    this.connect,
  }) : super(key: key);

  @override
  State<NostrConnectDialog> createState() => _NostrConnectDialogState();
}

class _NostrConnectDialogState extends State<NostrConnectDialog> {
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
          'Nostr Connect',
          style: themeData.dialogTheme.titleTextStyle,
        ),
        contentPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
        content: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 12.0),
          child: Text(
            widget.connect
                ? 'Do you want to connect to ${widget.metadata['name']} using your Nostr credentials?'
                : 'Do you want to disconnect from ${widget.metadata['name']}?',
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
