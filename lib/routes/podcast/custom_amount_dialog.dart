import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAmountDialog extends StatefulWidget {
  final int customAmount;
  final List presetAmountsList;
  final Function(int customAmount) setAmount;

  CustomAmountDialog(this.customAmount, this.presetAmountsList, this.setAmount);

  @override
  State<StatefulWidget> createState() {
    return CustomAmountDialogState();
  }
}

class CustomAmountDialogState extends State<CustomAmountDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _customAmountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _customAmountController.addListener(() {
      setState(() {});
    });
    _customAmountController.text =
        !widget.presetAmountsList.contains(widget.customAmount)
            ? widget.customAmount?.toString()
            : null;
    if (_customAmountController.text.isEmpty) _amountFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPaymentRequestDialog();
  }

  Widget _buildPaymentRequestDialog() {
    return AlertDialog(
      title: AutoSizeText(
        "Enter a Custom Amount:",
        style:
            Theme.of(context).dialogTheme.titleTextStyle.copyWith(fontSize: 16),
        maxLines: 1,
      ),
      content: _buildAmountWidget(),
      actions: _buildActions(),
    );
  }

  Widget _buildAmountWidget() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.disabled,
        focusNode: _amountFocusNode,
        controller: _customAmountController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value.length == 0) {
            return "Please enter a custom amount";
          }
          if (int.parse(value) < widget.presetAmountsList[0]) {
            return "Please enter at least ${widget.presetAmountsList[0]} sats.";
          }
          return null;
        },
        style: Theme.of(context)
            .dialogTheme
            .contentTextStyle
            .copyWith(height: 1.0),
      ),
    );
  }

  List<Widget> _buildActions() {
    List<Widget> actions = [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text("CANCEL", style: Theme.of(context).primaryTextTheme.button),
      ),
    ];
    if (_customAmountController.text.isNotEmpty) {
      actions.add(
        TextButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.pop(context);
              widget.setAmount(
                int.parse(_customAmountController.text),
              );
            }
          },
          child:
              Text("APPROVE", style: Theme.of(context).primaryTextTheme.button),
        ),
      );
    }
    return actions;
  }
}
