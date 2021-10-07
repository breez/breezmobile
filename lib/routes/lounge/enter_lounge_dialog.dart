import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnterLoungeDialog extends StatefulWidget {
  final Function(String loungeID) enterLounge;

  EnterLoungeDialog(this.enterLounge);

  @override
  State<StatefulWidget> createState() {
    return EnterLoungeDialogState();
  }
}

class EnterLoungeDialogState extends State<EnterLoungeDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _loungeIDController = TextEditingController();

  @override
  void initState() {
    _loungeIDController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPaymentRequestDialog();
  }

  Widget _buildPaymentRequestDialog() {
    return AlertDialog(
      title: AutoSizeText(
        "Enter Lounge ID:",
        style:
            Theme.of(context).dialogTheme.titleTextStyle.copyWith(fontSize: 16),
        maxLines: 1,
      ),
      content: _buildLoungeIDWidget(),
      actions: _buildActions(),
    );
  }

  Widget _buildLoungeIDWidget() {
    // TODO: Add lounge options
    return Container(
      height: 200,
      width: 200,
      child: Form(
        key: _formKey,
        child: TextFormField(
          autovalidateMode: AutovalidateMode.disabled,
          controller: _loungeIDController,
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
    if (_loungeIDController.text.isNotEmpty) {
      actions.add(
        TextButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.pop(context);
              widget.enterLounge(_loungeIDController.text);
            }
          },
          child: Text("ENTER", style: Theme.of(context).primaryTextTheme.button),
        ),
      );
    }
    return actions;
  }
}
