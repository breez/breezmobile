import 'package:flutter/material.dart';
import 'package:breez/l10n/locales.dart';

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
                context.l10n.fee_chooser_option_economy,
              ),
            ),
            Expanded(
              child: buildFeeOption(
                context,
                1,
                regularFee == null,
                context.l10n.fee_chooser_option_regular,
              ),
            ),
            Expanded(
              child: buildFeeOption(
                context,
                2,
                priorityFee == null,
                context.l10n.fee_chooser_option_priority,
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

  Widget buildFeeOption(
    BuildContext context,
    int index,
    bool disabled,
    String text,
  ) {
    final borderColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.4);
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
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: isSelected
            ? Theme.of(context).colorScheme.onSurface
            : Theme.of(context).canvasColor,
        border: border,
      ),
      child: TextButton(
        onPressed: disabled ? null : () => onSelect(index),
        child: Text(
          text,
          style: Theme.of(context).textTheme.button.copyWith(
            color: disabled
                ? Theme.of(context).colorScheme.onSurface.withOpacity(0.4)
                : isSelected
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).colorScheme.onSurface,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _estimatedDelivery(context),
          style: Theme.of(context).textTheme.button.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
      ],
    );
  }

  String _estimatedDelivery(BuildContext context) {
    final hours = targetConfirmation / 6;

    if (hours >= 12.0) {
      return context.l10n.fee_chooser_estimated_delivery_more_than_day;
    } else if (hours >= 4) {
      return context.l10n.fee_chooser_estimated_delivery_hour_range(
        hours.ceil().toString(),
      );
    } else if (hours >= 2.0) {
      return context.l10n.fee_chooser_estimated_delivery_hours(
        hours.ceil().toString(),
      );
    } else if (hours >= 1.0) {
      return context.l10n.fee_chooser_estimated_delivery_hour;
    } else {
      return context.l10n.fee_chooser_estimated_delivery_minutes(
        (targetConfirmation * 10).toString(),
      );
    }
  }
}

class FeeOption {
  final int sats;
  final int confirmationTarget;

  const FeeOption(
    this.sats,
    this.confirmationTarget,
  );
}
