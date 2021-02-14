import 'package:anytime/l10n/L.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoostWidget extends StatefulWidget {
  final ValueChanged<double> onBoost;

  BoostWidget({this.onBoost});

  @override
  _BoostWidgetState createState() => _BoostWidgetState();
}

class _BoostWidgetState extends State<BoostWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Slight temporary hack, but ensures the button is still centrally aligned.
        Text(' ',
            style: TextStyle(
              fontSize: 12.0,
              color: Theme.of(context).buttonColor,
            )),
        IconButton(
          constraints: const BoxConstraints(
            maxHeight: 24.0,
            minHeight: 24.0,
            maxWidth: 24.0,
            minWidth: 24.0,
          ),
          tooltip: L.of(context).playback_speed_label,
          padding: const EdgeInsets.all(0.0),
          icon: Icon(
            Icons.speed,
            size: 24.0,
            color: Theme.of(context).buttonColor,
          ),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            'boost',
            style: TextStyle(
              fontSize: 12.0,
              color: Theme.of(context).buttonColor,
            ),
          ),
        ),
      ],
    );
  }
}
