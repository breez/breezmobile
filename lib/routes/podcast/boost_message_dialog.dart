import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/podcast/custom_amount_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoostMessageDialog extends StatefulWidget {
  final int customAmount;
  final List<int> preset;
  final Function(int customAmount, String boostMessage) setBoost;

  BoostMessageDialog(
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
  final TextEditingController _messageController = TextEditingController();
  CustomAmountTextEditingController _amountController;
  final FocusNode _messageFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

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
    return _buildBoostMessageDialog(context);
  }

  Widget _buildBoostMessageDialog(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        "Send a Boostagram",
        style: Theme.of(context).dialogTheme.titleTextStyle.copyWith(fontSize: 16),
        maxLines: 1,
      ),
      content: _buildMessageWidget(),
      actions: _buildActions(),
    );
  }

  Widget _buildMessageWidget() {
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
            maxLength: 90,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            style: Theme.of(context).dialogTheme.contentTextStyle.copyWith(height: 1.0),
            decoration: InputDecoration(
              labelText: "Boostagram (optional)",
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
              labelText: "Boost Amount (in sats)",
            ),
            style: Theme.of(context).dialogTheme.contentTextStyle.copyWith(height: 1.0),
          ),
        )
      ],
    );
  }

  List<Widget> _buildActions() {
    List<Widget> actions = [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text("CANCEL", style: Theme.of(context).primaryTextTheme.button),
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
            "BOOST!",
            style: Theme.of(context).primaryTextTheme.button,
          ),
        ),
      );
    }
    return actions;
  }
}
