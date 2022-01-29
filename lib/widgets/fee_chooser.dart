import 'package:breez/utils/build_context.dart';
import 'package:flutter/material.dart';

class FeeChooser extends StatelessWidget {
  final FeeOption economyFee;
  final FeeOption regularFee;
  final FeeOption priorityFee;
  final int selectedIndex;
  final Function(int selected) onSelect;

  const FeeChooser({
    Key key,
    this.economyFee,
    this.regularFee,
    this.priorityFee,
    this.selectedIndex,
    this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: buildFeeOption(
                context,
                0,
                economyFee == null,
                l10n.fee_chooser_option_economy,
              ),
            ),
            Expanded(
              child: buildFeeOption(
                context,
                1,
                regularFee == null,
                l10n.fee_chooser_option_regular,
              ),
            ),
            Expanded(
              child: buildFeeOption(
                context,
                2,
                priorityFee == null,
                l10n.fee_chooser_option_priority,
              ),
            )
          ],
        ),
        SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProcessingSpeed(
              targetConfirmation: _getSelectedTargetConf(),
            )
          ],
        ),
      ],
    );
  }

  Widget buildFeeOption(BuildContext context,
      int index,
      bool disabled,
      String text,) {
    ThemeData theme = context.theme;
    Color canvasColor = theme.canvasColor;
    Color onSurfaceColor = theme.colorScheme.onSurface;
    final borderColor = onSurfaceColor.withOpacity(0.4);

    Border border;
    var borderRadius;
    if (index == 0) {
      border = Border.all(color: borderColor);
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(5.0),
        bottomLeft: Radius.circular(5.0),
      );
    } else if (index == 2) {
      border = Border.all(color: borderColor);
      borderRadius = BorderRadius.only(
        topRight: Radius.circular(5.0),
        bottomRight: Radius.circular(5.0),
      );
    } else {
      border = Border(
        bottom: BorderSide(color: borderColor),
        top: BorderSide(color: borderColor),
      );
    }

    bool isSelected = this.selectedIndex == index;
    Color feeOptionColor = isSelected ? onSurfaceColor : canvasColor;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: feeOptionColor,
        border: border,
      ),
      child: TextButton(
        onPressed: disabled ? null : () => onSelect(index),
        child: Text(
          text,
          style: theme.textTheme.button.copyWith(
            color: disabled ? borderColor : feeOptionColor,
          ),
        ),
      ),
    );
  }

  int _getSelectedTargetConf() {
    FeeOption selectedOption;
    switch (selectedIndex) {
      case 0:
        selectedOption = economyFee;
        break;
      case 1:
        selectedOption = regularFee;
        break;
      case 2:
        selectedOption = priorityFee;
        break;
    }
    return selectedOption.confirmationTarget;
  }
}

class ProcessingSpeed extends StatelessWidget {
  final int targetConfirmation;

  const ProcessingSpeed({
    Key key,
    this.targetConfirmation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = context.theme;
    Color onSurfaceColor = theme.colorScheme.onSurface.withOpacity(0.4);
    TextStyle textStyle = theme.textTheme.button.copyWith(
      color: onSurfaceColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _estimatedDelivery(context),
          style: textStyle,
        ),
      ],
    );
  }

  String _estimatedDelivery(BuildContext context) {
    var l10n = context.l10n;
    final hours = targetConfirmation / 6;

    if (hours >= 12.0) {
      return l10n.fee_chooser_estimated_delivery_more_than_day;
    } else if (hours >= 4) {
      return l10n.fee_chooser_estimated_delivery_hour_range(
        hours.ceil().toString(),
      );
    } else if (hours >= 2.0) {
      return l10n.fee_chooser_estimated_delivery_hours(
        hours.ceil().toString(),
      );
    } else if (hours >= 1.0) {
      return l10n.fee_chooser_estimated_delivery_hour;
    } else {
      return l10n.fee_chooser_estimated_delivery_minutes(
        (targetConfirmation * 10).toString(),
      );
    }
  }
}

class FeeOption {
  final int sats;
  final int confirmationTarget;

  const FeeOption(this.sats,
      this.confirmationTarget,);
}
