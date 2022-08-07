import 'dart:async';
import 'dart:io';

import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/animated_loader_dialog.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  List<TextEditingController> peerControllers =
      List<TextEditingController>.generate(2, (_) => TextEditingController());

  Completer loadPeersAction;

  @override
  void initState() {
    super.initState();
    _breezLib = ServiceInjector().breezBridge;
    _loadPeers();
  }

  void _loadPeers() async {
    loadPeersAction = Completer();
    Peers peers = await _breezLib.getPeers();
    peers.peer.forEachIndexed(
        (index, peer) => peerControllers.elementAt(index).text = peer);
    loadPeersAction.complete(true);
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return ButtonTheme(
      height: 28.0,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: themeData.appBarTheme.iconTheme,
          textTheme: themeData.appBarTheme.textTheme,
          backgroundColor: themeData.canvasColor,
          automaticallyImplyLeading: false,
          leading: backBtn.BackButton(),
          title: Text(
            texts.network_title,
            style: themeData.appBarTheme.textTheme.headline6,
          ),
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: FutureBuilder(
            future: loadPeersAction.future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Loader(color: Colors.white));
              }

              return Form(
                key: _formKey,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Column(
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
                        SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white),
                                primary: Colors.white,
                              ),
                              child: Text(texts.network_restart_action_reset),
                              onPressed: _resetNodes,
                            ),
                            SizedBox(width: 12.0),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white),
                                primary: Colors.white,
                              ),
                              child: Text(texts.network_restart_action_save),
                              onPressed: saveNodes,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
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
    final texts = AppLocalizations.of(context);
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
    final texts = AppLocalizations.of(context);
    final dialogTheme = Theme.of(context).dialogTheme;

    return promptAreYouSure(
      context,
      null,
      Text(
        texts.network_restart_message,
        style: dialogTheme.contentTextStyle,
      ),
      cancelText: texts.network_restart_action_cancel,
      okText: texts.network_restart_action_confirm,
    ).then((shouldExit) {
      if (shouldExit) {
        exit(0);
      }
      return true;
    });
  }

  void saveNodes() async {
    final texts = AppLocalizations.of(context);
    if (_formKey.currentState.validate()) {
      final nodeSet = Set<String>();
      peerControllers.forEach((peerData) {
        if (peerData.text.isNotEmpty) {
          nodeSet.add(peerData.text);
        }
      });

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
    final texts = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.only(top: 8.0),
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
    final texts = AppLocalizations.of(context);
    return WillPopScope(
      onWillPop: () => Future.value(_allowPop),
      child: createAnimatedLoaderDialog(
        context,
        widget.peer.isNotEmpty
            ? texts.network_testing_node + ": " + widget.peer
            : texts.network_testing_node,
        withOKButton: false,
      ),
    );
  }
}
