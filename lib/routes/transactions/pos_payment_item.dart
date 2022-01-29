import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/routes/charge/sale_view.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/payment_details_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

class PosPaymentItem extends StatelessWidget {
  final PaymentInfo _paymentInfo;
  final bool _lastItem;

  PosPaymentItem(
    this._paymentInfo,
    this._lastItem,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: ListTile(
            title: Text(
              BreezDateUtils.formatYearMonthDayHourMinute(
                DateTime.fromMillisecondsSinceEpoch(
                  _paymentInfo.creationTimestamp.toInt() * 1000,
                ),
              ),
              style: _paymentInfo.type == PaymentType.SENT
                  ? theme.posWithdrawalTransactionTitleStyle
                  : theme.posTransactionTitleStyle,
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _valueText(context),
              ],
            ),
            onTap: () => showSaleView(context),
          ),
        ),
        Divider(
          height: 0.0,
          color: _lastItem
              ? Color.fromRGBO(255, 255, 255, 0.0)
              : Color.fromRGBO(255, 255, 255, 0.12),
          indent: 16.0,
        ),
      ],
    );
  }

  Widget _valueText(BuildContext context) {
    var l10n = context.l10n;

    final isSent = _paymentInfo.type == PaymentType.SENT;
    final isWithdrawal = _paymentInfo.type == PaymentType.WITHDRAWAL;
    final value = _paymentInfo.currency.format(
      _paymentInfo.amount,
      includeDisplayName: false,
    );

    return Text(
      isSent || isWithdrawal
          ? l10n.pos_transactions_item_negative(value)
          : l10n.pos_transactions_item_positive(value),
      style: isSent
          ? theme.posWithdrawalTransactionAmountStyle
          : theme.transactionAmountStyle,
    );
  }

  void showSaleView(BuildContext context) {
    var action = FetchSale(paymentHash: _paymentInfo.paymentHash);
    PosCatalogBloc posBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
    posBloc.actionsSink.add(action);
    action.future.then((sale) {
      if (sale != null) {
        context.push(FadeInRoute(
          builder: (context) => SaleView(
            readOnlySale: sale as Sale,
            salePayment: _paymentInfo,
          ),
        ));
      } else {
        showPaymentDetailsDialog(context, _paymentInfo);
      }
    });
  }
}
