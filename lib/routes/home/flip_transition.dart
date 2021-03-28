import 'dart:math';

import 'package:flutter/material.dart';

class FlipTransition extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;
  final double radius;

  FlipTransition(this.firstChild, this.secondChild, {this.radius});

  @override
  State<StatefulWidget> createState() {
    return FlipTransitionState();
  }
}

class FlipTransitionState extends State<FlipTransition>
    with TickerProviderStateMixin {
  AnimationController _flipAnimationController;
  Animation _flipAnimation;
  static const flipDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _flipAnimationController =
        AnimationController(vsync: this, duration: flipDuration);
    _flipAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _flipAnimationController,
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));

    _flipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimationController.reverse();
      }
    });
    _flipAnimationController.forward();
  }

  @override
  void dispose() {
    _flipAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimationController,
      builder: (BuildContext context, Widget child) {
        return CircleAvatar(
          radius: widget.radius,
          backgroundColor: Colors.white,
          child: Transform(
            transform: Matrix4.identity()..rotateY(pi * _flipAnimation.value),
            alignment: Alignment.center,
            child: _flipAnimationController.value >= 0.4
                ? widget.secondChild
                : widget.firstChild,
          ),
        );
      },
    );
  }
}
