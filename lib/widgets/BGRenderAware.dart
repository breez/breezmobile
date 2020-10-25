import 'dart:async';

import 'package:breez/services/device.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter/material.dart';

// This is a generic widget wrapper that renders empty widget when app is in
// the background and the widget tree is built.
// In addtion it triggers a re-build tree when app is entering foreground.
// Work arround for this issue: https://github.com/flutter/flutter/issues/64558
class BGRenderAware extends StatefulWidget {
  final Widget child;
  final ServiceInjector injector = ServiceInjector();

  BGRenderAware(this.child);

  @override
  State<StatefulWidget> createState() {
    return BGRenderAwareState();
  }
}

class BGRenderAwareState extends State<BGRenderAware> {
  bool _inBackground = false;
  StreamSubscription<NotificationType> _deviceSubscription;

  @override
  void initState() {
    super.initState();
    ServiceInjector injector = ServiceInjector();
    _deviceSubscription = injector.device.eventStream.listen((event) {
      _inBackground = event == NotificationType.PAUSE;
      if (!_inBackground) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _deviceSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_inBackground) {
      return SizedBox();
    }
    return this.widget.child;
  }
}
