import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentAdjuster extends StatefulWidget {
  final BreezUserModel userModel;
  final List satsPerMinuteList;
  final ValueChanged<int> onChanged;

  PaymentAdjuster({this.userModel, this.satsPerMinuteList, this.onChanged});

  @override
  _PaymentAdjusterState createState() => _PaymentAdjusterState();
}

class _PaymentAdjusterState extends State<PaymentAdjuster> {
  int selectedSatsPerMinuteIndex;

  @override
  void initState() {
    super.initState();
    selectedSatsPerMinuteIndex = widget.satsPerMinuteList
        .indexOf(widget.userModel.preferredSatsPerMinValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.remove_circle_outline,
            size: 20,
            color: Theme.of(context).appBarTheme.actionsIconTheme.color,
          ),
          onPressed: () {
            setState(() {
              (selectedSatsPerMinuteIndex == 0)
                  ? selectedSatsPerMinuteIndex = 0
                  : selectedSatsPerMinuteIndex--;
              widget.onChanged(widget.satsPerMinuteList
                  .elementAt(selectedSatsPerMinuteIndex));
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: [
              Text(
                NumberFormat.compact().format(widget.satsPerMinuteList
                    .elementAt(selectedSatsPerMinuteIndex)),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "sats/min",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, letterSpacing: 1),
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
              (selectedSatsPerMinuteIndex ==
                      widget.satsPerMinuteList.length - 1)
                  ? selectedSatsPerMinuteIndex =
                      widget.satsPerMinuteList.length - 1
                  : selectedSatsPerMinuteIndex++;
              widget.onChanged(widget.satsPerMinuteList
                  .elementAt(selectedSatsPerMinuteIndex));
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
