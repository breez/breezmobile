import 'package:breez/theme_data.dart';
import 'package:breez/widgets/designsystem/button/action_button.dart';
import 'package:breez/widgets/designsystem/variant.dart';
import 'package:flutter/material.dart';

class SingleButtonBottomBar extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool stickToBottom;
  final bool isRestoreFlow;

  const SingleButtonBottomBar({
    this.text,
    this.onPressed,
    this.stickToBottom = false,
    this.isRestoreFlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = isRestoreFlow ? blueTheme : Theme.of(context);

    return Theme(
      data: themeData,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: stickToBottom ? MediaQuery.of(context).viewInsets.bottom + 40.0 : 40.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 48.0,
                minWidth: 168.0,
              ),
              child: SubmitButton(
                text,
                onPressed,
                isRestoreFlow: isRestoreFlow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isRestoreFlow;

  const SubmitButton(
    this.text,
    this.onPressed, {
    this.isRestoreFlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = isRestoreFlow ? blueTheme : Theme.of(context);
    return Theme(
      data: themeData,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 48.0,
          minWidth: 168.0,
        ),
        child: ActionButton(
          text: text,
          onPressed: onPressed,
          enabled: onPressed != null ?? true,
          fill: true,
          variant: Variant.fab,
          isRestoreFlow: isRestoreFlow,
        ),
      ),
    );
  }
}
