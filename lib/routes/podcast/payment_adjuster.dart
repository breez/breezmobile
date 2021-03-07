import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentAdjuster extends StatefulWidget {
  final BreezUserModel userModel;
  final List satsPerMinuteList;
  final ValueChanged<int> onChanged;

  PaymentAdjuster(
      {Key key, this.userModel, this.satsPerMinuteList, this.onChanged})
      : super(key: key);

  @override
  _PaymentAdjusterState createState() => _PaymentAdjusterState();
}

class _PaymentAdjusterState extends State<PaymentAdjuster> {
  @override
  Widget build(BuildContext context) {
    final userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    return StreamBuilder<BreezUserModel>(
        stream: userBloc.userStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return SizedBox();
          }
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                child: Stack(
                  children: [
                    Positioned(
                      left: 8,
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
                                    final currentAmount =
                                        snapshot.data.preferredSatsPerMinValue;
                                    var index = widget.satsPerMinuteList
                                        .indexOf(currentAmount);
                                    if (index > 0) {
                                      index--;
                                    }
                                    final satAmount = widget.satsPerMinuteList
                                        .elementAt(index);
                                    widget.onChanged(satAmount);
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
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
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
                                NumberFormat.compact().format(
                                    snapshot.data.preferredSatsPerMinValue),
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
                      right: 8,
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
                                    final currentAmount =
                                        snapshot.data.preferredSatsPerMinValue;
                                    var nextIndex = widget.satsPerMinuteList
                                        .indexOf(currentAmount);
                                    if (nextIndex >=
                                        widget.satsPerMinuteList.length) {
                                      nextIndex =
                                          widget.satsPerMinuteList.length - 1;
                                    }
                                    final satAmount = widget.satsPerMinuteList
                                        .elementAt(nextIndex);
                                    widget.onChanged(satAmount);
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
        });
  }
}
