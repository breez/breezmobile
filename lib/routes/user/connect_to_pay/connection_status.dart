import 'dart:core';
import 'package:breez/routes/user/connect_to_pay/animations/connected.dart';
import 'package:breez/routes/user/connect_to_pay/animations/waiting_peer_connect.dart';
import 'package:flutter/material.dart';

enum ConnectionState { IDLE, WAITING_PEER_CONNECT, CONNECTED, WAITING_ACTION }

class ConnectionStatus extends StatefulWidget {
  final ConnectionState _status;
  final Duration _connectionEmulationDuration;

  ConnectionStatus(this._status, this._connectionEmulationDuration);

  @override
  State<StatefulWidget> createState() {
    return new _ConnectionStatusState();
  }
}

class _ConnectionStatusState extends State<ConnectionStatus> {
  @override
  Widget build(BuildContext context) {
    switch (widget._status) {
      case ConnectionState.IDLE:
        return CustomPaint(painter: _IdleCustomPainter());
      case ConnectionState.WAITING_PEER_CONNECT:
        return WaitingPeerConnectWidget();
      case ConnectionState.WAITING_ACTION:
        return ConnectedWidget(widget._connectionEmulationDuration, true);
      default:
        return ConnectedWidget(widget._connectionEmulationDuration, false);
    }
  }
}

class _IdleCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width, numberOfCircles = 10, circleHeight = 7.0, marginBetweenCircles = (width - (circleHeight * numberOfCircles)) / (numberOfCircles - 1);

    canvas.drawCircle(size.centerLeft(Offset(2.5, 0.0)), circleHeight / 2, Paint()..color = Colors.white.withOpacity(0.3));
    for (var i = 1; i < numberOfCircles; ++i) {
      canvas.drawCircle(size.centerLeft(Offset(i * (circleHeight + marginBetweenCircles) + circleHeight / 2, 0.0)), circleHeight / 2,
          Paint()..color = Colors.white.withOpacity(0.3));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
