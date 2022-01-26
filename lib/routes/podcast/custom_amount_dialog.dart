import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/podcast/custom_amount_form.dart';
import 'package:flutter/material.dart';

class CustomAmountDialog extends StatefulWidget {
  final int customAmount;
  final List<int> presetAmountsList;
  final Function(int customAmount) setAmount;

  CustomAmountDialog(this.customAmount, this.presetAmountsList, this.setAmount);

  @override
  State<StatefulWidget> createState() {
    return CustomAmountDialogState();
  }
}

class CustomAmountDialogState extends State<CustomAmountDialog> {
  final _formKey = GlobalKey<FormState>();
  CustomAmountTextEditingController _amountController;
  final FocusNode _amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _amountController = CustomAmountTextEditingController();
    _amountController.addListener(() {
      setState(() {});
    });
    if (_amountController.text.isEmpty) {
      _amountFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildPaymentRequestDialog(context);
  }

  Widget _buildPaymentRequestDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Enter a Custom Amount:",
        style: Theme.of(context).dialogTheme.titleTextStyle.copyWith(fontSize: 16),
        maxLines: 1,
      ),
      content: _buildAmountWidget(context),
      actions: _buildActions(),
    );
  }

  Widget _buildAmountWidget(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: CustomAmountFormField(
        focusNode: _amountFocusNode,
        controller: _amountController,
        preset: widget.presetAmountsList,
        style: Theme.of(context).dialogTheme.contentTextStyle.copyWith(height: 1.0),
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
    if (_amountController.text.isNotEmpty) {
      actions.add(
        TextButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.pop(context);
              widget.setAmount(
                Currency.SAT.parseToInt(_amountController.text),
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
