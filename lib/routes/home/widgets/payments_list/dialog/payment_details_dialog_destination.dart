import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogDestination extends StatelessWidget {
  final String title;
  final Int64 amount;
  final Currency currency;
  final AutoSizeGroup labelAutoSizeGroup;
  final AutoSizeGroup valueAutoSizeGroup;

  const PaymentDetailsDialogDestination({
    this.title,
    this.amount,
    this.currency,
    this.labelAutoSizeGroup,
    this.valueAutoSizeGroup,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Theme(
      data: themeData.copyWith(
        dividerColor: themeData.colorScheme.background,
      ),
      child: ExpansionTile(
        iconColor: themeData.primaryTextTheme.labelLarge.color,
        collapsedIconColor: themeData.primaryTextTheme.labelLarge.color,
        title: AutoSizeText(
          title,
          style: themeData.primaryTextTheme.headlineMedium,
          textAlign: TextAlign.left,
          maxLines: 1,
          group: labelAutoSizeGroup,
        ),
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: AutoSizeText(
                    currency.format(amount),
                    style: themeData.primaryTextTheme.displaySmall,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    group: valueAutoSizeGroup,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
