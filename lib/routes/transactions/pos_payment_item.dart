import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/routes/charge/sale_view.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/payment_details_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

class PosPaymentItem extends StatelessWidget {
  final PaymentInfo _paymentInfo;
  final bool _lastItem;

  PosPaymentItem(this._paymentInfo, this._lastItem);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: ListTile(
          title: Text(
            DateUtils.formatYearMonthDayHourMinute(
                DateTime.fromMillisecondsSinceEpoch(
                    _paymentInfo.creationTimestamp.toInt() * 1000)),
            style: _paymentInfo.type == PaymentType.SENT
                ? theme.posWithdrawalTransactionTitleStyle
                : theme.posTransactionTitleStyle,
          ),
          trailing: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    (_paymentInfo.type == PaymentType.SENT ||
                                _paymentInfo.type == PaymentType.WITHDRAWAL
                            ? "- "
                            : "") +
                        _paymentInfo.currency.format(_paymentInfo.amount,
                            includeDisplayName: false),
                    style: _paymentInfo.type == PaymentType.SENT
                        ? theme.posWithdrawalTransactionAmountStyle
                        : theme.transactionAmountStyle),
              ]),
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
    ]);
  }

  showSaleView(BuildContext context) {
    var action = FetchSale(paymentHash: _paymentInfo.paymentHash);
    PosCatalogBloc posBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
    posBloc.actionsSink.add(action);
    action.future.then((sale) {
      if (sale != null) {
        Navigator.of(context).push(FadeInRoute(
          builder: (context) => SaleView(
              useFiat: false,
              readOnlySale: sale as Sale,
              salePayment: _paymentInfo),
        ));
      } else {
        showPaymentDetailsDialog(context, _paymentInfo);
      }
    });
  }
}
