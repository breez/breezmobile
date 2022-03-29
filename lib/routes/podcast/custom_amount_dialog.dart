import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/podcast/custom_amount_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAmountDialog extends StatefulWidget {
  final int customAmount;
  final List<int> presetAmountsList;
  final Function(int customAmount) setAmount;

  const CustomAmountDialog(
    this.customAmount,
    this.presetAmountsList,
    this.setAmount,
  );

  @override
  State<StatefulWidget> createState() {
    return CustomAmountDialogState();
  }
}

class CustomAmountDialogState extends State<CustomAmountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountFocusNode = FocusNode();
  CustomAmountTextEditingController _amountController;

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
    final theme = Theme.of(context);
    final texts = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(
        texts.podcast_boost_custom_amount,
        style: theme.dialogTheme.titleTextStyle.copyWith(
          fontSize: 16,
        ),
        maxLines: 1,
      ),
      content: _buildAmountWidget(theme),
      actions: _buildActions(context),
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
        style: theme.dialogTheme.contentTextStyle.copyWith(
          height: 1.0,
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    List<Widget> actions = [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          texts.podcast_boost_action_cancel,
          style: themeData.primaryTextTheme.button,
        ),
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
          child: Text(
            texts.podcast_boost_action_approve,
            style: themeData.primaryTextTheme.button,
          ),
        ),
      );
    }
    return actions;
  }
}
