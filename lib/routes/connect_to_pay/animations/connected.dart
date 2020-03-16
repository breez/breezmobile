import 'dart:ui';

import 'package:flutter/material.dart';

class ConnectedWidget extends StatefulWidget {
  final Duration _connectionEmulationDuration;
  final bool _waitingAction;

  ConnectedWidget(this._connectionEmulationDuration, this._waitingAction);

  @override
  State<StatefulWidget> createState() {
    return ConnectedWidgetState();
  }
}

class ConnectedWidgetState extends State<ConnectedWidget>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _circleController;
  Animation<double> _lineWidthFactor;
  Animation<double> _circleLoation;
  Animation<double> _circleRadius;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: widget._connectionEmulationDuration);
    _circleController = AnimationController(
        vsync: this, duration: widget._connectionEmulationDuration);
    _lineWidthFactor = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );

    _circleLoation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _circleController,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );

    _circleRadius = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _circleController,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
    );

    _animationController.forward();
    _circleController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: _ConnectedCustomPainter(_lineWidthFactor,
            showCircle: widget._waitingAction,
            circleLoation: this._circleLoation,
            circleRadius: this._circleRadius));
  }
}

class _ConnectedCustomPainter extends CustomPainter {
  static const double lineHeight = 8.0;
  final Animation<double> _lineWidthFactor;
  final Animation<double> circleLoation;
  final Animation<double> circleRadius;
  final bool showCircle;
  final int numberOfCircles = 10;
  final double circleHeight = 7.0;

  _ConnectedCustomPainter(this._lineWidthFactor,
      {this.showCircle, this.circleLoation, this.circleRadius});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = lineHeight
      ..color = Colors.white;
    paintCircles(canvas, size);
    canvas.drawCircle(
        Offset(size.width * _lineWidthFactor.value, size.height / 2),
        lineHeight / 2,
        paint);
    canvas.drawLine(Offset(0.0, size.height / 2),
        Offset(size.width * _lineWidthFactor.value, size.height / 2), paint);

    if (showCircle) {
      canvas.drawCircle(
          Offset(size.width * circleLoation.value, size.height / 2),
          (lineHeight / 2) +
              (lineHeight * 2) * (0.5 - (circleRadius.value - 0.5).abs()),
          paint);
    }
  }

  void paintCircles(Canvas canvas, Size size) {
    var width = size.width,
        marginBetweenCircles =
            (width - (circleHeight * numberOfCircles)) / (numberOfCircles - 1);

    canvas.drawCircle(size.centerLeft(Offset(2.5, 0.0)), circleHeight / 2,
        Paint()..color = Colors.white.withOpacity(0.3));
    for (var i = 1; i < numberOfCircles; ++i) {
      canvas.drawCircle(
          size.centerLeft(Offset(
              i * (circleHeight + marginBetweenCircles) + circleHeight / 2,
              0.0)),
          circleHeight / 2,
          Paint()..color = Colors.white.withOpacity(0.3));
    }
  }

  @override
  bool shouldRepaint(_ConnectedCustomPainter oldDelegate) {
    return true;
  }
}
