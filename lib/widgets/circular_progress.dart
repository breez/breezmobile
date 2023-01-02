import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'loading_animated_text.dart';

class CircularProgress  extends StatefulWidget {

  final double value;
  final String title;
  final double size;
  final Color color;

  const CircularProgress(
      {Key key, this.value, this.title, this.size, this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CircularProgressState();
  }
}

class CircularProgressState
    extends State<CircularProgress> with TickerProviderStateMixin {
    AnimationController _animationController;

    @override
    void initState() {
      super.initState();
      _animationController = new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 2000),
      );
      _animationController.repeat();

    }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: widget.size,
              width: widget.size,
              child: RotationTransition(
                child: Image(
                  image:AssetImage("src/images/logo.png"),),
                turns: _animationController,
              )
    ),
            widget.value == null
                ? SizedBox()
                : Center(
                    child: Container(
                    width: widget.size * 0.6,
                    child: AutoSizeText("${(widget.value * 100).round().toString()}%",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(fontSize: widget.size / 4, color: widget.color)),
                  )),
          ],
        ),
        widget.value == null
            ? SizedBox()
            :Padding(
          padding: EdgeInsets.only(top: widget.size / 5),
          child: LoadingAnimatedText(
            widget.title,
            textAlign: TextAlign.center,
            textStyle: TextStyle(color: widget.color),
          ),
        )
      ],
    );
  }
    @override
    void dispose() {
      _animationController.stop();//do i need to call it as well?
      _animationController.dispose();
      super.dispose();// and does it matter if i dispose the controller before this line or after this line.
    }

}
