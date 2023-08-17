import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class PosInvoiceNumPad extends StatefulWidget {
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
  State<PosInvoiceNumPad> createState() => _PosInvoiceNumPadState();
}

class _PosInvoiceNumPadState extends State<PosInvoiceNumPad> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _numberButton("1"),
                _numberButton("2"),
                _numberButton("3"),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _numberButton("4"),
                _numberButton("5"),
                _numberButton("6"),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _numberButton("7"),
                _numberButton("8"),
                _numberButton("9"),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _clearButton(),
                _numberButton("0"),
                _additionButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _numberButton(String number) {
    final themeData = Theme.of(context);
    return Container(
      width: widget.width / 3.0,
      height: widget.height / 4.0,
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
        onPressed: () => widget.onNumberPressed(number),
        child: Text(
          number,
          textAlign: TextAlign.center,
          style: theme.numPadNumberStyle,
        ),
      ),
    );
  }

  Widget _clearButton() {
    final texts = context.texts();
    final themeData = Theme.of(context);
    return Container(
      width: widget.width / 3.0,
      height: widget.height / 4.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: themeData.colorScheme.background,
          width: 0.5,
        ),
      ),
      child: GestureDetector(
        onLongPress: widget.approveClear,
        child: TextButton(
          onPressed: widget.clearAmounts,
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

  Widget _additionButton() {
    final texts = context.texts();
    final themeData = Theme.of(context);
    return Container(
      width: widget.width / 3.0,
      height: widget.height / 4.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: themeData.colorScheme.background,
          width: 0.5,
        ),
      ),
      child: TextButton(
        onPressed: widget.onAddition,
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
