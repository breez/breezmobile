import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

class LockScreen extends StatefulWidget {
  final String label;
  final bool dismissible;
  final bool changePassword;
  final bool setPassword;
  final Widget route;

  LockScreen({Key key, this.label, this.dismissible = false, this.changePassword = false, this.setPassword = false, this.route})
      : super(key: key);

  @override
  _LockScreenState createState() => new _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  UserProfileBloc _userProfileBloc;
  BreezUserModel _user;
  String _label;
  Image _breezLogo;

  int _passwordLength = 6;
  String _enteredPinCode = "";
  String _errorMessage = "";
  String _tmpPassword = "";

  bool _validated = false;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _setLabel(widget.label ?? "Enter your PIN");
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
      _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      _userProfileBloc.userStream.listen((user) {
        _user = user;
      });
      precacheImage(_breezLogo.image, context);
      _isInit = true;
    }
  }

  _setPinCode(String securityPIN) {
    SetPinCode setPinCodeAction = SetPinCode(securityPIN);
    _userProfileBloc.userActionsSink.add(setPinCodeAction);
    setPinCodeAction.future.then((_) {
      if (this.mounted) {
        Navigator.pop(context);
      }
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
                child: new Column(children: <Widget>[_buildBreezLogo(), Text(_label), _buildPinCircles(), _buildErrorMessage()]),
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

  Padding _buildBreezLogo() {
    return Padding(
      child: _breezLogo,
      padding: EdgeInsets.only(top: widget.dismissible ? kToolbarHeight : 96.0, bottom: 96.0),
    );
  }

  Container _buildPinCircles() {
    return Container(
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
    );
  }

  Padding _buildErrorMessage() {
    return _errorMessage.isNotEmpty
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
          );
  }

  List<Widget> _buildCircles() {
    var list = <Widget>[];
    for (int i = 0; i < _passwordLength; i++) {
      list.add(AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.only(top: 24.0),
        margin: EdgeInsets.only(bottom: 0),
        width: _enteredPinCode.length == _passwordLength ? 28 : 24,
        height: _enteredPinCode.length == _passwordLength ? 28 : 24,
        decoration: BoxDecoration(
            color: i < _enteredPinCode.length ? Colors.white : Colors.transparent,
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
              onPressed: () => _setPinCodeInput(""),
              icon: Icon(
                Icons.delete_forever,
                color: Colors.white,
              ),
            ),
          ),
          _numberButton("0"),
          Container(
            child: new IconButton(
              onPressed: () => _setPinCodeInput(_enteredPinCode.substring(0, _enteredPinCode.length - 1)),
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
      _setErrorMessage("");
      if (_enteredPinCode.length < _passwordLength) {
        _setPinCodeInput(_enteredPinCode + numberText);
      }
      if (_enteredPinCode.length == _passwordLength) {
        // Validate current PIN before changing PIN
        if (((widget.changePassword && _validated) || widget.setPassword) &&  _tmpPassword.isEmpty) {
          // If a new PIN is being set prompt user to enter the PIN again
          Future.delayed(Duration(milliseconds: 300), () => _setPinCodeForValidation()); // Wait 300ms for scale animation to end
        } else {
          // Check if PINs match if a new PIN is being set or current PIN is being changed
          Future.delayed(
              Duration(milliseconds: 300),
              () => (widget.setPassword || (widget.changePassword && _validated))
                  ? _matchPinCodes(_enteredPinCode == _tmpPassword)
                  : _validatePinCode(_enteredPinCode == _user.securityModel.pinCode));
        }
      }
    });
  }

  _setPinCodeForValidation() {
    setState(() {
      _tmpPassword = _enteredPinCode;
    });
    _setPinCodeInput("");
    _setLabel("Re-enter your new PIN");
  }

  void _validatePinCode(bool isValid) {
    if (isValid) {
      if (widget.changePassword && !_validated) {
        _promptUserToEnterNewPinCode(isValid);
      } else {
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
      _incorrectPinCode();
    }
  }

  void _incorrectPinCode() {
    _setPinCodeInput("");
    _setErrorMessage("Incorrect PIN");
  }

  void _promptUserToEnterNewPinCode(bool isValid) {
    _setPinCodeInput("");
    _setLabel("Enter your new PIN");
    setState(() {
      _validated = isValid;
    });
  }

  void _matchPinCodes(bool isMatched) {
    if (isMatched) {
      _setPinCode(_enteredPinCode);
    } else {
      _setPinCodeInput("");
      _setLabel("Enter your new PIN");
      _setErrorMessage("PIN does not match");
    }
  }

  void _setLabel(String label) {
    setState(() {
      _label = label;
    });
  }

  void _setPinCodeInput(String enteredPinCode) {
    setState(() {
      _enteredPinCode = enteredPinCode;
    });
  }

  void _setErrorMessage(String errorMessage) {
    setState(() {
      _errorMessage = errorMessage;
    });
  }
}
