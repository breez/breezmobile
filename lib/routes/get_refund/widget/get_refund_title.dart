import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

class GetRefundTitle extends StatelessWidget {
  final Currency currency;
  final Int64 amount;

  const GetRefundTitle({
    @required this.currency,
    @required this.amount,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Text(
            texts.get_refund_amount(
              currency.format(amount),
            ),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );
  }
}
