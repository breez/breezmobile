import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'loading_animated_text.dart';

class CircularProgress extends StatelessWidget {
  final double value;
  final String title;
  final double size;
  final Color color;

  const CircularProgress(
      {Key key, this.value, this.title, this.size, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              height: size,
              width: size,
              child: CircularProgressIndicator(
                value: value,
                semanticsLabel: title,
                backgroundColor: Colors.grey.withOpacity(0.5),
                valueColor: AlwaysStoppedAnimation<Color>(
                  color,
                ),
              ),
            ),
            value == null
                ? const SizedBox()
                : Center(
                    child: SizedBox(
                    width: size * 0.6,
                    child: AutoSizeText("${(value * 100).round().toString()}%",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(fontSize: size / 4, color: color)),
                  )),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: size / 5),
          child: LoadingAnimatedText(
            title,
            textAlign: TextAlign.center,
            textStyle: TextStyle(color: color),
          ),
        )
      ],
    );
  }
}
