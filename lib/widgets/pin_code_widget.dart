import 'dart:math';

import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

const PIN_CODE_LENGTH = 6;

class PinCodeWidget extends StatefulWidget {
  final String label;
  final bool dismissible;
  final Function(String pinEntered) onPinEntered;

  PinCodeWidget(this.label, this.dismissible, this.onPinEntered, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PinCodeWidgetState();
  }
}

class PinCodeWidgetState extends State<PinCodeWidget> {
  String _enteredPinCode;
  String _errorMessage;

  @override
  initState() {
    super.initState();
    _enteredPinCode = "";
    _errorMessage = "";
  }

  Widget build(BuildContext context) {
    double pageHeight =
        widget.dismissible ? (MediaQuery.of(context).size.height - kToolbarHeight - 24) : (MediaQuery.of(context).size.height - 24);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
              child: Center(
                child: _buildBreezLogo(context),
              ),
              height: pageHeight * 0.29),
          new Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Text(widget.label), _buildPinCircles(), _buildErrorMessage()]),
              height: pageHeight * 0.20),
          new Container(child: _numPad(context), height: pageHeight * 0.50)
        ],
      ),
    );
  }

  Image _buildBreezLogo(BuildContext context) {
    return Image.asset(
      "src/images/logo-color.png",
      width: (MediaQuery.of(context).size.width) / 3,
      color: Colors.white,
    );
  }

  Container _buildPinCircles() {
    return Container(
      margin: const EdgeInsets.only(
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

  List<Widget> _buildCircles() {
    var list = <Widget>[];
    for (int i = 0; i < PIN_CODE_LENGTH; i++) {
      list.add(AnimatedContainer(
        duration: Duration(milliseconds: 150),
        padding: EdgeInsets.only(top: 24.0),
        margin: EdgeInsets.only(bottom: 0),
        width: _enteredPinCode.length == PIN_CODE_LENGTH ? 28 : 24,
        height: _enteredPinCode.length == PIN_CODE_LENGTH ? 28 : 24,
        decoration: BoxDecoration(
            color: i < _enteredPinCode.length ? Colors.white : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.0)),
      ));
    }
    return list;
  }

  Text _buildErrorMessage() {
    return _errorMessage.isNotEmpty
        ? Text(
            _errorMessage,
            style: theme.errorStyle,
          )
        : Text(
            "",
            style: theme.errorStyle,
          );
  }

  Widget _numPad(BuildContext context) {
    var _aspectRatio = widget.dismissible
        ? (MediaQuery.of(context).size.width / 3) / ((MediaQuery.of(context).size.height - kToolbarHeight - 24) / 8)
        : (MediaQuery.of(context).size.width / 3) / ((MediaQuery.of(context).size.height - 24) / 8);
    return new GridView.count(
        crossAxisCount: 3,
        childAspectRatio: _aspectRatio,
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
              onPressed: () => _setPinCodeInput(_enteredPinCode.substring(0, max(_enteredPinCode.length, 1) - 1)),
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
    _errorMessage = "";
    if (_enteredPinCode.length < PIN_CODE_LENGTH) {
      _setPinCodeInput(_enteredPinCode + numberText);
    }
    if (_enteredPinCode.length == PIN_CODE_LENGTH) {
      Future.delayed(Duration(milliseconds: 200), () {
        try {
          widget.onPinEntered(_enteredPinCode);
        } catch (error) {
          _errorMessage = error.toString().substring(10);
        }
        _setPinCodeInput("");
      });
    }
  }

  void _setPinCodeInput(String enteredPinCode) {
    setState(() {
      _enteredPinCode = enteredPinCode;
    });
  }
}
