import 'package:breez/bloc/nostr/nostr_bloc.dart';
import 'package:breez/routes/nostr/nostr_keys_page.dart';
import 'package:flutter/material.dart';

import 'package:breez/theme_data.dart' as theme;
import 'package:nostr_tools/nostr_tools.dart';

import '../../bloc/marketplace/marketplace_bloc.dart';
import '../../bloc/marketplace/nostr_settings.dart';
import '../../bloc/nostr/nostr_actions.dart';

class ImportPrivateKeyPage extends StatefulWidget {
  final MarketplaceBloc marketplaceBloc;
  final NostrBloc nostrBloc;
  final NostrSettings settings;
  // final Future login;
  const ImportPrivateKeyPage({
    Key key,
    this.marketplaceBloc,
    this.nostrBloc,
    this.settings,
    // this.login,
  }) : super(key: key);

  @override
  State<ImportPrivateKeyPage> createState() => _ImportPrivateKeyPageState();
}

class _ImportPrivateKeyPageState extends State<ImportPrivateKeyPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePrivKey = true;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  final _keyGenerator = KeyApi();
  final _nip19 = Nip19();

  Future<void> _savePrivateKey(String privateKey) async {
    widget.nostrBloc.actionsSink
        .add(StoreImportedPrivateKey(privateKey: privateKey));

    widget.marketplaceBloc.nostrSettingsSettingsSink.add(
      widget.settings.copyWith(isLoggedIn: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nostr"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  ListTile(
                    title: Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Paste a private Key"),
                        style: theme.FieldTextStyle.textStyle,
                        controller: _textEditingController,
                        focusNode: _focusNode,
                        obscureText: _obscurePrivKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "This field is required";
                          }
                          try {
                            bool isValidHexKey =
                                _keyGenerator.isValidPrivateKey(value);
                            bool isValidNsec =
                                value.trim().startsWith('nsec') &&
                                    _keyGenerator.isValidPrivateKey(
                                        _nip19.decode(value)['data']);

                            if (!(isValidHexKey || isValidNsec)) {
                              return 'Your private key is not valid.';
                            }
                          } on ChecksumVerificationException catch (e) {
                            return e.message;
                          } catch (e) {
                            return 'Error: $e';
                          }

                          return null;
                        },
                        onTapOutside: (value) {
                          _focusNode.unfocus();
                        },
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(_obscurePrivKey
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePrivKey = !_obscurePrivKey;
                        });
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      onPressed: () {
                        _savePrivateKey(_textEditingController.text.trim());
                        Navigator.pop(context);
                      },
                      child: const Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
