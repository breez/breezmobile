import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

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
    final texts = context.texts();
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
                texts.fee_chooser_option_economy,
              ),
            ),
            Expanded(
              child: buildFeeOption(
                context,
                1,
                regularFee == null,
                texts.fee_chooser_option_regular,
              ),
            ),
            Expanded(
              child: buildFeeOption(
                context,
                2,
                priorityFee == null,
                texts.fee_chooser_option_priority,
              ),
            )
          ],
        ),
        const SizedBox(
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
    final themeData = Theme.of(context);
    final borderColor = themeData.colorScheme.onSurface.withOpacity(0.4);
    Border border;
    BorderRadius borderRadius;
    if (index == 0) {
      border = Border.all(color: borderColor);
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(5.0),
        bottomLeft: Radius.circular(5.0),
      );
    } else if (index == 2) {
      border = Border.all(color: borderColor);
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(5.0),
        bottomRight: Radius.circular(5.0),
      );
    } else {
      border = Border(
        bottom: BorderSide(color: borderColor),
        top: BorderSide(color: borderColor),
      );
    }

    bool isSelected = selectedIndex == index;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: isSelected
            ? themeData.colorScheme.onSurface
            : themeData.canvasColor,
        border: border,
      ),
      child: TextButton(
        onPressed: disabled ? null : () => onSelect(index),
        child: Text(
          text,
          style: themeData.textTheme.labelLarge.copyWith(
            color: disabled
                ? themeData.colorScheme.onSurface.withOpacity(0.4)
                : isSelected
                    ? themeData.canvasColor
                    : themeData.colorScheme.onSurface,
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
    final themeData = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _estimatedDelivery(context),
          style: themeData.textTheme.labelLarge.copyWith(
            color: themeData.colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
      ],
    );
  }

  String _estimatedDelivery(BuildContext context) {
    final texts = context.texts();
    final hours = targetConfirmation / 6;

    if (hours >= 12.0) {
      return texts.fee_chooser_estimated_delivery_more_than_day;
    } else if (hours >= 4) {
      return texts.fee_chooser_estimated_delivery_hour_range(
        hours.ceil().toString(),
      );
    } else if (hours >= 2.0) {
      return texts.fee_chooser_estimated_delivery_hours(
        hours.ceil().toString(),
      );
    } else if (hours >= 1.0) {
      return texts.fee_chooser_estimated_delivery_hour;
    } else {
      return texts.fee_chooser_estimated_delivery_minutes(
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
