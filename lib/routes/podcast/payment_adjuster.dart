import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/utils/min_font_size.dart';
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          child: Stack(
            children: [
              GestureDetector(
                  child: Container(
                      width: 32,
                      height: 64,
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(32),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(32),
                          onTap: () {
                            setState(() {
                              (selectedSatsPerMinuteIndex == 0)
                                  ? selectedSatsPerMinuteIndex = 0
                                  : selectedSatsPerMinuteIndex--;
                              widget.onChanged(widget.satsPerMinuteList
                                  .elementAt(selectedSatsPerMinuteIndex));
                            });
                          },
                          splashColor: Theme.of(context).splashColor,
                          highlightColor: Colors.transparent,
                          child: Icon(
                            Icons.remove_circle_outline,
                            size: 20,
                            color: Theme.of(context)
                                .appBarTheme
                                .actionsIconTheme
                                .color,
                          ),
                        ),
                      ))),
              Positioned(
                left: 24,
                top: 16,
                child: SizedBox(
                  width: 56,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 20,
                        child: AutoSizeText(
                          NumberFormat.compact().format(widget.satsPerMinuteList
                              .elementAt(selectedSatsPerMinuteIndex)),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.3,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                          minFontSize: MinFontSize(context).minFontSize,
                          stepGranularity: 0.1,
                          maxLines: 1,
                        ),
                      ),
                      AutoSizeText(
                        "sats/min",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, letterSpacing: 1),
                        minFontSize: MinFontSize(context).minFontSize,
                        stepGranularity: 0.1,
                        maxLines: 1,
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 72,
                child: GestureDetector(
                    child: Container(
                        width: 32,
                        height: 64,
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(32),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32),
                            onTap: () {
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
                            splashColor: Theme.of(context).splashColor,
                            highlightColor: Colors.transparent,
                            child: Icon(
                              Icons.add_circle_outline,
                              size: 20,
                              color: Theme.of(context)
                                  .appBarTheme
                                  .actionsIconTheme
                                  .color,
                            ),
                          ),
                        ))),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
