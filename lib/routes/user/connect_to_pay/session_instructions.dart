import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class SessionInstructions extends StatelessWidget {
  final Widget _child;
  final List<String> _actions;
  final List<String> _disabledActions;
  final Function(String) _onAction;

  SessionInstructions(this._child, {List<String> actions = const [], Function(String) onAction, List<String> disabledActions = const []})
      : _actions = actions,
        _disabledActions = disabledActions,
        _onAction = onAction;

  @override
  Widget build(BuildContext context) {
    bool hasActions = _actions != null && _actions.length > 0;
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Container(
          height: 100.0,
          color: theme.massageBackgroundColor,
          padding: new EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0, bottom: hasActions ? 0.0 : 0.0),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: hasActions ? const EdgeInsets.only(bottom: 36.0) : const EdgeInsets.only(),
                        child: Center(child: _child),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
        Positioned(
            bottom: 10.0,
            child: Container(
              height: 36.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: (_actions ?? []).map((action) {
                  return FlatButton(
                      child: Text(action.toUpperCase()), onPressed: _disabledActions.contains(action) ? null : () => _onAction(action));
                }).toList(),
              ),
            ))
      ],
    );
  }
}
