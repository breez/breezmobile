import 'package:breez/utils/nostrConnect.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

import '../../bloc/nostr/nostr_bloc.dart';

class NostrConnect extends StatefulWidget {
  final NostrBloc nostrBloc;
  const NostrConnect({Key key, this.nostrBloc}) : super(key: key);

  @override
  State<NostrConnect> createState() => _NostrConnectState();
}

class _NostrConnectState extends State<NostrConnect> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<void> _addApp(String connectUrl) async {
    ConnectUri nostrConnectUri = fromConnectUri(connectUrl);
    approveConnectApp(
      nostrConnectUri,
      widget.nostrBloc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nostr"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            ListTile(
              title: Container(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Connect a new app"),
                  style: theme.FieldTextStyle.textStyle,
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (value) {
                  //   return value == null ? value : "please enter a value";
                  // },
                  onTapOutside: (value) {
                    _focusNode.unfocus();
                  },
                ),
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
                onPressed: () async {
                  await _addApp(_textEditingController.text.trim());
                  _textEditingController.clear();
                },
                child: const Text("Connect"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
