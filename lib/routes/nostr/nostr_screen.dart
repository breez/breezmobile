import 'dart:async';

import 'package:breez/bloc/marketplace/marketplace_bloc.dart';
import 'package:breez/bloc/marketplace/nostr_settings.dart';
import 'package:breez/bloc/nostr/nostr_bloc.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';

import '../../bloc/nostr/nostr_actions.dart';
import 'import_private_key.dart';
import 'nostr_keys_page.dart';

class NostrScreen extends StatefulWidget {
  final NostrBloc nostrBloc;
  final MarketplaceBloc marketplaceBloc;
  const NostrScreen({Key key, this.nostrBloc, this.marketplaceBloc})
      : super(key: key);

  @override
  State<NostrScreen> createState() => _NostrScreenState();
}

class _NostrScreenState extends State<NostrScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _deleteKeys() async {
    widget.nostrBloc.actionsSink.add(DeleteKey());
  }

  Future<void> _login(NostrSettings settings) async {
    await _deleteKeys().then((value) => {
          widget.marketplaceBloc.nostrSettingsSettingsSink.add(
            settings.copyWith(isLoggedIn: true),
          )
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NostrSettings>(
        stream: widget.marketplaceBloc.nostrSettingsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.data.isLoggedIn) {
            return NostrKeysPage(
              nostrBloc: widget.nostrBloc,
              marketplaceBloc: widget.marketplaceBloc,
              settings: snapshot.data,
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("Nostr"),
            ),
            body: ListView(
              children: [
                ListTile(
                    title: const Text("Create New Account"),
                    onTap: () {
                      _login(snapshot.data);
                    }),
                const Divider(),
                ListTile(
                  title: const Text("Import Existing Key"),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ImportPrivateKeyPage(
                          marketplaceBloc: widget.marketplaceBloc,
                          nostrBloc: widget.nostrBloc,
                          settings: snapshot.data,
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
              ],
            ),
          );
        });
  }
}
