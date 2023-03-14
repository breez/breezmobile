import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/podcast/custom_amount_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class BoostMessageDialog extends StatefulWidget {
  final int customAmount;
  final List<int> preset;
  final Function(int customAmount, String boostMessage) setBoost;

  const BoostMessageDialog(
    this.customAmount,
    this.preset,
    this.setBoost,
  );

  @override
  State<StatefulWidget> createState() {
    return BoostMessageDialogState();
  }
}

class BoostMessageDialogState extends State<BoostMessageDialog> {
  final _messageKey = GlobalKey<FormState>();
  final _amountKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _messageFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  CustomAmountTextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = CustomAmountTextEditingController(
      customAmount: widget.customAmount,
    );
    _messageController.addListener(() {
      setState(() {});
    });
    _amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texts = context.texts();
    return AlertDialog(
      scrollable: true,
      title: Text(
        texts.podcast_boost_send_title,
        style: theme.dialogTheme.titleTextStyle.copyWith(
          fontSize: 16,
        ),
        maxLines: 1,
      ),
      content: _buildMessageWidget(context),
      actions: _buildActions(context),
    );
  }

  Widget _buildMessageWidget(BuildContext context) {
    final theme = Theme.of(context);
    final texts = context.texts();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _messageKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.disabled,
            focusNode: _messageFocusNode,
            controller: _messageController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.next,
            maxLines: null,
            maxLength: 128,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            style: theme.dialogTheme.contentTextStyle.copyWith(
              height: 1.0,
            ),
            decoration: InputDecoration(
              labelText: texts.podcast_boost_send_optional,
            ),
          ),
        ),
        Form(
          key: _amountKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: CustomAmountFormField(
            focusNode: _amountFocusNode,
            controller: _amountController,
            preset: widget.preset,
            decoration: InputDecoration(
              labelText: texts.podcast_boost_send_amount,
            ),
            style: theme.dialogTheme.contentTextStyle.copyWith(
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final texts = context.texts();
    final theme = Theme.of(context);
    List<Widget> actions = [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          texts.podcast_boost_action_cancel,
          style: theme.primaryTextTheme.labelLarge,
        ),
      ),
    ];
    if (_amountKey.currentState?.validate() ??
        _amountController.text.isNotEmpty) {
      actions.add(
        TextButton(
          onPressed: () {
            if (_amountKey.currentState?.validate() ?? false) {
              Navigator.pop(context);
              widget.setBoost(
                Currency.SAT.parseToInt(_amountController.text),
                _messageController.text,
              );
            }
          },
          child: Text(
            texts.podcast_boost_action_boost,
            style: theme.primaryTextTheme.labelLarge,
          ),
        ),
      );
    }
    return actions;
  }
}
