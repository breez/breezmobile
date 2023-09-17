import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/nostr/nostr_actions.dart';
import 'package:breez/bloc/nostr/nostr_bloc.dart';
import 'package:breez/bloc/nostr/nostr_model.dart';
import 'package:breez/routes/nostr/nostr_relays.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/logout_warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../bloc/nostr/nostr_actions.dart';
import '../../utils/min_font_size.dart';
import '../../widgets/logout_warning_dialog.dart';
import 'nostr_relays.dart';
import 'nostr_connect_page.dart';

class NostrKeysPage extends StatefulWidget {
  final NostrBloc nostrBloc;
  final NostrSettings settings;
  const NostrKeysPage({
    Key key,
    this.nostrBloc,
    this.settings,
  }) : super(key: key);

  @override
  State<NostrKeysPage> createState() => _NostrKeysPageState();
}

class _NostrKeysPageState extends State<NostrKeysPage> {
  final _autoSizeGroup = AutoSizeGroup();
  String _nostrPublicKey;
  String _nostrPrivateKey;

  @override
  void initState() {
    super.initState();
    _fetchKeys();
  }

  Future<void> _fetchKeys() async {
    try {
      // call nostr_bloc method to get keys
      widget.nostrBloc.actionsSink.add(GetPublicKey());
      _nostrPublicKey = await widget.nostrBloc.publicKeyStream.first;
      _nostrPrivateKey = widget.nostrBloc.nostrPrivateKey;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _logout() async {
    bool isLogout = await _showLogoutWarningDialog();

    if (isLogout) {
      widget.nostrBloc.nostrSettingsSettingsSink.add(
        widget.settings.copyWith(isLoggedIn: false),
      );

      if (context.mounted) Navigator.pop(context);
    }
  }

  Future _showLogoutWarningDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return LogoutWarningDialog(
            logout: _logout,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nostr"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: AutoSizeText(
              "Export Public Key",
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              group: _autoSizeGroup,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: _nostrPublicKey,
                  ),
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: AutoSizeText(
              "Export Private Key",
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              group: _autoSizeGroup,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(
                    text: _nostrPrivateKey,
                  ),
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: AutoSizeText(
              "Relays",
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              group: _autoSizeGroup,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NostrRelays(
                    settings: widget.settings,
                    nostrBloc: widget.nostrBloc,
                  ),
                ),
              );
            },
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          const Divider(),
          ListTile(
            title: AutoSizeText(
              "Nostr Connect",
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              group: _autoSizeGroup,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NostrConnectPage(
                    nostrBloc: widget.nostrBloc,
                  ),
                ),
              );
            },
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          const Divider(),
          ListTile(
            title: AutoSizeText(
              "Nostr Connect",
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              group: _autoSizeGroup,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NostrConnectPage(
                    nostrBloc: widget.nostrBloc,
                  ),
                ),
              );
            },
            trailing: const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 30.0,
            ),
          ),
          const Divider(),
          ListTile(
            title: AutoSizeText(
              "Logout",
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              group: _autoSizeGroup,
            ),
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );
  }
}
