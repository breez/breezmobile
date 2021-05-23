import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/keyboard_done_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAmountDialog extends StatefulWidget {
  final List presetAmountsList;
  final Function(int customAmount) setAmount;

  CustomAmountDialog(this.presetAmountsList, this.setAmount);

  @override
  State<StatefulWidget> createState() {
    return CustomAmountDialogState();
  }
}

class CustomAmountDialogState extends State<CustomAmountDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _customAmountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  KeyboardDoneAction _doneAction;

  @override
  void initState() {
    super.initState();
    _customAmountController.addListener(() {
      setState(() {});
    });
    _doneAction = KeyboardDoneAction(<FocusNode>[_amountFocusNode]);
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPaymentRequestDialog();
  }

  Widget _buildPaymentRequestDialog() {
    return AlertDialog(
      title: AutoSizeText(
        "Enter a Custom Amount:",
        style: Theme.of(context).dialogTheme.titleTextStyle,
        maxLines: 1,
      ),
      content: _buildAmountWidget(),
      actions: _buildActions(),
    );
  }

  Widget _buildAmountWidget() {
    return Theme(
      data: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                UnderlineInputBorder(borderSide: theme.greyBorderSide),
          ),
          hintColor: Theme.of(context).dialogTheme.contentTextStyle.color,
          colorScheme: ColorScheme.dark(
            primary: Theme.of(context).textTheme.button.color,
          ),
          primaryColor: Theme.of(context).textTheme.button.color,
          errorColor: theme.themeId == "BLUE"
              ? Colors.red
              : Theme.of(context).errorColor),
      child: Form(
        key: _formKey,
        child: TextFormField(
          focusNode: _amountFocusNode,
          controller: _customAmountController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value.length == 0) {
              return "Please enter a custom amount";
            }
            if (int.parse(value) < widget.presetAmountsList[0]) {
              return "Must be at least ${widget.presetAmountsList[0]} sats.";
            }
            return null;
          },
          style: Theme.of(context)
              .dialogTheme
              .contentTextStyle
              .copyWith(height: 1.0),
        ),
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
    if (_customAmountController.text.isNotEmpty &&
        _formKey.currentState.validate()) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.setAmount(
              int.parse(_customAmountController.text),
            );
          },
          child:
              Text("APPROVE", style: Theme.of(context).primaryTextTheme.button),
        ),
      );
    }
    return actions;
  }
}
