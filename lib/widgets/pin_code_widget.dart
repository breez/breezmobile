import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

const PIN_CODE_LENGTH = 6;

class PinCodeWidget extends StatelessWidget {
  final String label;
  final String enteredPinCode;
  final bool dismissible;
  final String errorMessage;
  final Function(String numberText) onNumButtonPressed;
  final Function(String numberText) setPinCodeInput;

  PinCodeWidget(this.label, this.enteredPinCode, this.dismissible, this.errorMessage, this.onNumButtonPressed, this.setPinCodeInput);

  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Container(
            child: new Column(children: <Widget>[_buildBreezLogo(), Text(label), _buildPinCircles(), _buildErrorMessage()]),
          ),
          new Expanded(
            child: _numPad(),
          )
        ],
      ),
    );
  }

  Padding _buildBreezLogo() {
    return Padding(
      child: new Image.asset(
        "src/images/logo-color.png",
        height: 47,
        width: 125.4,
        color: Colors.white,
      ),
      padding: EdgeInsets.only(top: dismissible ? kToolbarHeight : 96.0, bottom: 96.0),
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

  List<Widget> _buildCircles() {
    var list = <Widget>[];
    for (int i = 0; i < PIN_CODE_LENGTH; i++) {
      list.add(AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.only(top: 24.0),
        margin: EdgeInsets.only(bottom: 0),
        width: enteredPinCode.length == PIN_CODE_LENGTH ? 28 : 24,
        height: enteredPinCode.length == PIN_CODE_LENGTH ? 28 : 24,
        decoration: BoxDecoration(
            color: i < enteredPinCode.length ? Colors.white : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.0)),
      ));
    }
    return list;
  }

  Padding _buildErrorMessage() {
    return errorMessage.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(bottom: 64.0),
            child: Text(
              errorMessage,
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

  Widget _numPad() {
    return new GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 5 / 3,
        padding: EdgeInsets.zero,
        children: List<int>.generate(9, (i) => i).map((index) => _numberButton((index + 1).toString())).followedBy([
          Container(
            child: new IconButton(
              onPressed: () => setPinCodeInput(""),
              icon: Icon(
                Icons.delete_forever,
                color: Colors.white,
              ),
            ),
          ),
          _numberButton("0"),
          Container(
            child: new IconButton(
              onPressed: () => setPinCodeInput(enteredPinCode.substring(0, enteredPinCode.length - 1)),
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
        onPressed: () => onNumButtonPressed(number),
        child: new Text(number, textAlign: TextAlign.center, style: theme.numPadNumberStyle),
      ),
    );
  }
}
