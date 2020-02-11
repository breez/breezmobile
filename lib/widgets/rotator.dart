import 'package:flutter/material.dart';

class Rotator extends StatefulWidget {
  final Widget child;

  const Rotator({Key key, this.child}) : super(key: key);

  @override
  State<StatefulWidget> createState() {    
    return _RotatorState();
  }
}

class _RotatorState extends State<Rotator> with SingleTickerProviderStateMixin {
  
  Animation<double> _animation;
  AnimationController _animationController;

  _RotatorState();

  @override void initState() {    
    super.initState();
    _animationController = new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        _animationController); //use Tween animation here, to animate between the values of 1.0 & 2.5.
    _animation.addListener(() {
      //here, a listener that rebuilds our widget tree when animation.value chnages
      setState(() {});
    });
    _animationController.addStatusListener((status){
      if (status == AnimationStatus.completed) {
        _animationController.reset();
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
    return RotationTransition(
      turns: _animation,
      child: widget.child,
    );
  }
}