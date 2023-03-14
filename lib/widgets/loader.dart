import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/transparent_page_route.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double value;
  final String label;
  final Color color;
  final double strokeWidth;

  const Loader({this.value, this.label, this.color, this.strokeWidth = 4.0});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: FractionalOffset.center, children: <Widget>[
      CircularProgressIndicator(
        value: value,
        semanticsLabel: label,
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? theme.circularLoaderColor,
        ),
      ),
    ]);
  }
}

TransparentPageRoute createLoaderRoute(BuildContext context,
    {String message, double opacity = 0.5, Future action, Function onClose}) {
  return TransparentPageRoute((context) {
    return TransparentRouteLoader(
        message: message, opacity: opacity, action: action, onClose: onClose);
  });
}

class FullScreenLoader extends StatelessWidget {
  final String message;
  final double opacity;
  final double value;
  final Color progressColor;
  final Color bgColor;
  final Function onClose;

  const FullScreenLoader(
      {Key key,
      this.message,
      this.opacity = 0.5,
      this.value,
      this.progressColor,
      this.bgColor = Colors.black,
      this.onClose})
      : super(key: key);

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
                color: bgColor.withOpacity(opacity),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Loader(
                        value: value,
                        label: message,
                        color: progressColor),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: message != null
                          ? Text(message, textAlign: TextAlign.center)
                          : const SizedBox(),
                    )
                  ],
                )),
          ),
          onClose != null
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        color: Colors.white,
                        onPressed: () => onClose(),
                        icon: Icon(Icons.close,
                            color: Theme.of(context).iconTheme.color)),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class TransparentRouteLoader extends StatefulWidget {
  final String message;
  final double opacity;
  final Future action;
  final Function onClose;

  const TransparentRouteLoader(
      {Key key, this.message, this.opacity = 0.5, this.action, this.onClose})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TransparentRouteLoaderState();
  }
}

class TransparentRouteLoaderState extends State<TransparentRouteLoader> {
  @override
  void initState() {
    super.initState();
    if (widget.action != null) {
      widget.action.whenComplete(() {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullScreenLoader(
        message: widget.message,
        opacity: widget.opacity,
        onClose: widget.onClose);
  }
}
