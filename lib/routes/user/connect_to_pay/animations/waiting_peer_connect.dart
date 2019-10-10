import 'dart:ui';

import 'package:flutter/material.dart';

class WaitingPeerConnectWidget extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _WaitingPeerConnecWidgettState();
  }
}

class _WaitingPeerConnecWidgettState extends State<WaitingPeerConnectWidget> with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(vsync: this);
    _animationController.repeat(period: Duration(seconds: 3));
    _animationController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ConnectingCustomPainter(_animationController));
  }
}

class _ConnectingCustomPainter extends CustomPainter {
  final AnimationController _animationController;
  final int numberOfCircles = 10;
  final double circleHeight = 7.0;
  final int ticksPerCircle = 10;

  _ConnectingCustomPainter(this._animationController);

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width, marginBetweenCircles = (width - (circleHeight * numberOfCircles)) / (numberOfCircles - 1);

    drawCircle(canvas, 0, size.centerLeft(Offset(2.5, 0.0)));
    for (var i = 1; i < numberOfCircles; ++i) {
      drawCircle(canvas, i, size.centerLeft(Offset(i * (circleHeight + marginBetweenCircles) + circleHeight / 2, 0.0)));
    }
  }

  void drawCircle(Canvas canvas, int circleIndex, Offset start) {
    int maxCircleIndex = numberOfCircles - 1;
    double rangeIndex = _animationController.value * (maxCircleIndex * 2);
    if (rangeIndex > maxCircleIndex) {
      rangeIndex = maxCircleIndex * 2 - rangeIndex;
    }
    double distance = (circleIndex - rangeIndex).abs();
    double sizeFactor = (((1.8 - distance) / 4) + 1.0).clamp(1.0, 1.45);
    canvas.drawCircle(start, circleHeight / 2 * sizeFactor, Paint()..color = Colors.white.withOpacity(((sizeFactor * 2) - 1.7).clamp(0.0, 1.0)));
  }

  @override
  bool shouldRepaint(_ConnectingCustomPainter oldDelegate) {
    return true;
  }
}
