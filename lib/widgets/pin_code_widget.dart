import 'dart:math';

import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/services/local_auth_service.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/circular_button.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const PIN_CODE_LENGTH = 6;

class PinCodeWidget extends StatefulWidget {
  final String label;
  final Future Function(String pinEntered) onPinEntered;
  final Function(bool isValid) onFingerprintEntered;
  final UserProfileBloc userProfileBloc;
  final String localizedReason;

  const PinCodeWidget(this.label, this.onPinEntered,
      {this.onFingerprintEntered, this.userProfileBloc, this.localizedReason});

  @override
  State<StatefulWidget> createState() {
    return PinCodeWidgetState();
  }
}

class PinCodeWidgetState extends State<PinCodeWidget>
    with WidgetsBindingObserver {
  String _enteredPinCode;
  String _errorMessage;
  LocalAuthenticationOption _enrolledBiometrics;
  bool biometricsValidated = false;

  bool _inputEnabled = true;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enteredPinCode = "";
    _errorMessage = "";
    _enrolledBiometrics = LocalAuthenticationOption.NONE;
    if (widget.onFingerprintEntered != null) {
      _promptBiometrics();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.onFingerprintEntered != null) {
      if (state == AppLifecycleState.resumed) {
        _promptBiometrics();
      }
      if (state == AppLifecycleState.paused) {
        var stopAction = StopBiometrics();
        widget.userProfileBloc.userActionsSink.add(stopAction);
        stopAction.future.then((_) => biometricsValidated = false);
      }
    }
  }

  @override
  void dispose() {
    if (widget.userProfileBloc != null) {
      widget.userProfileBloc.userActionsSink.add(StopBiometrics());
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future _promptBiometrics() async {
    _enrolledBiometrics = await _getEnrolledBiometrics();
    if (_enrolledBiometrics != LocalAuthenticationOption.NONE) {
      await Future.delayed(const Duration(milliseconds: 240));
      _validateBiometrics();
    }
  }

  Future _getEnrolledBiometrics() async {
    var getEnrolledBiometricsAction = GetEnrolledBiometrics();
    widget.userProfileBloc.userActionsSink.add(getEnrolledBiometricsAction);
    return getEnrolledBiometricsAction.future;
  }

  void _validateBiometrics({bool force = false}) async {
    if (mounted && (!biometricsValidated || force)) {
      biometricsValidated = true;
      var validateBiometricsAction =
          ValidateBiometrics(localizedReason: widget.localizedReason);
      widget.userProfileBloc.userActionsSink.add(validateBiometricsAction);
      validateBiometricsAction.future.then((isValid) async {
        setState(() => _enteredPinCode = (isValid) ? "123456" : "");
        Future.delayed(const Duration(milliseconds: 160), () {
          return widget.onFingerprintEntered(isValid);
        });
      }, onError: (error) {
        setState(() => _enteredPinCode = "");
        showFlushbar(context, message: error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            flex: 20,
            child: Center(
              child: _buildBreezLogo(context),
            ),
          ),
          Flexible(
            flex: 30,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(widget.label),
                  _buildPinCircles(),
                  _buildErrorMessage()
                ]),
          ),
          Flexible(flex: 50, child: Container(child: _numPad(context)))
        ],
      ),
    );
  }

  Widget _buildBreezLogo(BuildContext context) {
    return SvgPicture.asset(
      "src/images/logo-color.svg",
      width: (MediaQuery.of(context).size.width) / 3,
      colorFilter: const ColorFilter.mode(
        Colors.white,
        BlendMode.srcATop,
      ),
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
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.only(top: 24.0),
        margin: const EdgeInsets.only(bottom: 0),
        width: _enteredPinCode.length == PIN_CODE_LENGTH ? 28 : 24,
        height: _enteredPinCode.length == PIN_CODE_LENGTH ? 28 : 24,
        decoration: BoxDecoration(
            color:
                i < _enteredPinCode.length ? Colors.white : Colors.transparent,
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
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                .copyWith(fontSize: 12),
          )
        : Text(
            "",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                .copyWith(fontSize: 12),
          );
  }

  Widget _numPad(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: List<Widget>.generate(
                3, (i) => _numberButton((i + 1).toString())),
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: List<Widget>.generate(
                3, (i) => _numberButton((i + 4).toString())),
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: List<Widget>.generate(
                3, (i) => _numberButton((i + 7).toString())),
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildClearButton(),
              _numberButton("0"),
              widget.onFingerprintEntered == null ||
                      ((widget.onFingerprintEntered != null) &&
                          _enteredPinCode.isNotEmpty)
                  ? _buildEraseButton()
                  : StreamBuilder<BreezUserModel>(
                      stream: widget.userProfileBloc.userStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            _enrolledBiometrics ==
                                LocalAuthenticationOption.NONE) {
                          return _buildEraseButton();
                        } else {
                          return _buildBiometricsButton(snapshot, context);
                        }
                      },
                    ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBiometricsButton(
      AsyncSnapshot<BreezUserModel> snapshot, BuildContext context) {
    return CircularButton(
      onTap: _inputEnabled ? () => _validateBiometrics(force: true) : null,
      child: Icon(
        _enrolledBiometrics == LocalAuthenticationOption.FACE ||
                _enrolledBiometrics == LocalAuthenticationOption.FACE_ID
            ? Icons.face
            : Icons.fingerprint,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Widget _buildClearButton() {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: _inputEnabled ? () => _setPinCodeInput("") : null,
      child: TextButton(
        style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
        child: const Icon(
          Icons.delete_forever,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEraseButton() {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: _inputEnabled
          ? () => _setPinCodeInput(
              _enteredPinCode.substring(0, max(_enteredPinCode.length, 1) - 1))
          : null,
      child: TextButton(
        style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
        child: const Icon(
          Icons.backspace,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _numberButton(String number) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: _inputEnabled ? () => _onNumButtonPressed(number) : null,
      child: TextButton(
        style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
        child: Text(
          number,
          textAlign: TextAlign.center,
          style: theme.numPadNumberStyle,
        ),
      ),
    );
  }

  _onNumButtonPressed(String numberText) {
    _errorMessage = "";
    if (_enteredPinCode.length < PIN_CODE_LENGTH) {
      _setPinCodeInput(_enteredPinCode + numberText);
    }
    if (_enteredPinCode.length == PIN_CODE_LENGTH) {
      _inputEnabled = false;
      String pinCodeToValidate = _enteredPinCode;
      Future.delayed(const Duration(milliseconds: 200), () {
        widget
            .onPinEntered(pinCodeToValidate)
            .catchError((err) => _errorMessage = err.toString().substring(10))
            .whenComplete(() {
          if (!mounted) {
            return;
          }
          _setPinCodeInput("");
          _inputEnabled = true;
        });
      });
    }
  }

  void _setPinCodeInput(String enteredPinCode) {
    setState(() {
      _enteredPinCode = enteredPinCode;
    });
  }
}
