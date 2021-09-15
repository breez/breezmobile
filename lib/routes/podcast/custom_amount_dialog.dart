import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/podcast/custom_amount_form.dart';
import 'package:flutter/cupertino.dart';
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
    return _buildPaymentRequestDialog();
  }

  Widget _buildPaymentRequestDialog() {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        "Enter a Custom Amount:",
        style: theme.dialogTheme.titleTextStyle.copyWith(fontSize: 16),
        maxLines: 1,
      ),
      content: _buildAmountWidget(theme),
      actions: _buildActions(),
    );
  }

  Widget _buildAmountWidget(ThemeData theme) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: CustomAmountFormField(
        focusNode: _amountFocusNode,
        controller: _amountController,
        preset: widget.presetAmountsList,
        style: theme.dialogTheme.contentTextStyle.copyWith(height: 1.0),
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
