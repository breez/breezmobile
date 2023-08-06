import "package:auto_size_text/auto_size_text.dart";
import "package:breez/bloc/marketplace/nostr_settings.dart";
import "package:breez/bloc/nostr/nostr_actions.dart";
import "package:breez/bloc/nostr/nostr_bloc.dart";
import "package:flutter/material.dart";
import 'package:breez/theme_data.dart' as theme;
import "package:flutter_svg/svg.dart";

import "../../bloc/marketplace/marketplace_bloc.dart";
import "../../utils/min_font_size.dart";

class NostrRelays extends StatefulWidget {
  final NostrSettings settings;
  final MarketplaceBloc marketplaceBloc;
  final NostrBloc nostrBloc;
  const NostrRelays({
    Key key,
    this.settings,
    this.marketplaceBloc,
    this.nostrBloc,
  }) : super(key: key);

  @override
  State<NostrRelays> createState() => _NostrRelaysState();
}

class _NostrRelaysState extends State<NostrRelays> {
  final _autoSizeGroup = AutoSizeGroup();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  List<String> relaysList = [];
  @override
  void initState() {
    super.initState();
    _fetchRelays();
  }

  @override
  void dispose() {
    // Dispose the TextEditingController when the widget is removed from the tree.
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _fetchRelays() async {
    setState(() {
      relaysList = widget.settings.relayList;
    });
  }

  Future<void> _saveNewRelays(List<String> newRelays) async {
    widget.settings.copyWith(
      relayList: newRelays,
    );
    await _fetchRelays();
    // call publish relays from here
    widget.nostrBloc.actionsSink.add(PublishRelays(
      userRelayList: newRelays,
    ));
  }

  Future<void> _addRelay(String relay) async {
    relaysList.add(relay);
    // now save the relayList in the preferences
    await _saveNewRelays(relaysList);
  }

  Future<void> _deleteRelay(int ind) async {
    relaysList.removeAt(ind);
    // now save the relayList in the preferences
    await _saveNewRelays(relaysList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nostr"),
      ),
      body: ListView(
        children: [
          ...relaysList.asMap().entries.map(
            (entry) {
              String relay = entry.value;
              int ind = entry.key;
              return Column(
                children: [
                  ListTile(
                    title: AutoSizeText(
                      relay,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      minFontSize: MinFontSize(context).minFontSize,
                      stepGranularity: 0.1,
                      group: _autoSizeGroup,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _deleteRelay(ind);
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                ListTile(
                  title: Container(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Add a new relay"),
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
                    onPressed: () {
                      _addRelay(_textEditingController.text.trim());
                      _textEditingController.clear();
                    },
                    child: const Text("Add"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
