import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:flutter/material.dart';

class PassCodeScreen extends StatefulWidget {
  final Function(bool success) onSuccess;
  final Function(int password) setSecurityPIN;
  final String title;
  final int password;
  final bool dismissible;

  PassCodeScreen(this.password, {Key key, this.dismissible = false, this.onSuccess, this.setSecurityPIN, this.title}) : super(key: key);

  @override
  _PassCodeScreenState createState() => new _PassCodeScreenState();
}

class _PassCodeScreenState extends State<PassCodeScreen> {
  String _title;

  int _passwordLength = 6;
  String _enteredPassword = "";
  String _tmpPassword = "";

  bool _hasError = false;
  String _errorMessage = "";

  double itemHeight;
  double itemWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _title = widget.title ?? "Enter your PIN";
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    itemHeight = (MediaQuery.of(context).size.height - kToolbarHeight - 16) / 4;
    itemWidth = (MediaQuery.of(context).size.width) / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.dismissible
          ? new AppBar(
              iconTheme: theme.appBarIconTheme,
              textTheme: theme.appBarTextTheme,
              backgroundColor: theme.BreezColors.blue[500],
              leading: backBtn.BackButton(),
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
                  child: Image.asset(
                    "src/images/logo-color.png",
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

  onNumButtonPressed(String numberText) {
    setState(() {
      _errorMessage = "";
      if (_enteredPassword.length < _passwordLength) {
        _enteredPassword = _enteredPassword + numberText;
      }
      if (_enteredPassword.length == _passwordLength) {
        if (widget.password == null && _tmpPassword.isEmpty) {
          Future.delayed(Duration(milliseconds: 300), () => _setPassword());
        } else {
          Future.delayed(Duration(milliseconds: 300), () => _validatePassword());
        }
      }
    });
  }

  Container _numberButton(String number) {
    return Container(
      child: new FlatButton(
        onPressed: () => onNumButtonPressed(number),
        child: new Text(number, textAlign: TextAlign.center, style: theme.numPadNumberStyle),
      ),
    );
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
    if (widget.password == null) {
      if (_enteredPassword == _tmpPassword) {
        widget.onSuccess(true);
        widget.setSecurityPIN(int.parse(_enteredPassword));
        Navigator.pop(context);
      } else {
        setState(() {
          _tmpPassword = "";
          _enteredPassword = "";
          _title = "Enter your new PIN";
          _hasError = true;
          _errorMessage = "PIN does not match";
        });
      }
    } else {
      if (_enteredPassword == widget.password.toString()) {
        widget.onSuccess(true);
      } else {
        setState(() {
          _enteredPassword = "";
          _hasError = true;
          _errorMessage = "Incorrect PIN";
        });
      }
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
}
