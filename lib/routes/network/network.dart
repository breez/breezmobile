/* FIXME(nochiel): While the rpc server is starting, client cannot tell if Tor is active.
 Therefore, the switch in the ui shows the incorrect state until the database becomes availabe.
 Should we show a loading icon for the Tor switch?
*/

import 'dart:async';
import 'dart:io';

import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/services/injector.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/animated_loader_dialog.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/utils/min_font_size.dart';

class _NetworkData {
  String peer = '';
  bool isDefault = false;
  bool torIsActive = false;
}

class NetworkPage extends StatefulWidget {
  NetworkPage({Key key}) : super(key: key);

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
  AutoSizeGroup _autoSizeGroup = AutoSizeGroup();

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

    bool torActive = await _breezLib.getTorActive();
    setState(() {
      _data.torIsActive = torActive;
    });
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

  Future<bool> _promptForRestart() {
    return promptAreYouSure(
            context,
            null,
            Text(
                "Please restart Breez to switch to the new Bitcoin Node configuration.",
                style: Theme.of(context).dialogTheme.contentTextStyle),
            cancelText: "CANCEL",
            okText: "EXIT BREEZ")
        .then((shouldExit) {
      if (shouldExit) {
        exit(0);
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String _title = "Network";
    return ButtonTheme(
      height: 28.0,
      child: Scaffold(
        appBar: AppBar(
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
            textTheme: Theme.of(context).appBarTheme.textTheme,
            backgroundColor: Theme.of(context).canvasColor,
            automaticallyImplyLeading: false,
            leading: backBtn.BackButton(),
            title: Text(
              _title,
              style: Theme.of(context).appBarTheme.textTheme.headline6,
            ),
            elevation: 0.0),
        body: Padding(
            padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Form(
                key: _formKey,
                child: ListView(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    children: <Widget>[
                      Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Bitcoin Node (BIP 157)"),
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
                          children: <Widget>[
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white),
                                primary: Colors.white,
                              ),
                              child: Text(
                                "Reset",
                              ),
                              onPressed: () async {
                                var error = await showDialog(
                                    useRootNavigator: false,
                                    context: context,
                                    builder: (ctx) => _TestingPeerDialog(
                                        testFuture: _breezLib.testPeer("")));

                                if (error != null) {
                                  await promptError(
                                      context,
                                      null,
                                      Text(
                                          "Breez is unable to use the default node.",
                                          style: Theme.of(context)
                                              .dialogTheme
                                              .contentTextStyle));
                                  return;
                                } else {
                                  await _reset();
                                }
                                _promptForRestart();
                              },
                            ),
                            SizedBox(width: 12.0),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white),
                                primary: Colors.white,
                              ),
                              child: Text(
                                "Save",
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  if (this._data.peer.isNotEmpty) {
                                    var error = await showDialog(
                                        useRootNavigator: false,
                                        context: context,
                                        builder: (ctx) => _TestingPeerDialog(
                                            testFuture: _breezLib
                                                .testPeer(this._data.peer)));

                                    if (error != null) {
                                      await promptError(
                                          context,
                                          null,
                                          Text(
                                              "Breez is unable to connect to the specified node. Please make sure this node supports BIP 157.",
                                              style: Theme.of(context)
                                                  .dialogTheme
                                                  .contentTextStyle));
                                      return;
                                    } else {
                                      await _breezLib
                                          .setPeers([this._data.peer]);
                                    }
                                  } else {
                                    await _reset();
                                  }
                                  await _promptForRestart();
                                }
                              },
                            )
                          ],
                        )
                      ]),
                      Divider(),
                      ListTile(
                        title: Container(
                          child: AutoSizeText(
                            '${this._data.torIsActive ? "Disable" : "Enable"} Tor',
                            style: TextStyle(color: Colors.white),
                            maxLines: 1,
                            minFontSize: MinFontSize(context).minFontSize,
                            stepGranularity: 0.1,
                            group: _autoSizeGroup,
                          ),
                        ),
                        trailing: Switch(
                          value: this._data.torIsActive,
                          activeColor: Colors.white,
                          onChanged: (bool value) async {
                            var error = await showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (ctx) => _SetTorActiveDialog(
                                    testFuture:
                                        _breezLib.setTorActive(value),
                                    enable: value));

                            print('setTorActive returned with $error');
                            if (error != null) {
                              await promptError(
                                  context,
                                  null,
                                  Text(
                                      'Breez is unable to ${value ? "enable" : "disable"} Tor. Please restart Breez and try again.',
                                      style: Theme.of(context)
                                          .dialogTheme
                                          .contentTextStyle));
                              return;
                            } else {
                              _promptForRestart().then((didRestart) {
                                if (!didRestart) {
                                  setState(() {
                                    this._data.torIsActive = !value;
                                  });
                                }
                              });
                            }
                          },
                        ),
                      )
                    ]))),
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

  const _TestingPeerDialog({Key key, this.testFuture}) : super(key: key);

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
    return WillPopScope(
        onWillPop: () => Future.value(_allowPop),
        child: createAnimatedLoaderDialog(context, "Testing node",
            withOKButton: false));
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
  String _text;

  @override
  void initState() {
    super.initState();
    widget.testFuture.then((_) => Navigator.pop(context)).catchError((err) {
      _allowPop = true;
      Navigator.pop(context, err);
    });
    _text = '${widget.enable ? "Enabling" : "Disabling"} Tor';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Future.value(_allowPop),
        child: createAnimatedLoaderDialog(context, _text, withOKButton: false));
  }
}
