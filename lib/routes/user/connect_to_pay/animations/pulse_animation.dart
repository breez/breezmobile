import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class PulseAnimationDecorator extends StatefulWidget {
  final Widget _child;
  final double _maxRadius;
  final double _minRadius;

  PulseAnimationDecorator(this._child, this._maxRadius, this._minRadius);

  @override
  State<StatefulWidget> createState() {
    return _PulseAnimationDecoratorState();
  }
}

class _PulseAnimationDecoratorState extends State<PulseAnimationDecorator> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _decorationRadius;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _decorationRadius = Tween<double>(
      begin: widget._minRadius,
      end: widget._maxRadius,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeIn,
        ),
      ),
    );
    _startAnimation();
  }

  _startAnimation() {    
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget._child,
      builder: _buildAnimation,
      animation: _animationController,
    );    
  }

  Widget _buildAnimation(BuildContext context, Widget child) {    
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Positioned(child: Container(width: widget._maxRadius * 2, height: widget._maxRadius * 2)),        
        Positioned(        
          top: widget._maxRadius - _decorationRadius.value,
          left: widget._maxRadius - _decorationRadius.value,
            child: Container(
          height: _decorationRadius.value * 2,
          width: _decorationRadius.value * 2,
          decoration: BoxDecoration(shape: BoxShape.circle, color: theme.pulseAnimationColor),
        )),
        Positioned(child: child)
      ],
    );
  }
}
