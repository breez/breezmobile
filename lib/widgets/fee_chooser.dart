import 'package:flutter/material.dart';

class FeeChooser extends StatelessWidget {
  final FeeOption economyFee;
  final FeeOption regularFee;
  final FeeOption priorityFee;
  final int selectedIndex;
  final Function(int selected) onSelect;

  const FeeChooser(
      {Key key,
      this.economyFee,
      this.regularFee,
      this.priorityFee,
      this.selectedIndex,
      this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Expanded(child: buildFeeOption(context, 0, economyFee, "Economy")),
          Expanded(child: buildFeeOption(context, 1, economyFee, "Regular")),
          Expanded(child: buildFeeOption(context, 2, economyFee, "Priority"))
        ]),
        SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ProcessingSpeed(targetConfirmation: _getSelectedTargetConf())
          ],
        ),
      ],
    );
  }

  Widget buildFeeOption(
      BuildContext context, int index, FeeOption option, String text) {
    var borderColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.4);
    Border border;
    var borderRadius;
    if (index == 0) {
      border = Border.all(color: borderColor);
      borderRadius = BorderRadius.only(
          topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0));
    } else if (index == 2) {
      border = Border.all(color: borderColor);
      borderRadius = BorderRadius.only(
          topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0));
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
          border: border),
      child: FlatButton(
          onPressed: () {
            onSelect(index);
          },
          child: Text(text,
              style: Theme.of(context).textTheme.button.copyWith(
                  color: isSelected
                      ? Theme.of(context).canvasColor
                      : Theme.of(context).colorScheme.onSurface))),
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

  const ProcessingSpeed({Key key, this.targetConfirmation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String estimatedDelivery = "${targetConfirmation * 10} minutes";
    var hours = targetConfirmation / 6;
    if (hours >= 12.0) {
      estimatedDelivery = "more than a day";
    } else if (hours >= 4) {
      estimatedDelivery = "${hours.ceil()}-24 hours";
    } else if (hours >= 1.0) {
      estimatedDelivery = "${hours.ceil()} hour";
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Estimated Delivery: ~$estimatedDelivery",
            style: Theme.of(context).textTheme.button.copyWith(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
          )
        ]);
  }
}

class FeeOption {
  final int sats;
  final int confirmationTarget;

  FeeOption(this.sats, this.confirmationTarget);
}
