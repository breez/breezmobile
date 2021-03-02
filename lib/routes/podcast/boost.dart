import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/utils/min_font_size.dart';
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            size: 20,
            color: Theme.of(context).appBarTheme.actionsIconTheme.color,
          ),
          label: AutoSizeText(
            "BOOST!",
            style: TextStyle(
              fontSize: 14,
              height: 1.2,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).buttonColor,
            ),
            minFontSize: MinFontSize(context).minFontSize,
            stepGranularity: 0.1,
          ),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          onPressed: () {
            widget
                .onBoost(widget.boostAmountList.elementAt(selectedBoostIndex));
          },
        ),
        SizedBox(width: 16),
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
            maxHeight: 20.0,
            minHeight: 20.0,
            maxWidth: 20.0,
            minWidth: 20.0,
          ),
        ),
        SizedBox(
          width: 42,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AutoSizeText(
                NumberFormat.compact().format(
                    widget.boostAmountList.elementAt(selectedBoostIndex)),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.3,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
              AutoSizeText(
                "sats",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, letterSpacing: 1),
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              )
            ],
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
            maxHeight: 20.0,
            minHeight: 20.0,
            maxWidth: 20.0,
            minWidth: 20.0,
          ),
        ),
      ],
    );
  }
}
