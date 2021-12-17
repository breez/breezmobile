import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PosInvoiceNumPad extends StatelessWidget {
  final Sale currentSale;
  final double width;
  final double height;
  final VoidCallback approveClear;
  final VoidCallback clearAmounts;
  final VoidCallback onAddition;
  final Function(String) onNumberPressed;

  const PosInvoiceNumPad({
    Key key,
    this.currentSale,
    this.width,
    this.height,
    this.approveClear,
    this.clearAmounts,
    this.onAddition,
    this.onNumberPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: (width / height),
        padding: EdgeInsets.zero,
        children: List<int>.generate(9, (i) => i)
            .map((index) => _numberButton(
                  context,
                  (index + 1).toString(),
                ))
            .followedBy([
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: themeData.backgroundColor,
                width: 0.5,
              ),
            ),
            child: GestureDetector(
              onLongPress: approveClear,
              child: TextButton(
                onPressed: clearAmounts,
                child: Text(
                  texts.pos_invoice_num_pad_clear,
                  style: theme.numPadNumberStyle,
                ),
              ),
            ),
          ),
          _numberButton(context, "0"),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: themeData.backgroundColor,
                width: 0.5,
              ),
            ),
            child: TextButton(
              onPressed: onAddition,
              child: Text(
                texts.pos_invoice_num_pad_plus,
                style: theme.numPadAdditionStyle,
              ),
            ),
          ),
        ]).toList());
  }

  Container _numberButton(
    BuildContext context,
    String number,
  ) {
    final themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: themeData.backgroundColor,
          width: 0.5,
        ),
      ),
      child: TextButton(
        onPressed: () => onNumberPressed(number),
        child: Text(
          number,
          textAlign: TextAlign.center,
          style: theme.numPadNumberStyle,
        ),
      ),
    );
  }
}
