/* FIXME(nochiel): While the rpc server is starting, client cannot tell if Tor is active.
 Therefore, the switch in the ui shows the incorrect state until the database becomes availabe.
 Should we grey out the switch if it can't yet load the correct state?
*/

import 'dart:async';
import 'dart:io';

import 'package:breez/logger.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/animated_loader_dialog.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/designsystem/switch/simple_switch.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class _NetworkData {
  bool torIsActive = false;
  bool showTor = false;
}

class NetworkPage extends StatefulWidget {
  const NetworkPage({
    Key key,
  }) : super(key: key);

  @override
  NetworkPageState createState() {
    return NetworkPageState();
  }
}

class NetworkPageState extends State<NetworkPage> {
  final _formKey = GlobalKey<FormState>();
  BreezBridge _breezLib;
  final _NetworkData _data = _NetworkData();
  List<TextEditingController> peerControllers =
      List<TextEditingController>.generate(2, (_) => TextEditingController());

  Completer loadPeersAction;

  @override
  void initState() {
    super.initState();
    _breezLib = ServiceInjector().breezBridge;

    _loadData();
    _loadPeers();
  }

  void _loadData() async {
    _data.showTor = Platform.isAndroid;
    if (_data.showTor) {
      bool torActive = await _breezLib.getTorActive();
      setState(() {
        _data.torIsActive = torActive;
      });
    }
  }

  Future<void> _loadPeers() async {
    loadPeersAction = Completer();
    Peers peers = await _breezLib.getPeers();
    peers.peer.forEachIndexed(
        (index, peer) => peerControllers.elementAt(index).text = peer);
    loadPeersAction.complete(true);
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return ButtonTheme(
      height: 28.0,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const backBtn.BackButton(),
          title: Text(texts.network_title),
        ),
        body: FutureBuilder(
          future: loadPeersAction.future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Loader(color: Colors.white));
            }
            return Form(
              key: _formKey,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  if (_data.showTor)
                    SimpleSwitch(
                      text: _data.torIsActive
                          ? texts.network_tor_disable
                          : texts.network_tor_enable,
                      switchValue: _data.torIsActive,
                      onChanged: _torSwitchChanged,
                    ),
                  if (_data.showTor) const Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      children: [
                        PeerWidget(
                          peerController: peerControllers[0],
                          validator: (value) {
                            if (value.isEmpty) {
                              return texts.network_bitcoin_node_required_error;
                            }
                            return null;
                          },
                        ),
                        PeerWidget(
                          label: texts.network_optional_node,
                          peerController: peerControllers[1],
                          validator: (value) {
                            if (_areNodesDistinct(value)) {
                              return texts.network_distinct_node_hint;
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                ),
                                onPressed: _resetNodes,
                                child: Text(texts.network_restart_action_reset),
                              ),
                              const SizedBox(width: 12.0),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                ),
                                onPressed: saveNodes,
                                child: Text(texts.network_restart_action_save),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  bool _areNodesDistinct(String value) {
    return peerControllers[0].text.isNotEmpty &&
        peerControllers[0].text.toLowerCase().trim() ==
            value.toLowerCase().trim();
  }

  void _resetNodes() async {
    // Test and reset to default node
    final nodeIsValid = await _testNode();
    if (nodeIsValid) {
      await _breezLib.setPeers([]);
      peerControllers = List<TextEditingController>.generate(
          2, (_) => TextEditingController());
      await _loadPeers();
      setState(() {});
      _promptForRestart();
    }
  }

  Future<bool> _testNode({String peer = "", String nodeError}) async {
    final texts = context.texts();
    final dialogTheme = Theme.of(context).dialogTheme;

    var error = await showDialog(
      useRootNavigator: false,
      context: context,
      builder: (ctx) => _TestingPeerDialog(
        peer: peer,
        testFuture: _breezLib.testPeer(peer),
      ),
    );

    if (error != null) {
      await promptError(
        context,
        null,
        Text(
          nodeError ?? texts.network_default_node_error,
          style: dialogTheme.contentTextStyle,
        ),
      );
    }
    return error == null;
  }

  Future<bool> _promptForRestart() {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return promptAreYouSure(
      context,
      null,
      Text(
        texts.network_restart_message,
        style: themeData.dialogTheme.contentTextStyle,
      ),
      cancelText: texts.network_restart_action_cancel,
      okText: texts.network_restart_action_confirm,
    ).then((shouldExit) {
      if (shouldExit) {
        exit(0);
      }
      return false;
    });
  }

  void saveNodes() async {
    final texts = context.texts();
    if (_formKey.currentState.validate()) {
      final nodeSet = <String>{};
      for (var peerData in peerControllers) {
        if (peerData.text.isNotEmpty) {
          nodeSet.add(peerData.text);
        }
      }

      try {
        if (nodeSet.isNotEmpty) {
          // Validate nodes sequentially
          await Future.forEach(nodeSet, (node) async {
            final nodeIsValid = await _testNode(
              peer: node,
              nodeError: texts.network_custom_node_error,
            );
            if (!nodeIsValid) {
              throw Exception(texts.network_custom_node_error);
            }
          });
          await _breezLib.setPeers(nodeSet.toList());
          _promptForRestart();
        } else {
          _resetNodes();
        }
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> _torSwitchChanged(bool value) async {
    final texts = context.texts();
    final themeData = Theme.of(context);

    final error = await showDialog(
      useRootNavigator: false,
      context: context,
      builder: (ctx) => _SetTorActiveDialog(
        testFuture: _breezLib.setTorActive(value),
        enable: value,
      ),
    );

    if (error != null) {
      log.info('setTorActive error', error);
      await promptError(
        context,
        null,
        Text(
          value ? texts.network_tor_enable_error : texts.network_tor_disable,
          style: themeData.dialogTheme.contentTextStyle,
        ),
      );
      return;
    } else {
      !value
          ? _resetNodes()
          : _promptForRestart().then((didRestart) {
              if (!didRestart) {
                setState(() {
                  _data.torIsActive = !value;
                });
              }
            });
    }
  }
}

class PeerWidget extends StatelessWidget {
  final TextEditingController peerController;
  final String label;
  final FormFieldValidator<String> validator;

  const PeerWidget({
    Key key,
    @required this.peerController,
    this.label,
    @required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label ?? texts.network_bitcoin_node,
        ),
        style: theme.FieldTextStyle.textStyle,
        controller: peerController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
      ),
    );
  }
}

class _TestingPeerDialog extends StatefulWidget {
  final String peer;
  final Future testFuture;

  const _TestingPeerDialog({
    Key key,
    this.peer,
    this.testFuture,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TestingPeerDialogState();
  }
}

class _TestingPeerDialogState extends State<_TestingPeerDialog> {
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    widget.testFuture.then((_) => Navigator.pop(context)).catchError((err) {
      _allowPop = true;
      Navigator.pop(context, err);
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return WillPopScope(
      onWillPop: () => Future.value(_allowPop),
      child: createAnimatedLoaderDialog(
        context,
        widget.peer.isNotEmpty
            ? "${texts.network_testing_node}: ${widget.peer}"
            : texts.network_testing_node,
        withOKButton: false,
      ),
    );
  }
}

class _SetTorActiveDialog extends StatefulWidget {
  final Future testFuture;
  final bool enable;

  const _SetTorActiveDialog({Key key, this.testFuture, this.enable})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SetTorActiveDialogState();
  }
}

class _SetTorActiveDialogState extends State<_SetTorActiveDialog> {
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    widget.testFuture.then((_) => Navigator.pop(context)).catchError((err) {
      _allowPop = true;
      Navigator.pop(context, err);
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return WillPopScope(
        onWillPop: () => Future.value(_allowPop),
        child: createAnimatedLoaderDialog(
            context,
            widget.enable
                ? texts.network_tor_enabling
                : texts.network_tor_disabling,
            withOKButton: false));
  }
}
