import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JoinSatsRoomDialog extends StatefulWidget {
  final Function(String roomID) joinSatsRoom;

  JoinSatsRoomDialog(this.joinSatsRoom);

  @override
  State<StatefulWidget> createState() {
    return JoinSatsRoomDialogState();
  }
}

class JoinSatsRoomDialogState extends State<JoinSatsRoomDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _satsRoomIDController = TextEditingController();

  @override
  void initState() {
    _satsRoomIDController.addListener(() {
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
        "Enter Sats Room ID:",
        style:
            Theme.of(context).dialogTheme.titleTextStyle.copyWith(fontSize: 16),
        maxLines: 1,
      ),
      content: _buildSatsRoomIDWidget(),
      actions: _buildActions(),
    );
  }

  Widget _buildSatsRoomIDWidget() {
    // TODO: Add join options
    return Form(
      key: _formKey,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.disabled,
        controller: _satsRoomIDController,
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
    if (_satsRoomIDController.text.isNotEmpty) {
      actions.add(
        TextButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.pop(context);
              widget.joinSatsRoom(_satsRoomIDController.text);
            }
          },
          child: Text("JOIN", style: Theme.of(context).primaryTextTheme.button),
        ),
      );
    }
    return actions;
  }
}
