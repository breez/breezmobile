import 'dart:async';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/invoice/invoice_bloc.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/user/home/floating_actions_bar.dart';
import 'package:breez/routes/user/home/invoice_bottom_sheet.dart';
import 'package:breez/routes/user/home/payments_filter.dart';
import 'package:breez/routes/user/home/payments_list.dart';
import 'package:breez/routes/user/home/wallet_dashboard.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:breez/widgets/fixed_sliver_delegate.dart';
import 'package:breez/widgets/scroll_watcher.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/user/home/status_text.dart';
import 'package:breez/utils/date.dart';

const DASHBOARD_MAX_HEIGHT = 188.0;
const DASHBOARD_MIN_HEIGHT = 70.0;
const FILTER_MAX_SIZE = 70.0;
const FILTER_MIN_SIZE = 30.0;
const PAYMENT_LIST_ITEM_HEIGHT = 72.0;

class AccountPage extends StatefulWidget {
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;

  AccountPage(this.firstPaymentItemKey, this.scrollController);

  @override
  State<StatefulWidget> createState() {
    return new AccountPageState();
  }
}

class AccountPageState extends State<AccountPage> with SingleTickerProviderStateMixin{
  final List<String> currencyList = Currency.currencies.map((c) => c.symbol).toList();

  AccountBloc _accountBloc;
  UserProfileBloc _userProfileBloc;  
  ConnectPayBloc _connectPayBloc;
  InvoiceBloc _invoiceBloc;

  StreamSubscription<String> _accountActionsSubscription;
  StreamSubscription<bool> _paidInvoicesSubscription;
  bool _isInit = false;  

  @override
  void didChangeDependencies() {          
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      _connectPayBloc = AppBlocsProvider.of<ConnectPayBloc>(context);
      _invoiceBloc = AppBlocsProvider.of<InvoiceBloc>(context);
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  dispose() {
    _accountActionsSubscription.cancel();
    _paidInvoicesSubscription.cancel();
    super.dispose();
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
                      PaymentsModel paymentsModel = snapshot.data ?? PaymentsModel.initial();
                      return StreamBuilder<String>(
                        stream: _connectPayBloc.pendingCTPLinkStream,
                        builder: (ctx, ctpSnapshot){
                          //account and payments are ready, build their widgets
                          return _buildBalanceAndPayments(paymentsModel, account, ctpSnapshot.data);  
                        }
                      );                      
                    });
              });
        });
  }

  Widget _buildBalanceAndPayments(PaymentsModel paymentsModel, AccountModel account, String pendingCTPLink) {
    double listHeightSpace = MediaQuery.of(context).size.height - DASHBOARD_MIN_HEIGHT - kToolbarHeight - FILTER_MAX_SIZE - 25.0;
    double bottomPlaceholderSpace = paymentsModel.paymentsList == null || paymentsModel.paymentsList.length == 0 ? 0.0 : (listHeightSpace - PAYMENT_LIST_ITEM_HEIGHT * paymentsModel.paymentsList.length).clamp(0.0, listHeightSpace);

    String message;    
    bool showMessage = account?.syncUIState != SyncUIState.BLOCKING && (account != null && !account.initial || account?.isInitialBootstrap == true);
    if (pendingCTPLink != null) {
      message =
      "You will be able to receive payments after Breez is finished opening a secured channel with our server. This usually takes ~10 minutes to be completed";
      showMessage = true;
    }    

    List<Widget> slivers = new List<Widget>();
    slivers.add(SliverPersistentHeader(floating: false, delegate: WalletDashboardHeaderDelegate(_accountBloc, _userProfileBloc), pinned: true));
    if (paymentsModel.nonFilteredItems.length > 0) {
      slivers.add(PaymentFilterSliver(widget.scrollController, FILTER_MIN_SIZE, FILTER_MAX_SIZE, _accountBloc, paymentsModel));
    }
    if (paymentsModel?.filter?.startDate != null && paymentsModel?.filter?.endDate != null) {
      slivers.add(SliverAppBar(
        pinned: true,
        elevation: 0.0,
        expandedHeight: 32.0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).canvasColor,
        flexibleSpace: _buildDateFilterChip(paymentsModel.filter),
      ));
    }

    if (paymentsModel.nonFilteredItems.length > 0) {
      slivers.add(PaymentsList(paymentsModel.paymentsList, PAYMENT_LIST_ITEM_HEIGHT, widget.firstPaymentItemKey));
      slivers.add(SliverPersistentHeader(pinned: true, delegate: new FixedSliverDelegate(
        bottomPlaceholderSpace,
        child: Container()
      )));
    } else if (showMessage) {
      slivers.add(SliverPersistentHeader(              
        delegate: new FixedSliverDelegate(250.0,
            builder: (context, shrinkedHeight, overlapContent) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 130.0, left: 40.0, right: 40.0),
              child: StatusText(account, message: message),
            ),
          );
        }),
      ));
    }

    return Stack(
        key: Key("account_sliver"),
        fit: StackFit.expand,
        children: [          
          paymentsModel.nonFilteredItems.length == 0 ? new Image.asset(
            "src/images/waves-home.png",
            fit: BoxFit.contain,
            width: double.infinity,
            alignment: Alignment.bottomCenter,
          ) : SizedBox(),
          CustomScrollView(
            controller: widget.scrollController,
            slivers: slivers          
          ),
          //Floating actions
          ScrollWatcher(
            controller: widget.scrollController,
            builder: (context, offset) {
              double height = (DASHBOARD_MAX_HEIGHT - offset).clamp(DASHBOARD_MIN_HEIGHT, DASHBOARD_MAX_HEIGHT);
              double heightFactor = (offset / (DASHBOARD_MAX_HEIGHT - DASHBOARD_MIN_HEIGHT)).clamp(0.0, 1.0);
              return account != null && !account.initial ? FloatingActionsBar(account, height, heightFactor) : Positioned(top: 0.0, child: SizedBox());
            },
          ),
          ScrollWatcher(
            controller: widget.scrollController,
            builder: (context, offset) {
              double height = (DASHBOARD_MAX_HEIGHT - offset).clamp(DASHBOARD_MIN_HEIGHT, DASHBOARD_MAX_HEIGHT);
              return (account?.connected ?? false) ? InvoiceBottomSheet(_invoiceBloc, height < 160.0) : Positioned(top: 0.0, child: SizedBox());
            },
          ),
        ],
      );
  }

  _buildDateFilterChip(PaymentFilterModel filter) {
    return (filter.startDate != null && filter.endDate != null) ?
    _filterChip(filter) : Container();
  }

  Widget _filterChip(PaymentFilterModel filter) {
    return Row(mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[Padding(padding: EdgeInsets.only(left: 16.0),
      child: Chip(label: new Text(DateUtils.formatFilterDateRange(filter.startDate, filter.endDate)),
        onDeleted: () =>
            _accountBloc.paymentFilterSink.add(PaymentFilterModel(filter.paymentType, null,
                null)),),)],);
  }
}

class WalletDashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final AccountBloc accountBloc;
  final UserProfileBloc _userProfileBloc;  

  WalletDashboardHeaderDelegate(this.accountBloc, this._userProfileBloc);
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return StreamBuilder<AccountSettings>(
      stream: accountBloc.accountSettingsStream,
      builder: (settingCtx, settingSnapshot) {
        return StreamBuilder<AccountModel>(
          stream: accountBloc.accountStream,
          builder: (context, snapshot) {
            double height = (maxExtent - shrinkOffset).clamp(minExtent, maxExtent);
            double heightFactor = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

            return Stack(overflow: Overflow.visible, children: <Widget>[
              WalletDashboard(settingSnapshot.data, snapshot.data, height, heightFactor, _userProfileBloc.currencySink.add)
            ]);
          });
      }
    );    
  }

  @override
  double get maxExtent => DASHBOARD_MAX_HEIGHT;

  @override
  double get minExtent => DASHBOARD_MIN_HEIGHT;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
