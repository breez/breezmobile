import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoostWidget extends StatefulWidget {
  final BreezUserModel userModel;
  final List boostAmountList;
  final ValueChanged<int> onBoost;

  BoostWidget({this.userModel, this.boostAmountList, this.onBoost});

  @override
  _BoostWidgetState createState() => _BoostWidgetState();
}

class _BoostWidgetState extends State<BoostWidget> {
  int selectedBoostIndex;

  @override
  void initState() {
    super.initState();
    selectedBoostIndex =
        widget.boostAmountList.indexOf(widget.userModel.preferredBoostValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FlatButton.icon(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Color(0xFF0085fb)
                      : Colors.white70,
                  width: 1.6)),
          icon: ImageIcon(
            AssetImage("src/icon/boost.png"),
            size: 18,
            color: Theme.of(context).appBarTheme.actionsIconTheme.color,
          ),
          label: Text(
            "BOOST!",
            style: TextStyle(
              fontSize: 12.0,
              height: 1.2,
              letterSpacing: 1,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).buttonColor,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          onPressed: () {
            widget
                .onBoost(widget.boostAmountList.elementAt(selectedBoostIndex));
          },
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(
            Icons.remove_circle_outline,
            size: 20,
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
          width: 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              children: [
                Text(
                  NumberFormat.compact().format(
                      widget.boostAmountList.elementAt(selectedBoostIndex)),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "sats",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, letterSpacing: 1),
                )
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            size: 20,
            color: Theme.of(context).appBarTheme.actionsIconTheme.color,
          ),
          onPressed: () {
            setState(() {
              (selectedBoostIndex == widget.boostAmountList.length - 1)
                  ? selectedBoostIndex = widget.boostAmountList.length - 1
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
