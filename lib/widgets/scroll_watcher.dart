import 'package:flutter/material.dart';

class ScrollWatcher extends StatefulWidget {
  final ScrollController controller;
  final Function(BuildContext context, double offset) builder;

  ScrollWatcher({this.controller, this.builder});

  @override
  State<StatefulWidget> createState() {
    return _ScrollWatcherState();
  }
}

class _ScrollWatcherState extends State<ScrollWatcher> {
  
  @override
    void initState() {      
      super.initState();
      widget.controller.addListener(() => setState((){}));
    }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.controller.offset);
  }
}
