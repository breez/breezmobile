import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/routes/charge/sale_view.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/payment_details_dialog.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'flip_transition.dart';
import 'payment_item_avatar.dart';
import 'success_avatar.dart';

const DASHBOARD_MAX_HEIGHT = 202.25;
const DASHBOARD_MIN_HEIGHT = 70.0;
const FILTER_MAX_SIZE = 64.0;
const PAYMENT_LIST_ITEM_HEIGHT = 72.0;
const BOTTOM_PADDING = 8.0;
const AVATAR_DIAMETER = 24.0;

class PaymentItem extends StatelessWidget {
  final PaymentInfo _paymentInfo;
  final bool _firstItem;
  final bool _hideBalance;
  final GlobalKey firstPaymentItemKey;

  const PaymentItem(
    this._paymentInfo,
    this._firstItem,
    this._hideBalance,
    this.firstPaymentItemKey,
  );

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: BOTTOM_PADDING, left: 8, right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: theme.customData[theme.themeId].paymentListBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                leading: Container(
                  height: PAYMENT_LIST_ITEM_HEIGHT,
                  decoration: _createdWithin(Duration(seconds: 10))
                      ? BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0.5, 0.5),
                              blurRadius: 5.0,
                            ),
                          ],
                        )
                      : null,
                  child: _buildPaymentItemAvatar(),
                ),
                key: _firstItem ? firstPaymentItemKey : null,
                title: Transform.translate(
                  offset: Offset(-8, 0),
                  child: Text(
                    _title(context),
                    style: themeData.accentTextTheme.subtitle2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: Transform.translate(
                  offset: Offset(-8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        BreezDateUtils.formatTimelineRelative(
                          DateTime.fromMillisecondsSinceEpoch(
                            _paymentInfo.creationTimestamp.toInt() * 1000,
                          ),
                        ),
                        style: themeData.accentTextTheme.caption,
                      ),
                      _pendingSuffix(context),
                    ],
                  ),
                ),
                trailing: Container(
                  height: 44,
                  child: Column(
                    mainAxisAlignment:
                        _paymentInfo.fee == 0 || _paymentInfo.pending
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _paymentAmount(context),
                      _paymentFee(context),
                    ],
                  ),
                ),
                onTap: () => _showDetail(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _title(BuildContext context) {
    final info = _paymentInfo.lnurlPayInfo;
    if (info != null && info.lightningAddress.isNotEmpty) {
      return info.lightningAddress;
    } else {
      return _paymentInfo.title.replaceAll("\n", " ");
    }
  }

  Widget _pendingSuffix(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return _paymentInfo.pending
        ? Text(
            texts.wallet_dashboard_payment_item_balance_pending_suffix,
            style: themeData.accentTextTheme.caption.copyWith(
              color: theme.customData[theme.themeId].pendingTextColor,
            ),
          )
        : SizedBox();
  }

  Widget _paymentAmount(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    final type = _paymentInfo.type;
    final negative = type == PaymentType.SENT ||
        type == PaymentType.WITHDRAWAL ||
        type == PaymentType.CLOSED_CHANNEL;
    final amount = _paymentInfo.currency.format(
      _paymentInfo.amount,
      includeDisplayName: false,
    );

    return Text(
      _hideBalance
          ? texts.wallet_dashboard_payment_item_balance_hide
          : negative
              ? texts.wallet_dashboard_payment_item_balance_negative(amount)
              : texts.wallet_dashboard_payment_item_balance_positive(amount),
      style: themeData.accentTextTheme.headline6,
    );
  }

  Widget _paymentFee(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    final fee = _paymentInfo.fee;
    if (fee == 0 || _paymentInfo.pending) return SizedBox();
    final feeFormatted = _paymentInfo.currency.format(
      fee,
      includeDisplayName: false,
    );

    return Text(
      _hideBalance
          ? texts.wallet_dashboard_payment_item_balance_hide
          : texts.wallet_dashboard_payment_item_balance_fee(feeFormatted),
      style: themeData.accentTextTheme.caption,
    );
  }

  Widget _buildPaymentItemAvatar() {
    // Show Flip Transition if the payment item is created within last 10 seconds
    if (_createdWithin(Duration(seconds: 10))) {
      return PaymentItemAvatar(_paymentInfo, radius: 16);
    } else {
      return FlipTransition(
        PaymentItemAvatar(
          _paymentInfo,
          radius: 16,
        ),
        SuccessAvatar(radius: 16),
        radius: 16,
      );
    }
  }

  bool _createdWithin(Duration duration) {
    final diff = DateTime.fromMillisecondsSinceEpoch(
      _paymentInfo.creationTimestamp.toInt() * 1000,
    ).difference(
      DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch,
      ),
    );
    return diff < -duration;
  }

  void _showDetail(BuildContext context) {
    final action = FetchSale(paymentHash: _paymentInfo.paymentHash);
    PosCatalogBloc posBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
    posBloc.actionsSink.add(action);
    action.future.then((sale) {
      if (sale != null) {
        Navigator.of(context).push(FadeInRoute(
          builder: (context) => SaleView(
            readOnlySale: sale,
            salePayment: _paymentInfo,
          ),
        ));
      } else {
        showPaymentDetailsDialog(context, _paymentInfo);
      }
    });
  }
}
