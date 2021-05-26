import 'dart:math';

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

import 'custom_amount_dialog.dart';

class BoostWidget extends StatefulWidget {
  final BreezUserModel userModel;
  final ValueChanged<int> onBoost;
  final ValueChanged<int> onChanged;

  BoostWidget({Key key, this.userModel, this.onBoost, this.onChanged})
      : super(key: key);

  @override
  _BoostWidgetState createState() => _BoostWidgetState();
}

class _BoostWidgetState extends State<BoostWidget> {
  @override
  Widget build(BuildContext context) {
    final userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    final selectedIndex = widget.userModel.paymentOptions.boostAmountList
        .indexOf(widget.userModel.paymentOptions.preferredBoostValue);

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
              Flexible(
                fit: FlexFit.tight,
                flex: 0,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      side: BorderSide(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Color(0xFF0085fb)
                                  : Colors.white70,
                          width: 1.6),
                    ),
                  ),
                  icon: ImageIcon(
                    AssetImage("src/icon/boost.png"),
                    size: 20,
                    color: Theme.of(context).appBarTheme.actionsIconTheme.color,
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
                        widget.userModel.paymentOptions.preferredBoostValue;
                    if (acc.data.balance.toInt() <= boostAmount) {
                      showFlushbar(context,
                          message:
                              "You don't have enough funds to complete this payment.");
                      return;
                    }
                    widget.onBoost(
                      widget.userModel.paymentOptions.boostAmountList
                          .elementAt(selectedIndex),
                    );
                  },
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: Center(
                  child: Container(
                    width: 99,
                    child: Stack(
                      fit: StackFit.loose,
                      children: [
                        Positioned(
                          left: 0,
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
                                    widget.onChanged(_getPreviousAmount());
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
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 24,
                          top: 16,
                          child: GestureDetector(
                            onTap: () => showDialog(
                              useRootNavigator: true,
                              context: context,
                              builder: (c) => CustomAmountDialog(
                                widget
                                    .userModel.paymentOptions.customBoostValue,
                                widget.userModel.paymentOptions
                                    .presetBoostAmountsList,
                                (int boostAmount) {
                                  userBloc.userActionsSink.add(
                                      SetPaymentOptions(widget
                                          .userModel.paymentOptions
                                          .copyWith(
                                              preferredBoostValue: boostAmount,
                                              customBoostValue: boostAmount)));
                                },
                              ),
                            ),
                            child: SizedBox(
                              width: 52,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 52,
                                    height: 20,
                                    child: AutoSizeText(
                                      _formatBoostAmount(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.3,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
                                      ),
                                      minFontSize: ((9) /
                                              MediaQuery.of(this.context)
                                                  .textScaleFactor)
                                          .floorToDouble(),
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
                        ),
                        Positioned(
                          left: 68,
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
                                    widget.onChanged(_getNextAmount());
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
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  String _formatBoostAmount() {
    var boostValue = widget.userModel.paymentOptions.preferredBoostValue;
    final count = pow(10, (boostValue.toString().length - 3));
    var roundedValue = boostValue / count;
    return NumberFormat.compactCurrency(
            decimalDigits: 3,
            symbol: boostValue != roundedValue.round() * count ? '~' : '')
        .format(roundedValue.round() * count);
  }

  int _getPreviousAmount() {
    var currentAmount = widget.userModel.paymentOptions.preferredBoostValue;
    var amountList = widget.userModel.paymentOptions.boostAmountList;
    try {
      return amountList[amountList.indexOf(currentAmount) - 1];
    } catch (RangeError) {
      return amountList.first;
    }
  }

  int _getNextAmount() {
    var currentAmount = widget.userModel.paymentOptions.preferredBoostValue;
    var amountList = widget.userModel.paymentOptions.boostAmountList;
    try {
      return amountList[amountList.indexOf(currentAmount) + 1];
    } catch (RangeError) {
      return amountList.last;
    }
  }
}
