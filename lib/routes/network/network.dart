import 'dart:async';
import 'dart:io';

import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
import 'package:breez/widgets/animated_loader_dialog.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/material.dart';

class _NetworkData {
  String peer = '';
  bool isDefault = false;
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
  ScrollController _scrollController = ScrollController();
  final _peerController = TextEditingController();
  _NetworkData _data = _NetworkData();

  @override
  void initState() {
    super.initState();
    _breezLib = ServiceInjector().breezBridge;
    _loadData();
    _peerController.addListener(_onChangePeer);
  }

  @override
  void dispose() {
    _peerController.removeListener(_onChangePeer);
    super.dispose();
  }

  void _loadData() async {
    await _loadPeer();
  }

  Future _loadPeer() async {
    Peers peers = await _breezLib.getPeers();
    String peer = '';
    if (peers.peer.length > 0) {
      peer = peers.peer[0];
    }
    setState(() {
      _data.peer = peer;
      _data.isDefault = peers.isDefault;
    });
    _peerController.text = peer;
  }

  void _onChangePeer() {
    String peer = _peerController.text;
    setState(() {
      _data.peer = peer;
    });
  }

  Future<bool> _promptForRestart(BuildContext context) {
    var l10n = context.l10n;
    DialogTheme dialogTheme = context.dialogTheme;

    return promptAreYouSure(
      context,
      null,
      Text(
        l10n.network_restart_message,
        style: dialogTheme.contentTextStyle,
      ),
      cancelText: l10n.network_restart_action_cancel,
      okText: l10n.network_restart_action_confirm,
    ).then((shouldExit) {
      if (shouldExit) {
        exit(0);
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    ThemeData themeData = context.theme;
    AppBarTheme appBarTheme = themeData.appBarTheme;
    DialogTheme dialogTheme = themeData.dialogTheme;

    return ButtonTheme(
      height: 28.0,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: appBarTheme.iconTheme,
          backgroundColor: themeData.canvasColor,
          toolbarTextStyle: appBarTheme.toolbarTextStyle,
          titleTextStyle: appBarTheme.titleTextStyle,
          automaticallyImplyLeading: false,
          leading: backBtn.BackButton(),
          title: Text(l10n.network_title),
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: l10n.network_bitcoin_node,
                        ),
                        style: theme.FieldTextStyle.textStyle,
                        onSaved: (String value) {
                          this._data.peer = value;
                        },
                        validator: (val) => null,
                        controller: _peerController,
                      ),
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
                          child: Text(
                            l10n.network_restart_action_reset,
                          ),
                          onPressed: () async {
                            var error = await showDialog(
                              useRootNavigator: false,
                              context: context,
                              builder: (ctx) => _TestingPeerDialog(
                                testFuture: _breezLib.testPeer(""),
                              ),
                            );

                            if (error != null) {
                              await promptError(
                                context,
                                null,
                                Text(
                                  l10n.network_default_node_error,
                                  style: dialogTheme.contentTextStyle,
                                ),
                              );
                              return;
                            } else {
                              await _reset();
                            }
                            _promptForRestart(context);
                          },
                        ),
                        SizedBox(width: 12.0),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white),
                            primary: Colors.white,
                          ),
                          child: Text(
                            l10n.network_restart_action_save,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              if (this._data.peer.isNotEmpty) {
                                var error = await showDialog(
                                  useRootNavigator: false,
                                  context: context,
                                  builder: (ctx) => _TestingPeerDialog(
                                    testFuture: _breezLib.testPeer(
                                      this._data.peer,
                                    ),
                                  ),
                                );

                                if (error != null) {
                                  await promptError(
                                    context,
                                    null,
                                    Text(
                                      l10n.network_custom_node_error,
                                      style: dialogTheme.contentTextStyle,
                                    ),
                                  );
                                  return;
                                } else {
                                  await _breezLib.setPeers([
                                    this._data.peer,
                                  ]);
                                }
                              } else {
                                await _reset();
                              }
                              await _promptForRestart(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _reset() async {
    await _breezLib.setPeers([]);
    return _loadData();
  }
}

class _TestingPeerDialog extends StatefulWidget {
  final Future testFuture;

  const _TestingPeerDialog({
    Key key,
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
    widget.testFuture.then((_) => context.pop()).catchError((err) {
      _allowPop = true;
      context.pop(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(_allowPop),
      child: createAnimatedLoaderDialog(
        context,
        context.l10n.network_testing_node,
        withOKButton: false,
      ),
    );
  }
}
