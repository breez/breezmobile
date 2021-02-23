import 'package:flutter/material.dart';

class PaymentAdjuster extends StatefulWidget {
  final List satsPerMinuteList;
  final ValueChanged<String> onChanged;

  PaymentAdjuster({this.satsPerMinuteList, this.onChanged});

  @override
  _PaymentAdjusterState createState() => _PaymentAdjusterState();
}

class _PaymentAdjusterState extends State<PaymentAdjuster> {
  int selectedSatsPerMinuteIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.remove,
            size: 16,
            color: Theme.of(context).appBarTheme.actionsIconTheme.color,
          ),
          onPressed: () {
            setState(() {
              (selectedSatsPerMinuteIndex == 0)
                  ? selectedSatsPerMinuteIndex = 0
                  : selectedSatsPerMinuteIndex--;
              widget.onChanged(widget.satsPerMinuteList[selectedSatsPerMinuteIndex]);
            });
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            maxHeight: 24.0,
            minHeight: 24.0,
            maxWidth: 24.0,
            minWidth: 24.0,
          ),
        ),
        SizedBox(
          width: 36,
          child: Padding(
            padding: EdgeInsets.zero,
            child: Text(
              widget.satsPerMinuteList[selectedSatsPerMinuteIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
                color: Theme.of(context).buttonColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Column(
            children: [
              Text(
                "sats",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Theme.of(context).buttonColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: 24,
                  child: Divider(
                    height: 0.0,
                    thickness: 1,
                    color: Theme.of(context).buttonColor,
                  ),
                ),
              ),
              Text(
                "min",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Theme.of(context).buttonColor,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            size: 16,
            color: Theme.of(context).appBarTheme.actionsIconTheme.color,
          ),
          onPressed: () {
            setState(() {
              (selectedSatsPerMinuteIndex == widget.satsPerMinuteList.length - 1)
                  ? selectedSatsPerMinuteIndex = widget.satsPerMinuteList.length - 1
                  : selectedSatsPerMinuteIndex++;
              widget.onChanged(widget.satsPerMinuteList[selectedSatsPerMinuteIndex]);
            });
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            maxHeight: 24.0,
            minHeight: 24.0,
            maxWidth: 24.0,
            minWidth: 24.0,
          ),
        ),
      ],
    );
  }
}
