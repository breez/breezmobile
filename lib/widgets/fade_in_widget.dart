import 'package:flutter/material.dart';

class FadeInWidget extends StatefulWidget {
  final Widget child;

  const FadeInWidget({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {  
    return FadeInWidgetState();
  }
}

class FadeInWidgetState extends State<FadeInWidget> with SingleTickerProviderStateMixin {
  
  CurvedAnimation _fadeIn;

  @override
  void initState() {    
    super.initState();
    AnimationController controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _fadeIn = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward(); 
  }
  
  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _fadeIn, child: widget.child);
  }
}