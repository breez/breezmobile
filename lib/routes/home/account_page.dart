import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/fixed_sliver_delegate.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

import 'payments_filter.dart';
import 'payments_list.dart';
import 'status_text.dart';
import 'wallet_dashboard.dart';

const DASHBOARD_MAX_HEIGHT = 202.25;
const DASHBOARD_MIN_HEIGHT = 70.0;
const FILTER_MAX_SIZE = 64.0;
const FILTER_MIN_SIZE = 0.0;
const PAYMENT_LIST_ITEM_HEIGHT = 72.0;

class AccountPage extends StatefulWidget {
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;

  const AccountPage(
    this.firstPaymentItemKey,
    this.scrollController,
  );

  @override
  State<StatefulWidget> createState() {
    return AccountPageState();
  }
}

class AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  final currencyList = Currency.currencies.map((c) => c.tickerSymbol).toList();

  AccountBloc _accountBloc;
  UserProfileBloc _userProfileBloc;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      //a listener that rebuilds our widget tree when payment filter changes
      _accountBloc.paymentFilterStream.listen((event) {
        widget.scrollController.position
            .restoreOffset(widget.scrollController.offset + 1);
        Future.delayed(const Duration(milliseconds: 150), () => {setState(() {})});
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccountSettings>(
      stream: _accountBloc.accountSettingsStream,
      builder: (settingCtx, settingSnapshot) {
        return StreamBuilder<AccountModel>(
          stream: _accountBloc.accountStream,
          builder: (context, snapshot) {
            AccountModel account = snapshot.data;
            return StreamBuilder<PaymentsModel>(
              stream: _accountBloc.paymentsStream,
              builder: (context, snapshot) {
                final paymentsModel = snapshot.data ?? PaymentsModel.initial();
                return StreamBuilder<BreezUserModel>(
                  stream: _userProfileBloc.userStream,
                  builder: (context, snapshot) {
                    final userModel = snapshot.data;
                    return Container(
                      color: theme.customData[theme.themeId].dashboardBgColor,
                      child: _buildBalanceAndPayments(
                        context,
                        paymentsModel,
                        account,
                        userModel,
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBalanceAndPayments(
    BuildContext context,
    PaymentsModel paymentsModel,
    AccountModel account,
    BreezUserModel userModel,
  ) {
    final lspBloc = AppBlocsProvider.of<LSPBloc>(context);
    final queryData = MediaQuery.of(context);

    final listHeightSpace = queryData.size.height -
        DASHBOARD_MIN_HEIGHT -
        kToolbarHeight -
        FILTER_MAX_SIZE -
        25.0;
    final startDate = paymentsModel?.filter?.startDate;
    final endDate = paymentsModel?.filter?.endDate;
    final dateFilterSpace = startDate != null && endDate != null ? 0.65 : 0.0;
    final payments = paymentsModel.paymentsList;
    final bottomPlaceholderSpace = payments == null || payments.isEmpty
        ? 0.0
        : (listHeightSpace -
                (PAYMENT_LIST_ITEM_HEIGHT + 8) *
                    (payments.length + 1 + dateFilterSpace))
            .clamp(0.0, listHeightSpace);

    String message;
    bool showMessage = account?.syncUIState != SyncUIState.BLOCKING &&
        (account != null && !account.initial);

    List<Widget> slivers = [];
    slivers.add(SliverPersistentHeader(
      floating: false,
      delegate: WalletDashboardHeaderDelegate(_accountBloc, _userProfileBloc),
      pinned: true,
    ));
    if (paymentsModel.nonFilteredItems.isNotEmpty) {
      slivers.add(PaymentFilterSliver(
        widget.scrollController,
        FILTER_MIN_SIZE,
        FILTER_MAX_SIZE,
        _accountBloc,
        paymentsModel,
      ));
    }
    if (startDate != null && endDate != null) {
      slivers.add(SliverPadding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        sliver: SliverPersistentHeader(
          pinned: true,
          delegate: FixedSliverDelegate(
            FILTER_MAX_SIZE / 1.2,
            builder: (context, shrinkedHeight, overlapContent) {
              return Container(
                padding: const EdgeInsets.only(bottom: 8),
                height: FILTER_MAX_SIZE / 1.2,
                color: theme.customData[theme.themeId].dashboardBgColor,
                child: _buildDateFilterChip(context, paymentsModel.filter),
              );
            },
          ),
        ),
      ));
    }

    if (paymentsModel.nonFilteredItems.isNotEmpty) {
      slivers.add(PaymentsList(
        userModel,
        payments,
        PAYMENT_LIST_ITEM_HEIGHT,
        widget.firstPaymentItemKey,
      ));
      slivers.add(SliverPersistentHeader(
        pinned: true,
        delegate: FixedSliverDelegate(
          bottomPlaceholderSpace,
          child: Container(),
        ),
      ));
    } else if (showMessage) {
      slivers.add(SliverPersistentHeader(
        delegate: FixedSliverDelegate(
          250.0,
          builder: (context, shrinkedHeight, overlapContent) {
            return StreamBuilder<LSPStatus>(
              stream: lspBloc.lspStatusStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data.selectionRequired) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 120.0),
                    child: NoLSPWidget(
                      error: snapshot.data.lastConnectionError,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 120.0, 40.0, 0.0),
                  child: StatusText(account, message: message),
                );
              },
            );
          },
        ),
      ));
    }

    return Stack(
      key: const Key("account_sliver"),
      fit: StackFit.expand,
      children: [
        paymentsModel.nonFilteredItems.isEmpty
            ? CustomPaint(painter: BubblePainter(context))
            : const SizedBox(),
        CustomScrollView(
          controller: widget.scrollController,
          slivers: slivers,
        ),
      ],
    );
  }

  Widget _buildDateFilterChip(
    BuildContext context,
    PaymentFilterModel filter,
  ) {
    return (filter.startDate != null && filter.endDate != null)
        ? _filterChip(context, filter)
        : Container();
  }

  Widget _filterChip(
    BuildContext context,
    PaymentFilterModel filter,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: theme.customData[theme.themeId].paymentListBgColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16.0, bottom: 8),
              child: Chip(
                backgroundColor: Theme.of(context).bottomAppBarTheme.color,
                label: Text(BreezDateUtils.formatFilterDateRange(
                  filter.startDate,
                  filter.endDate,
                )),
                onDeleted: () => _accountBloc.paymentFilterSink
                    .add(PaymentFilterModel(filter.paymentType, null, null)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  final BuildContext context;

  const BubblePainter(
    this.context,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final size = MediaQuery.of(context).size;
    final bubblePaint = Paint()
      ..color = theme.themeId == "BLUE"
          ? const Color(0xFF0085fb).withOpacity(0.1)
          : const Color(0xff4D88EC).withOpacity(0.1)
      ..style = PaintingStyle.fill;
    const bubbleRadius = 12.0;
    final height = size.height - kToolbarHeight;
    canvas.drawCircle(
      Offset(size.width / 2, height * 0.36),
      bubbleRadius,
      bubblePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.39, height * 0.59),
      bubbleRadius * 1.5,
      bubblePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, height * 0.71),
      bubbleRadius * 1.25,
      bubblePaint,
    );
    canvas.drawCircle(
      Offset(size.width / 2, height * 0.80),
      bubbleRadius * 0.75,
      bubblePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class WalletDashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final AccountBloc accountBloc;
  final UserProfileBloc _userProfileBloc;

  const WalletDashboardHeaderDelegate(
    this.accountBloc,
    this._userProfileBloc,
  );

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return StreamBuilder<BreezUserModel>(
      stream: _userProfileBloc.userStream,
      builder: (settingCtx, userSnapshot) {
        return StreamBuilder<AccountModel>(
          stream: accountBloc.accountStream,
          builder: (context, snapshot) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                WalletDashboard(
                  userSnapshot.data,
                  snapshot.data,
                  (maxExtent - shrinkOffset).clamp(minExtent, maxExtent),
                  (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0),
                  _userProfileBloc.currencySink.add,
                  _userProfileBloc.fiatConversionSink.add,
                  (hideBalance) => _userProfileBloc.userSink.add(
                    userSnapshot.data.copyWith(hideBalance: hideBalance),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  double get maxExtent => DASHBOARD_MAX_HEIGHT;

  @override
  double get minExtent => DASHBOARD_MIN_HEIGHT;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class NoLSPWidget extends StatelessWidget {
  final String error;

  const NoLSPWidget({
    Key key,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              texts.account_page_activation_provider,
            )
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 24.0,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  side: BorderSide(
                    color: themeData.textTheme.labelLarge.color,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text(
                  texts.account_page_activation_provider_action_select,
                  style: TextStyle(
                    fontSize: 12.3,
                    color: themeData.textTheme.labelLarge.color,
                  ),
                ),
                onPressed: () => Navigator.of(context).pushNamed("/select_lsp"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
