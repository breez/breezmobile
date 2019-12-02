import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:breez/theme_data.dart' as theme;

class FormActionsWrapper extends StatelessWidget {
  final FocusNode numericFieldNode;
  final Widget child;

  const FormActionsWrapper({Key key, this.numericFieldNode, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormKeyboardActions(
        child:
            _KeyboardActionsWrapper(focusNode: numericFieldNode, child: child));
  }
}

class _KeyboardActionsWrapper extends StatefulWidget {
  final FocusNode focusNode;
  final Widget child;

  const _KeyboardActionsWrapper({Key key, this.focusNode, this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _KeyboardActionsWrapperState();
  }
}

class _KeyboardActionsWrapperState extends State<_KeyboardActionsWrapper> {
  @override
  void initState() {
    // Configure keyboard actions
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      FormKeyboardActions.setKeyboardActions(
          context, _buildActionsConfig(context));
    }
    super.initState();
  }

  KeyboardActionsConfig _buildActionsConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          KeyboardAction(
              focusNode: widget.focusNode,
              closeWidget: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Done",
                    style: TextStyle(
                        color: theme.BreezColors.blue[500],
                        fontWeight: FontWeight.bold)),
              ))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
