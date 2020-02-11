import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';

class SessionInstructions extends StatelessWidget {
  final Widget _child;
  final List<String> _actions;
  final List<String> _disabledActions;
  final Function(String) _onAction;

  SessionInstructions(this._child,
      {List<String> actions = const [],
      Function(String) onAction,
      List<String> disabledActions = const []})
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
          color: Theme.of(context).primaryColorDark,
          padding: EdgeInsets.only(
              left: 16.0,
              top: 0.0,
              right: 16.0,
              bottom: hasActions ? 0.0 : 0.0),
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: hasActions
                                ? const EdgeInsets.only(bottom: 36.0)
                                : const EdgeInsets.only(),
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
              height: 24.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: (_actions ?? []).map((action) {
                  return Padding(
                    padding: EdgeInsets.only(left: 4, right: 4),
                    child: OutlineButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        borderSide: BorderSide(
                            color: theme.BreezColors.white[500],
                            style: BorderStyle.solid),
                        child: Text(
                          action.toUpperCase(),
                          style: theme.sessionActionBtnStyle,
                        ),
                        onPressed: _disabledActions.contains(action)
                            ? null
                            : () => _onAction(action)),
                  );
                }).toList(),
              ),
            ))
      ],
    );
  }
}
