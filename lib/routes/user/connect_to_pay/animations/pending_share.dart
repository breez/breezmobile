import 'dart:math' as math;
import 'dart:ui';

import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class PendingShareIndicator extends StatefulWidget {  
  
  PendingShareIndicator();

  @override
  State<StatefulWidget> createState() {
    return PendingShareIndicatorState();
  }
}

class PendingShareIndicatorState extends State<PendingShareIndicator> with TickerProviderStateMixin {
  static const animationDuration = Duration(milliseconds: 500);
  static const rotatingDuration = Duration(milliseconds: 1000);
  AnimationController _scaleAnimationController;  
  AnimationController _rotateAnimationController;   
  Animation<double> _scale1;
  Animation<double> _scale2;  
  Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _scaleAnimationController = new AnimationController(vsync: this, duration: animationDuration);    
    _rotateAnimationController = new AnimationController(vsync: this, duration: rotatingDuration);
    
    _scale1 = _linearTween(_scaleAnimationController, 0.3, 1.0);      
    _scale2 = _linearTween(_scaleAnimationController, 0.6, 1.0);
    _rotate = _linearTween(_rotateAnimationController, 0.0, 2 * math.pi);

    _scaleAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scaleAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _scaleAnimationController.forward();
      }
    });
    _scaleAnimationController.forward();
    _rotateAnimationController.repeat();
  }

  Animation<double> _linearTween(AnimationController controller, double begin, double end){
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.linear,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    _rotateAnimationController.dispose();
    super.dispose();    
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ConnectedCustomPainter(_scale1, _scale2, _rotate));
  }
}

class _ConnectedCustomPainter extends CustomPainter {  
  final Color color = theme.BreezColors.blue[500];
  final Animation<double> _scale1;
  final Animation<double> _scale2;
  final Animation<double> _rotate;  

  _ConnectedCustomPainter(this._scale1, this._scale2, this._rotate);

  @override
  void paint(Canvas canvas, Size size) {
    var circle1Paint = Paint()
        ..style = PaintingStyle.fill      
        ..color = color,
      arcPaint = Paint()        
        ..style = PaintingStyle.stroke   
        ..strokeWidth = 3.0
        ..color = color,
      circleSpacing = 0.0,
      x = size.width / 2,
      y = size.height /2;
    
    canvas.drawCircle(Offset(x, y), x / 2 * _scale1.value, circle1Paint);        
    
    canvas.translate(x, y);
    canvas.scale(_scale2.value, _scale2.value);
    canvas.rotate(_rotate.value);           
    List<double> startAngles= [-3 * math.pi / 4,  math.pi / 4];
    for (int i = 0; i < 2; i++) {
      Rect rect = Rect.fromLTRB(-x+circleSpacing,-y+circleSpacing,x-circleSpacing,y-circleSpacing);                
      canvas.drawArc(rect, startAngles[i], math.pi / 2, false, arcPaint);
    }        
  }

  @override
  bool shouldRepaint(_ConnectedCustomPainter oldDelegate) {
    return true;
  }
}
