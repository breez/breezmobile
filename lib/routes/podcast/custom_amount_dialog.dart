import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/widgets/sat_amount_form_field_formatter.dart';
import 'package:fixnum/fixnum.dart';
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
    _customAmountController.text = _initialCustomAmount();
    if (_customAmountController.text.isEmpty) _amountFocusNode.requestFocus();
  }

  String _initialCustomAmount() {
    final initial = widget.customAmount;
    if (initial == null) {
      return null;
    }
    if (widget.presetAmountsList.contains(initial)) {
      return null;
    }
    return Currency.SAT.format(
      Int64(initial),
      includeDisplayName: false,
      includeCurrencySymbol: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildPaymentRequestDialog();
  }

  Widget _buildPaymentRequestDialog() {
    return AlertDialog(
      title: Text(
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
        inputFormatters: [SatAmountFormFieldFormatter()],
        validator: (raw) {
          if (raw.length == 0) {
            return "Please enter a custom amount";
          }
          int value = _satsValue(raw);
          if (value < widget.presetAmountsList[0]) {
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
                _satsValue(_customAmountController.text),
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

  int _satsValue(String raw) {
    int value;
    try {
      value = Currency.SAT.parse(raw).toInt();
    } catch (e) {
      return 0;
    }
    return value;
  }
}
