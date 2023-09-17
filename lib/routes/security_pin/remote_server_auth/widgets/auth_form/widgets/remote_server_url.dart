import 'package:breez/bloc/backup/backup_model.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class RemoteServerURL extends StatelessWidget {
  const RemoteServerURL({
    Key key,
    @required this.urlController,
    @required this.failDiscoverURL,
    @required this.failNoBackupFound,
  }) : super(key: key);

  final TextEditingController urlController;
  final bool failDiscoverURL;
  final bool failNoBackupFound;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return TextFormField(
      controller: urlController,
      minLines: 1,
      maxLines: 1,
      validator: (value) {
        final validURL = isURL(
          value,
          protocols: ['https', 'http'],
          requireProtocol: true,
          allowUnderscore: true,
        );
        if (!failDiscoverURL && validURL) {
          return null;
        }
        if (failNoBackupFound) {
          return NoBackupFoundException().toString();
        }
        return texts.remote_server_error_invalid_url;
      },
      decoration: InputDecoration(
        hintText: texts.remote_server_server_url_hint,
        labelText: texts.remote_server_server_url_label,
      ),
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }
}
