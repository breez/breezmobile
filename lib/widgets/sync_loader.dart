import 'package:breez/widgets/circular_progress.dart';
import 'package:breez/widgets/transparent_page_route.dart';
import 'package:flutter/material.dart';

class SyncUIRoute<T> extends TransparentPageRoute<T> {
  SyncUIRoute(Widget Function(BuildContext context) builder) : super(builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    var curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    return ScaleTransition(
        scale: curve, child: child, alignment: Alignment.topRight);
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}

class TransparentRouteLoader extends StatefulWidget {
  final String message;
  final double opacity;
  final double value;
  final Function onClose;

  const TransparentRouteLoader(
      {Key key, this.message, this.opacity = 0.5, this.value, this.onClose})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TransparentRouteLoaderState();
  }
}

class TransparentRouteLoaderState extends State<TransparentRouteLoader> {
  @override
  void didUpdateWidget(TransparentRouteLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != this.widget.message ||
        oldWidget.opacity != this.widget.opacity ||
        oldWidget.value != this.widget.value) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
                color:
                    Theme.of(context).canvasColor.withOpacity(widget.opacity),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CircularProgress(
                    size: 160.0,
                    color: Theme.of(context).accentColor,
                    value: widget.value,
                    title: widget.message)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  color: Colors.white,
                  onPressed: this.widget.onClose,
                  icon: Icon(Icons.unfold_less)),
            ),
          ),
        ],
      ),
    );
  }
}

class SyncProgressLoader extends StatelessWidget {
  final double value;
  final String title;
  final Color progressColor;

  const SyncProgressLoader(
      {Key key, this.value, this.title, this.progressColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150.0,
      child: CircularProgress(
          color: progressColor ?? Theme.of(context).textTheme.button.color,
          size: 100.0,
          value: value,
          title: title),
    );
  }
}
