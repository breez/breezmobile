import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/podcast/boost_message_dialog.dart';
import 'package:breez/routes/podcast/widget/number_panel.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_amount_dialog.dart';

class BoostWidget extends StatelessWidget {
  final BreezUserModel userModel;
  final Function(int total, {String boostMessage}) onBoost;
  final ValueChanged<int> onChanged;

  const BoostWidget({
    Key key,
    this.userModel,
    this.onBoost,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    final userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (context, acc) {
        if (acc.data == null) {
          return const SizedBox();
        }
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 88,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (c) => BoostMessageDialog(
                    userModel.paymentOptions.preferredBoostValue,
                    userModel.paymentOptions.presetBoostAmountsList,
                    (int boostAmount, String boostMessage) => _boost(
                      context,
                      userBloc,
                      acc.data,
                      boostAmount,
                      boostMessage,
                    ),
                  ),
                ),
                onLongPress: () => _boost(
                  context,
                  userBloc,
                  acc.data,
                  userModel.paymentOptions.preferredBoostValue,
                ),
                // ignore: missing_required_param
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      side: BorderSide(
                        color: themeData.brightness == Brightness.light
                            ? const Color(0xFF0085fb)
                            : Colors.white70,
                        width: 1.6,
                      ),
                    ),
                  ),
                  icon: ImageIcon(
                    const AssetImage("src/icon/boost.png"),
                    size: 20,
                    color: themeData.appBarTheme.actionsIconTheme.color,
                  ),
                  label: SizedBox(
                    width: 44,
                    child: AutoSizeText(
                      texts.podcast_boost_action_boost,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.2,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                        color: themeData.buttonTheme.colorScheme.onPrimary,
                      ),
                      minFontSize: MinFontSize(context).minFontSize,
                      stepGranularity: 0.1,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Center(
                child: SizedBox(
                  width: 92,
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      _minusButton(context),
                      Positioned(
                        left: 24,
                        top: 16,
                        child: NumberPanel(
                          topLabel: _formatBoostAmount(context),
                          bottomLabel: texts.podcast_boost_sats,
                          width: 42,
                          innerWidth: 38,
                          onTap: () => showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (c) => CustomAmountDialog(
                              userModel.paymentOptions.customBoostValue,
                              userModel.paymentOptions.presetBoostAmountsList,
                              (boostAmount) =>
                                  _setBoostAmount(userBloc, boostAmount),
                            ),
                          ),
                        ),
                      ),
                      _plusButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _minusButton(BuildContext context) {
    final themeData = Theme.of(context);
    return GestureDetector(
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
    );
  }

  Widget _plusButton(BuildContext context) {
    final themeData = Theme.of(context);
    return Positioned(
      left: 60,
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

  String _formatBoostAmount(BuildContext context) {
    final texts = context.texts();
    var boostValue = userModel.paymentOptions.preferredBoostValue;
    final count = pow(10, (boostValue.toString().length - 3));
    var roundedValue = boostValue / count;
    return boostValue != roundedValue.round() * count
        ? NumberFormat.compactCurrency(
            decimalDigits: 3,
            symbol: texts.podcast_boost_symbol_circa,
          ).format(roundedValue.round() * count)
        : NumberFormat.compact().format(boostValue);
  }

  int _getPreviousAmount() {
    var currentAmount = userModel.paymentOptions.preferredBoostValue;
    var amountList = userModel.paymentOptions.boostAmountList;
    // remove first item of the list "50" to not show it on +/- controller
    amountList = amountList.sublist(1);
    try {
      return amountList[amountList.indexOf(currentAmount) - 1];
    } catch (e) {
      return amountList.first;
    }
  }

  int _getNextAmount() {
    var currentAmount = userModel.paymentOptions.preferredBoostValue;
    var amountList = userModel.paymentOptions.boostAmountList;
    try {
      return amountList[amountList.indexOf(currentAmount) + 1];
    } catch (e) {
      return amountList.last;
    }
  }

  void _setBoostAmount(UserProfileBloc userBloc, int boostAmount) {
    userBloc.userActionsSink.add(
      SetPaymentOptions(
        userModel.paymentOptions.copyWith(
          preferredBoostValue: boostAmount,
          customBoostValue: boostAmount,
        ),
      ),
    );
  }

  void _boost(
    BuildContext context,
    UserProfileBloc userBloc,
    AccountModel acc,
    int amount, [
    String message,
  ]) {
    final texts = context.texts();
    if (acc.balance.toInt() <= amount) {
      showFlushbar(
        context,
        message: texts.podcast_boost_not_enough_founds,
      );
    } else {
      _setBoostAmount(userBloc, amount);
      onBoost(
        amount,
        boostMessage: message,
      );
    }
  }
}
