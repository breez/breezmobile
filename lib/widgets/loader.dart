import 'package:breez/widgets/transparent_page_route.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class Loader extends StatelessWidget {
  final double value;
  final String label;
  final Color color;
  final strokeWidth;

  Loader({this.value, this.label, this.color, this.strokeWidth = 4.0});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: FractionalOffset.center, children: <Widget>[
      CircularProgressIndicator(
        value: this.value,
        semanticsLabel: label,
        strokeWidth: this.strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          this.color ?? theme.circularLoaderColor,
        ),
      ),
    ]);
  }
}

TransparentPageRoute createLoaderRoute(BuildContext context,
    {String message, double opacity = 0.5, Future action}) {
  return TransparentPageRoute((context) {
    return TransparentRouteLoader(
        message: message, opacity: opacity, action: action);
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
                color: bgColor.withOpacity(this.opacity),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Loader(
                        value: this.value,
                        label: this.message,
                        color: this.progressColor),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: message != null
                          ? Text(message, textAlign: TextAlign.center)
                          : SizedBox(),
                    )
                  ],
                )),
          ),
          this.onClose != null
              ? Positioned(
                  top: 25.0,
                  right: 25.0,
                  height: 30.0,
                  width: 30.0,
                  child: IconButton(
                      color: Colors.white,
                      onPressed: () => this.onClose(),
                      icon: Icon(Icons.close,
                          color: Theme.of(context).iconTheme.color)),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class TransparentRouteLoader extends StatefulWidget {
  final String message;
  final double opacity;
  final Future action;

  const TransparentRouteLoader(
      {Key key, this.message, this.opacity = 0.5, this.action})
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
        if (this.mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullScreenLoader(message: widget.message, opacity: widget.opacity);
  }
}
