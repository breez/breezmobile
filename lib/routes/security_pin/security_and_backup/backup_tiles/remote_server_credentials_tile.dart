import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';

class RemoteServerCredentialsTile extends StatefulWidget {
  final AutoSizeGroup autoSizeGroup;
  final Future Function() enterRemoteServerCredentials;

  const RemoteServerCredentialsTile({
    @required this.autoSizeGroup,
    @required this.enterRemoteServerCredentials,
  });

  @override
  State<RemoteServerCredentialsTile> createState() => _RemoteServerCredentialsTileState();
}

class _RemoteServerCredentialsTileState extends State<RemoteServerCredentialsTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: AutoSizeText(
        BackupProvider.remoteServer().displayName,
        style: const TextStyle(color: Colors.white),
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
        group: widget.autoSizeGroup,
      ),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        color: Colors.white,
        size: 30.0,
      ),
      onTap: widget.enterRemoteServerCredentials,
    );
  }
}
