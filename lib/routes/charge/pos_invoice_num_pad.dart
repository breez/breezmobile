import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

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
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _numberButton(context, "1"),
                _numberButton(context, "2"),
                _numberButton(context, "3"),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _numberButton(context, "4"),
                _numberButton(context, "5"),
                _numberButton(context, "6"),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _numberButton(context, "7"),
                _numberButton(context, "8"),
                _numberButton(context, "9"),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _clearButton(context),
                _numberButton(context, "0"),
                _additionButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _numberButton(
    BuildContext context,
    String number,
  ) {
    final themeData = Theme.of(context);
    return Container(
      width: width / 3.0,
      height: height / 4.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: themeData.colorScheme.background,
          width: 0.5,
        ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
        ),
        onPressed: () => onNumberPressed(number),
        child: Text(
          number,
          textAlign: TextAlign.center,
          style: theme.numPadNumberStyle,
        ),
      ),
    );
  }

  Widget _clearButton(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    return Container(
      width: width / 3.0,
      height: height / 4.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: themeData.colorScheme.background,
          width: 0.5,
        ),
      ),
      child: GestureDetector(
        onLongPress: approveClear,
        child: TextButton(
          onPressed: clearAmounts,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
          ),
          child: Text(
            texts.pos_invoice_num_pad_clear,
            style: theme.numPadNumberStyle,
          ),
        ),
      ),
    );
  }

  Widget _additionButton(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    return Container(
      width: width / 3.0,
      height: height / 4.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: themeData.colorScheme.background,
          width: 0.5,
        ),
      ),
      child: TextButton(
        onPressed: onAddition,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          alignment: Alignment.center,
        ),
        child: AutoSizeText(
          texts.pos_invoice_num_pad_plus,
          style: theme.numPadAdditionStyle,
        ),
      ),
    );
  }
}
