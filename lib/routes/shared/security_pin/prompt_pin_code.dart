import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

class LockScreen extends StatefulWidget {
  final String title;
  final bool dismissible;
  final bool changePassword;
  final bool setPassword;
  final Widget route;

  LockScreen({Key key, this.title, this.dismissible = false, this.changePassword = false, this.setPassword = false, this.route}) : super(key: key);

  @override
  _LockScreenState createState() => new _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  AccountBloc _accountBloc;
  String _title;
  Image _breezLogo;

  int _securityPIN;
  int _passwordLength = 6;
  String _enteredPassword = "";
  String _tmpPassword = "";

  bool _hasError = false;
  String _errorMessage = "";

  bool _validated = false;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _title = widget.title ?? "Enter your PIN";
    _breezLogo = new Image.asset(
      "src/images/logo-color.png",
      height: 47,
      width: 125.4,
      color: Colors.white,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      _lockAccount(true);
      _accountBloc.accountStream.listen((account) {
        setState(() {
          _securityPIN = account.pinCode;
        });
      });
      precacheImage(_breezLogo.image, context);
      _isInit = true;
    }
  }

  Future _lockAccount(bool isLocked) async {
    LockAccount lockAccountAction = LockAccount(isLocked);
    _accountBloc.userActionsSink.add(lockAccountAction);
  }

  Future _setSecurityPIN(int securityPIN) async {
    SetPinCode setPinCodeAction = SetPinCode(securityPIN);
    _accountBloc.userActionsSink.add(setPinCodeAction);

    setPinCodeAction.future.then((_) => Navigator.pop(context, true))
      ..catchError((err) {
        if (this.mounted) {
          setState(() {
            showFlushbar(context, message: "Failed to set PIN");
          });
        }
      });
  }

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
                    child: _breezLogo,
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
        // Validate current PIN before changing PIN
        if (((widget.changePassword && _validated) || widget.setPassword) && _tmpPassword.isEmpty) {
          // If a new PIN is being set prompt user to enter the PIN again
          Future.delayed(Duration(milliseconds: 300), () => _setPINForValidation()); // Wait 300ms for scale animation to end
        } else {
          // Check if PINs match if a new PIN is being set or current PIN is being changed
          Future.delayed(
              Duration(milliseconds: 300),
              () => (widget.setPassword || (widget.changePassword && _validated))
                  ? _matchPINs(_enteredPassword == _tmpPassword)
                  : _validatePIN(_enteredPassword == _securityPIN.toString()));
        }
      }
    });
  }

  _setPINForValidation() {
    setState(() {
      _tmpPassword = _enteredPassword;
      _enteredPassword = "";
      _title = "Re-enter your new PIN";
    });
  }

  void _validatePIN(bool isValid) {
    if (isValid) {
      if (widget.changePassword && !_validated) {
        _promptUserToEnterNewPIN(isValid);
      } else {
        _lockAccount(false);
        if (widget.route != null) {
          Navigator.of(context).pushReplacement(
            new FadeInRoute(
              builder: (BuildContext context) {
                return widget.route;
              },
            ),
          );
        } else {
          Navigator.pop(context, true);
        }
      }
    } else {
      _incorrectPIN();
    }
  }

  void _incorrectPIN() {
    setState(() {
      _enteredPassword = "";
      _hasError = true;
      _errorMessage = "Incorrect PIN";
    });
  }

  void _promptUserToEnterNewPIN(bool isValid) {
    setState(() {
      _validated = isValid;
      _enteredPassword = "";
      _title = "Enter your new PIN";
    });
  }

  void _matchPINs(bool isMatched) {
    if (isMatched) {
      _setSecurityPIN(int.parse(_enteredPassword));
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
