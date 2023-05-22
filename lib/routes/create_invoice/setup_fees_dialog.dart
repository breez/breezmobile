import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class SetupFeesDialog extends StatelessWidget {
  const SetupFeesDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return AlertDialog(
      title: Text(texts.setup_fees_dialog_title),
      content: Text(texts.setup_fees_dialog_message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(texts.error_dialog_default_action_ok),
        )
      ],
    );
  }
}

Future showSetupFeesDialog(
  BuildContext context,
  bool hasFeesChanged,
  Future Function() onNext,
) async {
  if (hasFeesChanged) {
    await showDialog(
      context: context,
      builder: (context) {
        return const SetupFeesDialog();
      },
    );
  }
  return onNext();
}
