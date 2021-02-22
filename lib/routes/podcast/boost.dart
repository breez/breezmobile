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
  int selectedBoostIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: FlatButton(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.zero,
                  child: ImageIcon(
                    AssetImage("src/icon/boost.png"),
                    size: 24,
                    color: Theme.of(context).appBarTheme.actionsIconTheme.color,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.zero,
                  child: Text(
                    "Boost!",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).buttonColor,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () =>
                widget.onBoost(widget.amountList[selectedBoostIndex]),
          ),
        ),
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
        Column(
          children: [
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
            Text(
              "sats",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
                color: Theme.of(context).buttonColor,
              ),
            )
          ],
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
