import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/logout_warning_dialog.dart';

class NostrKeysPage extends StatefulWidget {
  final String publicKey;
  final String privateKey;
  const NostrKeysPage({Key key, this.publicKey, this.privateKey})
      : super(key: key);

  @override
  State<NostrKeysPage> createState() => _NostrKeysPageState();
}

class _NostrKeysPageState extends State<NostrKeysPage> {
  Future<void> _logout() {}
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text("Export Public Key >"),
          subtitle: Text(widget.publicKey),
          trailing: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: widget.publicKey),
              );
            },
          ),
        ),
        ListTile(
          title: const Text("Export Private Key >"),
          subtitle: Text(widget.publicKey),
          trailing: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: widget.privateKey),
              );
            },
          ),
        ),
        TextButton(
            onPressed: () {
              LogoutWarningDialog(logout: _logout);
            },
            child: const Text("Logout"))
      ],
    );
  }
}
