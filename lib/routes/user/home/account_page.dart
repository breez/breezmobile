import 'dart:async';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/user/home/floating_actions_bar.dart';
import 'package:breez/routes/user/home/payments_filter.dart';
import 'package:breez/routes/user/home/payments_list.dart';
import 'package:breez/routes/user/home/wallet_dashboard.dart';
import 'package:breez/widgets/fixed_sliver_delegate.dart';
import 'package:breez/widgets/scroll_watcher.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/user/home/status_text.dart';
import 'package:fixnum/fixnum.dart';
import 'package:breez/utils/date.dart';

const DASHBOARD_MAX_HEIGHT = 188.0;
const DASHBOARD_MIN_HEIGHT = 70.0;
const FILTER_MAX_SIZE = 70.0;
const FILTER_MIN_SIZE = 30.0;
const PAYMENT_LIST_ITEM_HEIGHT = 72.0;

class AccountPage extends StatefulWidget {
  
  AccountPage();

  @override
  State<StatefulWidget> createState() {
    return new AccountPageState();
  }
}

class AccountPageState extends State<AccountPage> {
  final ScrollController _scrollController = new ScrollController();
  final List<String> currencyList = Currency.currencies.map((c) => c.symbol).toList();

  AccountBloc _accountBloc;
  UserProfileBloc _userProfileBloc;  
  ConnectPayBloc _connectPayBloc;

  StreamSubscription<String> _accountActionsSubscription;
  StreamSubscription<AccountModel> _statusSubscription;
  String _paymentRequestInProgress;
  bool _isInit = false;

  @override
  void didChangeDependencies() {          
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);
      _userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      _connectPayBloc = AppBlocsProvider.of<ConnectPayBloc>(context);
      registerPaymentInProgress();      
    }
    super.didChangeDependencies();
  }

  void registerPaymentInProgress(){    
    _statusSubscription =_accountBloc.accountStream.listen((acc) {
      if (acc.paymentRequestInProgress != null && acc.paymentRequestInProgress.isNotEmpty && acc.paymentRequestInProgress != _paymentRequestInProgress) {        
        Scaffold.of(context).showSnackBar(new SnackBar(
            duration: new Duration(seconds: 20), content: new Text("Processing Payment...")));
      }
      else if (acc.paymentRequestInProgress == null || acc.paymentRequestInProgress.isEmpty){
        Scaffold.of(context).removeCurrentSnackBar();
      }
      setState(() {
        _paymentRequestInProgress = acc.paymentRequestInProgress;
      });
    });
  }

  @override
  dispose() {
    _accountActionsSubscription.cancel();
    _statusSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    return StreamBuilder<AccountModel>(
        stream: _accountBloc.accountStream,
        builder: (context, snapshot) {
          AccountModel account = snapshot.data;
          return StreamBuilder<PaymentsModel>(
              stream: _accountBloc.paymentsStream,
              builder: (context, snapshot) {                
                PaymentsModel paymentsModel;
                if (snapshot.hasData) {
                  paymentsModel = snapshot.data;
                }

                if(account == null || paymentsModel == null){
                  return Container();
                }

                if ((account != null && !account.initial) && (paymentsModel != null && paymentsModel.paymentsList.length == 0 && paymentsModel.filter.initial)) {
                  //build empty account page
                  return _buildEmptyAccount(account);
                }

                //account and payments are ready, build their widgets
                return _buildBalanceAndPayments(paymentsModel, account);
              });
        });
  }

  Widget _buildEmptyAccount(AccountModel account){
    return Stack(
      fit: StackFit.expand,
      children: [
      Column(
      children: <Widget>[
        Expanded(
            flex: 0,
            child: Container(height: DASHBOARD_MAX_HEIGHT, child: WalletDashboard(account, DASHBOARD_MAX_HEIGHT, 0.0, _userProfileBloc.currencySink.add, _accountBloc.routingNodeConnectionStream))),
        Expanded(flex: 1, child: _buildEmptyHomeScreen(account))
      ],
    ),
    FloatingActionsBar(account, DASHBOARD_MAX_HEIGHT, 0.0)
    ]);
  }

  Widget _buildBalanceAndPayments(PaymentsModel paymentsModel, AccountModel account) {
    double listHeightSpace = MediaQuery.of(context).size.height - DASHBOARD_MIN_HEIGHT - kToolbarHeight - FILTER_MAX_SIZE - 25.0;
    double bottomPlaceholderSpace = paymentsModel.paymentsList == null || paymentsModel.paymentsList.length == 0 ? 0.0 : (listHeightSpace - PAYMENT_LIST_ITEM_HEIGHT * paymentsModel.paymentsList.length).clamp(0.0, listHeightSpace);
    return Stack(
      key: Key("account_sliver"),
      fit: StackFit.expand,
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            //Account dashboard header
            SliverPersistentHeader(floating: false, delegate: WalletDashboardHeaderDelegate(_accountBloc, _userProfileBloc), pinned: true),

            //payment filter
            PaymentFilterSliver(_scrollController, FILTER_MIN_SIZE, FILTER_MAX_SIZE, _accountBloc, paymentsModel),

            (paymentsModel.filter != null && paymentsModel.filter.startDate != null && paymentsModel.filter.endDate != null)
                ? SliverAppBar(
              pinned: true,
              elevation: 0.0,
              expandedHeight: 32.0,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).canvasColor,
              flexibleSpace: _buildDateFilterChip(paymentsModel.filter),
            ) : SliverPadding(padding: EdgeInsets.zero),

            // //List
            PaymentsList(paymentsModel.paymentsList, PAYMENT_LIST_ITEM_HEIGHT),

            //footer
            SliverPersistentHeader(
                pinned: true,
                delegate: new FixedSliverDelegate(
                  bottomPlaceholderSpace,
                  child: Container(),
                ))
          ],
        ),
        //Floating actions
        ScrollWatcher(
          controller: _scrollController,
          builder: (context, offset) {
            double height = (DASHBOARD_MAX_HEIGHT - offset).clamp(DASHBOARD_MIN_HEIGHT, DASHBOARD_MAX_HEIGHT);
            double heightFactor = (offset / (DASHBOARD_MAX_HEIGHT - DASHBOARD_MIN_HEIGHT)).clamp(0.0, 1.0);
            return account != null ? FloatingActionsBar(account, height, heightFactor) : Positioned(top: 0.0, child: SizedBox());
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

  Widget _buildEmptyHomeScreen(AccountModel account) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(top: 130.0, left: 40.0, right: 40.0),
          // new status widget
          child: StreamBuilder(
            stream: _connectPayBloc.pendingCTPLinkStream,
            builder: (context, pendingLinkSnapshot) {
              String message = account.statusMessage;
              if (pendingLinkSnapshot.connectionState == ConnectionState.active && pendingLinkSnapshot.hasData) {
                message = "You will be able to receive payments after Breez is finished opening a secured channel with our server. This usually takes ~10 minutes to be completed";
              }
              return StatusText(message);
            }
          )
        ),
        new Image.asset(
          "src/images/waves-home.png",
          fit: BoxFit.contain,
          width: double.infinity,
          alignment: Alignment.bottomCenter,
        )
      ],
    );
  }
}

class WalletDashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final AccountBloc accountBloc;
  final UserProfileBloc _userProfileBloc;  

  WalletDashboardHeaderDelegate(this.accountBloc, this._userProfileBloc);
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return StreamBuilder<AccountModel>(
        stream: accountBloc.accountStream,
        builder: (context, snapshot) {
          double height = (maxExtent - shrinkOffset).clamp(minExtent, maxExtent);
          double heightFactor = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

          return Stack(overflow: Overflow.visible, children: <Widget>[
            WalletDashboard(snapshot.data, height, heightFactor, _userProfileBloc.currencySink.add, accountBloc.routingNodeConnectionStream)
          ]);
        });
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
