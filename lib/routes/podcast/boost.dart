import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BoostWidget extends StatefulWidget {
  final BreezUserModel userModel;
  final List boostAmountList;
  final ValueChanged<int> onBoost;

  BoostWidget({Key key, this.userModel, this.boostAmountList, this.onBoost})
      : super(key: key);

  @override
  _BoostWidgetState createState() => _BoostWidgetState();
}

class _BoostWidgetState extends State<BoostWidget> {
  @override
  Widget build(BuildContext context) {
    final userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    return StreamBuilder<BreezUserModel>(
        stream: userBloc.userStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return SizedBox();
          }

          final selectedIndex = widget.boostAmountList
              .indexOf(widget.userModel.preferredBoostValue);

          return StreamBuilder<AccountModel>(
              stream: accountBloc.accountStream,
              builder: (context, acc) {
                if (acc.data == null) {
                  return SizedBox();
                }
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 88,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              side: BorderSide(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Color(0xFF0085fb)
                                      : Colors.white70,
                                  width: 1.6)),
                        ),
                        icon: ImageIcon(
                          AssetImage("src/icon/boost.png"),
                          size: 20,
                          color: Theme.of(context)
                              .appBarTheme
                              .actionsIconTheme
                              .color,
                        ),
                        label: Container(
                          width: 44,
                          child: AutoSizeText(
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
                            maxLines: 1,
                          ),
                        ),
                        onPressed: () {
                          var boostAmount =
                              widget.userModel.preferredBoostValue;
                          if (acc.data.balance.toInt() <= boostAmount) {
                            showFlushbar(context,
                                message:
                                    "You don't have enough funds to complete this payment.");
                            return;
                          }
                          widget.onBoost(
                              widget.boostAmountList.elementAt(selectedIndex));
                        },
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Center(
                        child: Container(
                          width: 92,
                          child: Stack(
                            fit: StackFit.loose,
                            children: [
                              GestureDetector(
                                  child: Container(
                                      width: 32,
                                      height: 64,
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(32),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          onTap: () {
                                            var nextIndex = (selectedIndex == 0)
                                                ? selectedIndex
                                                : selectedIndex - 1;
                                            final nextAmount = widget
                                                .boostAmountList
                                                .elementAt(nextIndex);
                                            userBloc.userActionsSink.add(
                                                SetBoostAmount(nextAmount));
                                          },
                                          splashColor:
                                              Theme.of(context).splashColor,
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
                                  width: 42,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 20,
                                        child: AutoSizeText(
                                          NumberFormat.compact().format(snapshot
                                              .data.preferredBoostValue),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14.3,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2,
                                          ),
                                          minFontSize:
                                              MinFontSize(context).minFontSize,
                                          stepGranularity: 0.1,
                                          maxLines: 1,
                                        ),
                                      ),
                                      AutoSizeText(
                                        "sats",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 10, letterSpacing: 1),
                                        minFontSize:
                                            MinFontSize(context).minFontSize,
                                        stepGranularity: 0.1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 60,
                                child: GestureDetector(
                                    child: Container(
                                        width: 32,
                                        height: 64,
                                        child: Material(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                            onTap: () {
                                              var nextIndex = (selectedIndex >=
                                                      widget.boostAmountList
                                                              .length -
                                                          1)
                                                  ? selectedIndex
                                                  : selectedIndex + 1;
                                              final nextAmount = widget
                                                  .boostAmountList
                                                  .elementAt(nextIndex);
                                              userBloc.userActionsSink.add(
                                                  SetBoostAmount(nextAmount));
                                            },
                                            splashColor:
                                                Theme.of(context).splashColor,
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
                      ),
                    ),
                  ],
                );
              });
        });
  }
}
