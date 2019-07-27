import 'dart:typed_data';

import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LockScreen extends StatefulWidget {
  final String title;
  final bool dismissible;
  final bool changePassword;
  final bool setPassword;

  LockScreen({Key key, this.title, this.dismissible = false, this.changePassword = false, this.setPassword = false}) : super(key: key);

  @override
  _LockScreenState createState() => new _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final storage = new FlutterSecureStorage();
  String _title;
  int _securityPIN;
  int _passwordLength = 6;
  String _enteredPassword = "";
  String _tmpPassword = "";

  bool _hasError = false;
  String _errorMessage = "";
  Uint8List image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _title = widget.title ?? "Enter your PIN";
    _readSecurityPIN();
  }

  @override
  void didChangeDependencies() {
    _loadBreezLogo();
    super.didChangeDependencies();
  }

  _readSecurityPIN() async {
    // Read value
    _securityPIN = int.parse(await storage.read(key: 'securityPIN'));
  }

  Future _setSecurityPIN(int securityPIN) async {
    // Write value
    await storage.write(key: 'securityPIN', value: securityPIN.toString());
  }

  _loadBreezLogo() async {
    ByteData bytes = await rootBundle.load('src/images/logo-color.png');
    setState(() {
      image = bytes.buffer.asUint8List();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        appBar: widget.dismissible
            ? new AppBar(
                iconTheme: theme.appBarIconTheme,
                textTheme: theme.appBarTextTheme,
                backgroundColor: theme.BreezColors.blue[500],
                leading: backBtn.BackButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                elevation: 0.0,
              )
            : null,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Container(
                child: new Column(children: <Widget>[
                  new Container(
                    child: Image.memory(
                      image,
                      height: 47,
                      width: 125.4,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.only(top: widget.dismissible ? kToolbarHeight : 96.0, bottom: 96.0),
                  ),
                  Text(_title),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 16,
                      left: 64,
                      right: 64,
                    ),
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _buildCircles(),
                    ),
                  ),
                  _hasError
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 64.0),
                          child: Text(
                            _errorMessage,
                            style: theme.errorStyle,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(bottom: 64.0),
                          child: Text(
                            "",
                            style: theme.errorStyle,
                          ),
                        )
                ]),
              ),
              new Expanded(
                child: _numPad(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCircles() {
    var list = <Widget>[];
    for (int i = 0; i < _passwordLength; i++) {
      list.add(AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.only(top: 24.0),
        margin: EdgeInsets.only(bottom: 0),
        width: _enteredPassword.length == _passwordLength ? 28 : 24,
        height: _enteredPassword.length == _passwordLength ? 28 : 24,
        decoration: BoxDecoration(
            color: i < _enteredPassword.length ? Colors.white : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.0)),
      ));
    }
    return list;
  }

  Widget _numPad() {
    return new GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 5 / 3,
        padding: EdgeInsets.zero,
        children: List<int>.generate(9, (i) => i).map((index) => _numberButton((index + 1).toString())).followedBy([
          Container(
            child: new IconButton(
              onPressed: _resetPassword,
              icon: Icon(
                Icons.delete_forever,
                color: Colors.white,
              ),
            ),
          ),
          _numberButton("0"),
          Container(
            child: new IconButton(
              onPressed: _erasePassword,
              icon: Icon(
                Icons.backspace,
                color: Colors.white,
              ),
            ),
          ),
        ]).toList());
  }

  Container _numberButton(String number) {
    return Container(
      child: new FlatButton(
        onPressed: () => _onNumButtonPressed(number),
        child: new Text(number, textAlign: TextAlign.center, style: theme.numPadNumberStyle),
      ),
    );
  }

  _onNumButtonPressed(String numberText) {
    setState(() {
      _errorMessage = "";
      if (_enteredPassword.length < _passwordLength) {
        _enteredPassword = _enteredPassword + numberText;
      }
      if (_enteredPassword.length == _passwordLength) {
        if ((widget.changePassword || widget.setPassword) && _tmpPassword.isEmpty) {
          // Wait for scale animation
          Future.delayed(Duration(milliseconds: 300), () => _setPassword());
        } else {
          Future.delayed(Duration(milliseconds: 300), () => _validatePassword());
        }
      }
    });
  }

  _setPassword() {
    if (_tmpPassword.isEmpty) {
      setState(() {
        _tmpPassword = _enteredPassword;
        _enteredPassword = "";
        _title = "Re-enter your new PIN";
      });
    }
  }

  void _validatePassword() {
    (widget.setPassword || widget.changePassword)
        ? _matchPINs(_enteredPassword == _tmpPassword) // Check if PINs match if a new PIN is being set or current PIN being changed
        : _validatePIN(_enteredPassword == _securityPIN.toString());
  }

  void _validatePIN(bool isValid) {
    if (isValid) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _enteredPassword = "";
        _hasError = true;
        _errorMessage = "Incorrect PIN";
      });
    }
  }

  void _matchPINs(bool isMatched) {
    if (isMatched) {
      _setSecurityPIN(int.parse(_enteredPassword)).then((_) => _readSecurityPIN());
      Navigator.pop(context, true);
    } else {
      setState(() {
        _tmpPassword = "";
        _enteredPassword = "";
        _title = "Enter your new PIN";
        _hasError = true;
        _errorMessage = "PIN does not match";
      });
    }
  }

  _resetPassword() {
    setState(() {
      _enteredPassword = "";
    });
  }

  _erasePassword() {
    setState(() {
      _enteredPassword = _enteredPassword.substring(0, _enteredPassword.length - 1);
    });
  }
}
