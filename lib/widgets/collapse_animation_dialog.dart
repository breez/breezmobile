import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CollapseAnimationDialog extends StatefulWidget {
  final BuildContext context;
  final Animation<double> opacityAnimation;
  final Animation<double> borderAnimation;
  final Animation<RelativeRect> transitionAnimation;
  final Animation<Color> colorAnimation;
  final double _initialDialogSize;
  final Widget _dialogContent;

  CollapseAnimationDialog(this.context, this.transitionAnimation, this.colorAnimation, this.borderAnimation, this.opacityAnimation, this._initialDialogSize, this._dialogContent);

  @override
  CollapseAnimationDialogState createState() {
    return new CollapseAnimationDialogState();
  }
}

class CollapseAnimationDialogState extends State<CollapseAnimationDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(children: <Widget>[
        PositionedTransition(
          rect: widget.transitionAnimation,
          child: Container(
            height: widget._initialDialogSize,
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(minHeight: 220.0, maxHeight: 320.0),
            child: Opacity(
                opacity: widget.opacityAnimation.value,
                child: widget._dialogContent),
            decoration: ShapeDecoration(
              color: widget.colorAnimation.value,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(widget.borderAnimation.value)),
            ),
          ),
        ),
      ]),
    );
  }
}
