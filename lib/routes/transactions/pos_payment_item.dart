import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/routes/charge/sale_view.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/routes/home/widgets/payments_list/payment_details_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class PosPaymentItem extends StatelessWidget {
  final PaymentInfo _paymentInfo;
  final AccountModel _account;
  final SaleSummary _saleSummary;
  final bool _lastItem;

  const PosPaymentItem(
    this._paymentInfo,
    this._account,
    this._saleSummary,
    this._lastItem,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _valueText(context),
                    _fiatText(context),
                  ],
                ),
              ],
            ),
            onTap: () => showSaleView(context),
          ),
        ),
        Divider(
          height: 0.0,
          color: _lastItem
              ? const Color.fromRGBO(255, 255, 255, 0.0)
              : const Color.fromRGBO(255, 255, 255, 0.12),
          indent: 16.0,
        ),
      ],
    );
  }

  Widget _valueText(BuildContext context) {
    final texts = context.texts();
    final isSent = _paymentInfo.type == PaymentType.SENT;
    final isWithdrawal = _paymentInfo.type == PaymentType.WITHDRAWAL;
    final value = _paymentInfo.currency.format(
      _paymentInfo.amount,
      includeDisplayName: false,
    );

    return Text(
      isSent || isWithdrawal
          ? texts.pos_transactions_item_negative(value)
          : texts.pos_transactions_item_positive(value),
      style: isSent
          ? theme.posWithdrawalTransactionAmountStyle
          : theme.transactionAmountStyle,
    );
  }

  Widget _fiatText(BuildContext context) {
    if (_saleSummary == null) return Container();
    final fiat = _saleSummary.fiatCurrencies();
    if (fiat == null || fiat.length != 1) return Container();

    final texts = context.texts();
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        texts.pos_transactions_item_fiat(
          CurrencyWrapper.fromShortName(fiat.first, _account).format(
            _saleSummary.fiatValue,
            includeDisplayName: false,
            includeCurrencySymbol: true,
          ),
        ),
        style: theme.posWithdrawalTransactionAmountStyle.copyWith(
          fontSize: 12.0,
        ),
      ),
    );
  }

  void showSaleView(BuildContext context) {
    var action = FetchSale(paymentHash: _paymentInfo.paymentHash);
    PosCatalogBloc posBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
    posBloc.actionsSink.add(action);
    action.future.then((sale) {
      if (sale != null) {
        Navigator.of(context).push(FadeInRoute(
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
