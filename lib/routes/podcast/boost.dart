import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoostWidget extends StatefulWidget {
  final List amountList;
  final ValueChanged<String> onBoost;

  BoostWidget({this.amountList, this.onBoost});

  @override
  _BoostWidgetState createState() => _BoostWidgetState();
}

class _BoostWidgetState extends State<BoostWidget> {
  int selectedBoostIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: ImageIcon(
              AssetImage("src/icon/boost.png"),
              color: Theme.of(context).appBarTheme.actionsIconTheme.color,
            ),
            onPressed: () {
              widget.onBoost(widget.amountList[selectedBoostIndex]);
            }),
        IconButton(
          icon: Icon(
            Icons.remove,
            size: 16,
            color: Theme.of(context).appBarTheme.actionsIconTheme.color,
          ),
          onPressed: () {
            setState(() {
              (selectedBoostIndex == 0)
                  ? selectedBoostIndex = 0
                  : selectedBoostIndex--;
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
              widget.amountList[selectedBoostIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
                color: Theme.of(context).buttonColor,
              ),
            ),
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
              (selectedBoostIndex == widget.amountList.length - 1)
                  ? selectedBoostIndex = widget.amountList.length - 1
                  : selectedBoostIndex++;
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
