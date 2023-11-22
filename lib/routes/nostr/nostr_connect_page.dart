import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/nostr/nostr_actions.dart';
import 'package:breez/bloc/nostr/nostr_bloc.dart';
import 'package:breez/bloc/nostr/nostr_model.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/utils/nostrConnect.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter_svg/svg.dart';

class NostrConnectPage extends StatefulWidget {
  final NostrBloc nostrBloc;
  final NostrSettings settings;
  const NostrConnectPage({Key key, this.settings, this.nostrBloc})
      : super(key: key);

  @override
  State<NostrConnectPage> createState() => _NostrConnectPageState();
}

class _NostrConnectPageState extends State<NostrConnectPage> {
  final _autoSizeGroup = AutoSizeGroup();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<ConnectUri> connectedApps = [];
  bool isAdd = false;

  @override
  void initState() {
    super.initState();
    _fetchConnectedApps();
  }

  void _fetchConnectedApps() {
    widget.nostrBloc.nostrSettingsStream.listen((settings) {
      setState(() {
        connectedApps = widget.settings.connectedAppsList;
      });
    });
  }

  Future<void> _connectApp(String connectUrl, NostrBloc nostrBloc) async {
    ConnectUri nostrConnectUri = fromConnectUri(connectUrl);

    bool connect = await approveConnectDialog(context, nostrConnectUri);

    if (!connect) return;

    final nip46ConnectAction = Nip46Connect(
      connectUri: nostrConnectUri,
      nostrBloc: nostrBloc,
    );
    // Add the Nip46Connect action to the sink.
    nostrBloc.actionsSink.add(nip46ConnectAction);
  }

  Future<void> _disconnectApp(
      ConnectUri nostrConnectUri, NostrBloc nostrBloc) async {
    bool disconnect = await approveDisconnectDialog(context, nostrConnectUri);

    if (!disconnect) return;

    final nip46DisconnectAction = Nip46Disconnect(
      connectUri: nostrConnectUri,
      nostrBloc: nostrBloc,
    );

    // Add the Nip46Disconnect action to the sink.
    nostrBloc.actionsSink.add(nip46DisconnectAction);
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
                  decoration: const InputDecoration(
                      labelText: "Connect to a new Nostr App (NIP-47)"),
                  style: theme.FieldTextStyle.textStyle,
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return value != null ? null : "please enter a value";
                  },
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
                  String value = _textEditingController.text.trim();
                  _textEditingController.clear();

                  await _connectApp(value, widget.nostrBloc);
                },
                child: const Text("Connect"),
              ),
            ),
            const Divider(),
            if (connectedApps.isNotEmpty)
              ...connectedApps.asMap().entries.map(
                (entry) {
                  ConnectUri app = entry.value;
                  int ind = entry.key;
                  return Column(
                    children: [
                      ListTile(
                        title: AutoSizeText(
                          app.metadata['name'],
                          style: const TextStyle(color: Colors.white),
                          maxLines: 1,
                          minFontSize: MinFontSize(context).minFontSize,
                          stepGranularity: 0.1,
                          group: _autoSizeGroup,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            ConnectUri connectUri = connectedApps[ind];
                            _disconnectApp(connectUri, widget.nostrBloc);
                          },
                          icon: SvgPicture.asset(
                            "src/icon/trash_icon.svg",
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.clear();
  }
}
