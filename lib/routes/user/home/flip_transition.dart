import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class FlipTransition extends StatefulWidget {
  Widget firstChild;
  Widget secondChild;
  Widget thirdChild;

  FlipTransition(this.firstChild, this.secondChild, this.thirdChild);

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
        new AnimationController(vsync: this, duration: flipDuration);
    _flipAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _flipAnimationController,
        curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn)));

    _flipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimationController.reverse();
      }
    });
    new Timer(new Duration(milliseconds: 900), () {
      setState(() {
        widget.firstChild = widget.secondChild;
      });
    });
    new Timer(new Duration(milliseconds: 3500), () {
      setState(() {
        widget.firstChild = widget.thirdChild;
      });
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
          return Container(
              width: 40.0,
              height: 40.0,
              child: Transform(
                transform: Matrix4.identity()
                  ..rotateY(pi * _flipAnimation.value),
                alignment: Alignment.center,
                child: widget.firstChild,
              ));
        });
  }
}
