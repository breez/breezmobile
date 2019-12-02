import 'dart:async';

import 'package:flutter/material.dart';

class DelayRender extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final Widget initialChild;

  DelayRender(
      {this.duration, this.child, this.initialChild = const SizedBox()});

  @override
  State<StatefulWidget> createState() {
    return DelatedRenderState();
  }
}

class DelatedRenderState extends State<DelayRender> {
  bool _childVisible = false;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(
        widget.duration,
        () => setState(() {
              _childVisible = true;
            }));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _childVisible ? widget.child : widget.initialChild;
  }
}
