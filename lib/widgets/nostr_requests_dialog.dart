import 'package:breez/bloc/nostr/nostr_bloc.dart';
import 'package:breez/bloc/nostr/nostr_model.dart';
import 'package:breez/widgets/nostr_get_dialog_content.dart';
import 'package:flutter/material.dart';

class NostrRequestsDialog extends StatefulWidget {
  final NostrBloc nostrBloc;
  final String messageKind;
  final String appName;
  final String textContent;
  final String choiceType;
  const NostrRequestsDialog({
    Key key,
    this.nostrBloc,
    this.messageKind,
    this.appName,
    this.choiceType,
    this.textContent,
  }) : super(key: key);

  @override
  State<NostrRequestsDialog> createState() => _NostrRequestsDialogState();
}

class _NostrRequestsDialogState extends State<NostrRequestsDialog> {
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
          widget.appName,
          style: themeData.dialogTheme.titleTextStyle,
        ),
        contentPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 24.0),
        content: StreamBuilder<NostrSettings>(
            stream: widget.nostrBloc.nostrSettingsStream,
            builder: (context, snapshot) {
              if (snapshot.data == null) return Container();
              return NostrGetDialogContent(
                nostrBloc: widget.nostrBloc,
                streamSnapshot: snapshot,
                textContent: widget.textContent,
                choiceType: widget.choiceType,
              );
            }),
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
}
