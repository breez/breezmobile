import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/nostr/nostr_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../bloc/app_blocs.dart';
import '../../bloc/nostr/nostr_actions.dart';
import 'nostr_keys_page.dart';

class NostrScreen extends StatefulWidget {
  const NostrScreen({Key key}) : super(key: key);

  @override
  State<NostrScreen> createState() => _NostrScreenState();
}

class _NostrScreenState extends State<NostrScreen> {
  NostrBloc _nostrBloc;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String _nostrPublicKey;
  String _nostrPrivateKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nostrBloc = AppBlocsProvider.of<NostrBloc>(context);
    });
  }

  void _fetchKeys() async {
    _nostrPublicKey = await _secureStorage.read(key: "nostrPublicKey");

    if (_nostrPublicKey == null) {
      _nostrBloc.actionsSink.add(GetPublicKey());
      _nostrPublicKey = await _nostrBloc.publicKeyStream.first;
    }

    _nostrPrivateKey = await _secureStorage.read(key: "nostrPrivateKey");
  }

  void _generateKeys(BuildContext context) {
    // check whether keys exist

    _fetchKeys();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NostrKeysPage(
          publicKey: _nostrPublicKey,
          privateKey: _nostrPrivateKey,
        ),
      ),
    );
    // call nostr_bloc method to generate keys
  }

  void _importKeys() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nostr"),
      ),
      body: ListView(
        children: [
          // connect to generate keys to get the keyPair

          // will have to connect to the backend go to store the keys
          // just take the private key

          // clicking will open up a texfield with private key as hint text

          ListTile(
            title: const Text("Create New Account"),
            onTap: () => _generateKeys(context),
          ),
          const Divider(),
          ListTile(
            title: const Text("Import Keys"),
            onTap: () => _importKeys(),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
