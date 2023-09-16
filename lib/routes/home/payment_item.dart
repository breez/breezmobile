import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/routes/charge/sale_view.dart';
import 'package:breez/routes/home/widgets/payments_list/payment_details_dialog.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

import 'flip_transition.dart';
import 'payment_item_avatar.dart';
import 'success_avatar.dart';

const DASHBOARD_MAX_HEIGHT = 202.25;
const DASHBOARD_MIN_HEIGHT = 70.0;
const FILTER_MAX_SIZE = 64.0;
const PAYMENT_LIST_ITEM_HEIGHT = 72.0;
const BOTTOM_PADDING = 8.0;
const AVATAR_DIAMETER = 24.0;

class PaymentItem extends StatefulWidget {
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
  State<PaymentItem> createState() => _PaymentItemState();
}

class _PaymentItemState extends State<PaymentItem> {
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
                  decoration: _createdWithin(const Duration(seconds: 10))
                      ? BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0.5, 0.5),
                              blurRadius: 5.0,
                            ),
                          ],
                        )
                      : null,
                  child: _buildPaymentItemAvatar(),
                ),
                key: widget._firstItem ? widget.firstPaymentItemKey : null,
                title: Transform.translate(
                  offset: const Offset(-8, 0),
                  child: Text(
                    _title(),
                    style: themeData.paymentItemTitleTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: Transform.translate(
                  offset: const Offset(-8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        BreezDateUtils.formatTimelineRelative(
                          DateTime.fromMillisecondsSinceEpoch(
                            widget._paymentInfo.creationTimestamp.toInt() *
                                1000,
                          ),
                        ),
                        style: themeData.paymentItemSubtitleTextStyle,
                      ),
                      _pendingSuffix(),
                    ],
                  ),
                ),
                trailing: SizedBox(
                  height: 44,
                  child: Column(
                    mainAxisAlignment: widget._paymentInfo.fee == 0 ||
                            widget._paymentInfo.pending
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _paymentAmount(),
                      _paymentFee(),
                    ],
                  ),
                ),
                onTap: () => _showDetail(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _title() {
    final info = widget._paymentInfo.lnurlPayInfo;
    if (info != null && info.lightningAddress.isNotEmpty) {
      return info.lightningAddress;
    } else {
      return widget._paymentInfo.title.replaceAll("\n", " ");
    }
  }

  Widget _pendingSuffix() {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return widget._paymentInfo.pending
        ? Text(
            texts.wallet_dashboard_payment_item_balance_pending_suffix,
            style: themeData.paymentItemSubtitleTextStyle.copyWith(
              color: theme.customData[theme.themeId].pendingTextColor,
            ),
          )
        : const SizedBox();
  }

  Widget _paymentAmount() {
    final texts = context.texts();
    final themeData = Theme.of(context);

    final type = widget._paymentInfo.type;
    final negative = type == PaymentType.SENT ||
        type == PaymentType.WITHDRAWAL ||
        type == PaymentType.CLOSED_CHANNEL;
    final amount = widget._paymentInfo.currency.format(
      widget._paymentInfo.amount,
      includeDisplayName: false,
    );

    return Text(
      widget._hideBalance
          ? texts.wallet_dashboard_payment_item_balance_hide
          : negative
              ? texts.wallet_dashboard_payment_item_balance_negative(amount)
              : texts.wallet_dashboard_payment_item_balance_positive(amount),
      style: themeData.paymentItemAmountTextStyle,
    );
  }

  Widget _paymentFee() {
    final texts = context.texts();
    final themeData = Theme.of(context);

    final fee = widget._paymentInfo.fee;
    if (fee == 0 || widget._paymentInfo.pending) return const SizedBox();
    final feeFormatted = widget._paymentInfo.currency.format(
      fee,
      includeDisplayName: false,
    );

    return Text(
      widget._hideBalance
          ? texts.wallet_dashboard_payment_item_balance_hide
          : texts.wallet_dashboard_payment_item_balance_fee(feeFormatted),
      style: themeData.paymentItemSubtitleTextStyle,
    );
  }

  Widget _buildPaymentItemAvatar() {
    // Show Flip Transition if the payment item is created within last 10 seconds
    if (_createdWithin(const Duration(seconds: 10))) {
      return PaymentItemAvatar(widget._paymentInfo, radius: 16);
    } else {
      return FlipTransition(
        PaymentItemAvatar(
          widget._paymentInfo,
          radius: 16,
        ),
        const SuccessAvatar(radius: 16),
        radius: 16,
      );
    }
  }

  bool _createdWithin(Duration duration) {
    final diff = DateTime.fromMillisecondsSinceEpoch(
      widget._paymentInfo.creationTimestamp.toInt() * 1000,
    ).difference(
      DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch,
      ),
    );
    return diff < -duration;
  }

  void _showDetail() {
    final action = FetchSale(paymentHash: widget._paymentInfo.paymentHash);
    PosCatalogBloc posBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
    posBloc.actionsSink.add(action);
    action.future.then((sale) {
      if (sale != null) {
        Navigator.of(context).push(FadeInRoute(
          builder: (context) => SaleView(
            readOnlySale: sale,
            salePayment: widget._paymentInfo,
          ),
        ));
      } else {
        showPaymentDetailsDialog(context, widget._paymentInfo);
      }
    });
  }
}
