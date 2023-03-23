import 'package:breez/widgets/designsystem/button/action_button.dart';
import 'package:breez/widgets/designsystem/variant.dart';
import 'package:breez/widgets/preview/preview.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GetRefundAction extends StatelessWidget {
  final String refundTxId;
  final bool allowRebroadcastRefunds;
  final VoidCallback onActionPressed;

  const GetRefundAction({
    @required this.refundTxId,
    @required this.allowRebroadcastRefunds,
    @required this.onActionPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 36,
              minWidth: 145,
            ),
            child: ActionButton(
              text: refundTxId.isNotEmpty
                  ? texts.get_refund_action_broadcasted
                  : texts.get_refund_action_continue,
              onPressed: onActionPressed,
              enabled: refundTxId.isEmpty && allowRebroadcastRefunds,
              fill: true,
              variant: Variant.secondary,
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(Preview([
    GetRefundAction(
      refundTxId: '',
      allowRebroadcastRefunds: true,
      onActionPressed: () {
        if (kDebugMode) {
          print('onActionPressed');
        }
      },
    ),
    GetRefundAction(
      refundTxId: '123',
      allowRebroadcastRefunds: true,
      onActionPressed: () {
        if (kDebugMode) {
          print('onActionPressed');
        }
      },
    ),
    GetRefundAction(
      refundTxId: '123',
      allowRebroadcastRefunds: false,
      onActionPressed: () {
        if (kDebugMode) {
          print('onActionPressed');
        }
      },
    ),
  ]));
}
