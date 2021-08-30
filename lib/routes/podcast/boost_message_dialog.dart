import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BoostMessageDialog extends StatefulWidget {
  final Function(String boostMessage) setMessage;

  BoostMessageDialog(this.setMessage);

  @override
  State<StatefulWidget> createState() {
    return BoostMessageDialogState();
  }
}

class BoostMessageDialogState extends State<BoostMessageDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _boostMessageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _boostMessageController.addListener(() {
      setState(() {});
    });
    if (_boostMessageController.text.isEmpty) _messageFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBoostMessageDialog();
  }

  Widget _buildBoostMessageDialog() {
    return AlertDialog(
      title: Text(
        "Send a Boostagram",
        style:
            Theme.of(context).dialogTheme.titleTextStyle.copyWith(fontSize: 16),
        maxLines: 1,
      ),
      content: _buildMessageWidget(),
      actions: _buildActions(),
    );
  }

  Widget _buildMessageWidget() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.disabled,
        focusNode: _messageFocusNode,
        controller: _boostMessageController,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.done,
        maxLines: null,
        maxLength: 90,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        validator: (raw) {
          if (raw.length == 0) {
            return "Please enter a message";
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
    if (_boostMessageController.text.isNotEmpty) {
      actions.add(
        TextButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.pop(context);
              widget.setMessage(_boostMessageController.text);
            }
          },
          child:
              Text("BOOST!", style: Theme.of(context).primaryTextTheme.button),
        ),
      );
    }
    return actions;
  }
}
