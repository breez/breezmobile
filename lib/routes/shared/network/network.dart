import 'package:flutter/material.dart';
import 'dart:async';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/services/injector.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;

class _NetworkData {
  String peer = '';
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
  ScrollController _scrollController = new ScrollController();
  final _peerController = TextEditingController();
  _NetworkData _data = new _NetworkData();

  @override
  void initState() {
    super.initState();
    _breezLib = new ServiceInjector().breezBridge;
    _loadData();
    _peerController.addListener(_onChangePeer);
  }

  void _scroll(double value) {
    setState(() {
      _scrollController.animateTo(
        value,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void _loadData() async {
    await _loadPeer();
  }

  Future _loadPeer() async {
    List<String> peers = await _breezLib.getPeers();
    String peer = '';
    if (peers.length > 0) {
      peer = peers[0];
    }
    setState(() {
      _data.peer = peer;
    });
    _peerController.text = peer;
  }

  void _onChangePeer() {
    String peer = _peerController.text;
    setState(() {
      _data.peer = peer;
    });
  }

  @override
  Widget build(BuildContext context) {
    String _title = "Network Settings";
    return new Scaffold(
      appBar: new AppBar(
          iconTheme: theme.appBarIconTheme,
          textTheme: theme.appBarTextTheme,
          backgroundColor: theme.BreezColors.blue[500],
          automaticallyImplyLeading: false,
          leading: backBtn.BackButton(),
          title: new Text(
            _title,
            style: theme.appBarTextStyle,
          ),
          elevation: 0.0),
      body: new Padding(
          padding: new EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Form(
              key: _formKey,
              child: new ListView(
                scrollDirection: Axis.vertical,
                controller: _scrollController,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.only(top: 8.0),
                        child: new TextFormField(
                          decoration:
                          new InputDecoration(labelText: "Bitcoin Node (BIP157)"),
                          style: theme.FieldTextStyle.textStyle,
                          onSaved: (String value) {
                            this._data.peer = value;
                          },
                          controller: _peerController,
                          validator: (value) {
                            /*if (value.isEmpty) {
                              return "Please enter the Bitcoin Node (BIP157)";
                            }*/
                          },
                        ),
                      ),
                     
                ])]))),
      bottomNavigationBar: new Padding(
          padding: new EdgeInsets.only(bottom: 40.0),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new SizedBox(
                  height: 48.0,
                  width: 168.0,
                  child: new RaisedButton(
                    child: new Text(
                      "Save",
                      style: theme.buttonStyle,
                    ),
                    color: theme.BreezColors.white[500],
                    elevation: 0.0,
                    shape: const StadiumBorder(),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        if (this._data.peer.isNotEmpty) {
                          _breezLib.setPeers([this._data.peer]);
                        } else {
                          _breezLib.setPeers([]);
                        }
                      } else {}
                    },
                  ))
            ],
          )),
    );
  }
}
