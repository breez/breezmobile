import 'package:breez/widgets/designsystem/button/action_button.dart';
import 'package:breez/widgets/designsystem/variant.dart';
import 'package:flutter/material.dart';

class SingleButtonBottomBar extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool stickToBottom;

  const SingleButtonBottomBar({
    this.text,
    this.onPressed,
    this.stickToBottom = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: stickToBottom
            ? MediaQuery.of(context).viewInsets.bottom + 40.0
            : 40.0,
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
            ),
          ),
        ],
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const SubmitButton(
    this.text,
    this.onPressed,
  );

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 48.0,
        minWidth: 168.0,
      ),
      child: ActionButton(
        text:  text,
        onPressed: onPressed,
        enabled: true,
        fill: true,
        variant: Variant.fab,
      ),
    );
  }
}
