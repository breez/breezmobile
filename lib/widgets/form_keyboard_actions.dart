import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class FormActionsWrapper extends StatelessWidget {
  final FocusNode numericFieldNode;
  final Widget child;

  const FormActionsWrapper({Key key, this.numericFieldNode, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      child: _KeyboardActionsWrapper(focusNode: numericFieldNode, child: child),
      config: KeyboardActionsConfig(
          keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
          keyboardBarColor: Colors.grey[200],
          nextFocus: true,
          actions: [
            KeyboardActionsItem(
              focusNode: numericFieldNode,
              toolbarButtons: [
                (node) {
                  return GestureDetector(
                    onTap: () => node.unfocus(),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("DONE",
                          style: TextStyle(
                              color: theme.BreezColors.blue[500],
                              fontWeight: FontWeight.bold)),
                    ),
                  );
                }
              ],
            )
          ]),
    );
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
      KeyboardActionstate().setConfig(_buildActionsConfig());
    }
    super.initState();
  }

  KeyboardActionsConfig _buildActionsConfig() {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          KeyboardActionsItem(
            focusNode: widget.focusNode,
            toolbarButtons: [
              (node) {
                return GestureDetector(
                  onTap: () => node.unfocus(),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("DONE",
                        style: TextStyle(
                            color: theme.BreezColors.blue[500],
                            fontWeight: FontWeight.bold)),
                  ),
                );
              }
            ],
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
