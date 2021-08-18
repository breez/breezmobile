import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JoinSatsZoneDialog extends StatefulWidget {
  final Function(String zoneID) joinSatsZone;

  JoinSatsZoneDialog(this.joinSatsZone);

  @override
  State<StatefulWidget> createState() {
    return JoinSatsZoneDialogState();
  }
}

class JoinSatsZoneDialogState extends State<JoinSatsZoneDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _satsZoneIDController = TextEditingController();

  @override
  void initState() {
    _satsZoneIDController.addListener(() {
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
        "Enter Sats Zone ID:",
        style:
            Theme.of(context).dialogTheme.titleTextStyle.copyWith(fontSize: 16),
        maxLines: 1,
      ),
      content: _buildSatsZoneIDWidget(),
      actions: _buildActions(),
    );
  }

  Widget _buildSatsZoneIDWidget() {
    // TODO: Add join options
    return Form(
      key: _formKey,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.disabled,
        controller: _satsZoneIDController,
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
    if (_satsZoneIDController.text.isNotEmpty) {
      actions.add(
        TextButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.pop(context);
              widget.joinSatsZone(_satsZoneIDController.text);
            }
          },
          child: Text("JOIN", style: Theme.of(context).primaryTextTheme.button),
        ),
      );
    }
    return actions;
  }
}
