import 'dart:math';

import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/podcast/custom_amount_dialog.dart';
import 'package:breez/routes/podcast/widget/number_panel.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentAdjuster extends StatelessWidget {
  final BreezUserModel userModel;
  final ValueChanged<int> onChanged;

  const PaymentAdjuster({
    Key key,
    this.userModel,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final userBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: Stack(
            children: [
              _minusButton(context),
              Positioned(
                left: 0,
                right: 0,
                top: 16,
                child: NumberPanel(
                  topLabel: _formatSatsPerMinAmount(context),
                  bottomLabel: texts.podcast_boost_sats_min,
                  width: 56,
                  innerWidth: 42,
                  onTap: () => showDialog(
                    useRootNavigator: true,
                    context: context,
                    builder: (c) => CustomAmountDialog(
                      userModel.paymentOptions.customSatsPerMinValue,
                      userModel.paymentOptions.presetSatsPerMinuteAmountsList,
                      (satsPerMinute) =>
                          userBloc.userActionsSink.add(SetPaymentOptions(
                        userModel.paymentOptions.copyWith(
                          preferredSatsPerMinValue: satsPerMinute,
                          customSatsPerMinValue: satsPerMinute,
                        ),
                      )),
                    ),
                  ),
                ),
              ),
              _plusButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _minusButton(BuildContext context) {
    final themeData = Theme.of(context);
    return Positioned(
      left: 8,
      child: GestureDetector(
        child: SizedBox(
          width: 32,
          height: 64,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(32),
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: () => onChanged(_getPreviousAmount()),
              splashColor: themeData.splashColor,
              highlightColor: Colors.transparent,
              child: Icon(
                Icons.remove_circle_outline,
                size: 20,
                color: themeData.appBarTheme.actionsIconTheme.color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _plusButton(BuildContext context) {
    final themeData = Theme.of(context);
    return Positioned(
      right: 8,
      child: GestureDetector(
        child: SizedBox(
          width: 32,
          height: 64,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(32),
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: () => onChanged(_getNextAmount()),
              splashColor: themeData.splashColor,
              highlightColor: Colors.transparent,
              child: Icon(
                Icons.add_circle_outline,
                size: 20,
                color: themeData.appBarTheme.actionsIconTheme.color,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatSatsPerMinAmount(BuildContext context) {
    final texts = context.texts();
    var satsPerMinValue = userModel.paymentOptions.preferredSatsPerMinValue;
    final count = pow(10, (satsPerMinValue.toString().length - 3));
    var roundedValue = satsPerMinValue / count;
    return satsPerMinValue != roundedValue.round() * count
        ? NumberFormat.compactCurrency(
            decimalDigits: 3,
            symbol: texts.podcast_boost_symbol_circa,
          ).format(roundedValue.round() * count)
        : NumberFormat.compact().format(satsPerMinValue);
  }

  int _getPreviousAmount() {
    var currentAmount = userModel.paymentOptions.preferredSatsPerMinValue;
    var amountList = userModel.paymentOptions.satsPerMinuteIntervalsList;
    try {
      return amountList[amountList.indexOf(currentAmount) - 1];
    } catch (e) {
      return amountList.first;
    }
  }

  int _getNextAmount() {
    var currentAmount = userModel.paymentOptions.preferredSatsPerMinValue;
    var amountList = userModel.paymentOptions.satsPerMinuteIntervalsList;
    try {
      return amountList[amountList.indexOf(currentAmount) + 1];
    } catch (e) {
      return amountList.last;
    }
  }
}
