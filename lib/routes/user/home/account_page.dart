import 'dart:async';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/user/home/floating_actions_bar.dart';
import 'package:breez/routes/user/home/list_loader.dart';
import 'package:breez/routes/user/home/payments_filter.dart';
import 'package:breez/routes/user/home/payments_list.dart';
import 'package:breez/routes/user/home/wallet_dashboard.dart';
import 'package:breez/widgets/fixed_sliver_delegate.dart';
import 'package:breez/widgets/scroll_watcher.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/bloc/status_indicator/status_indicator_bloc.dart';
import 'package:breez/routes/user/home/status_text.dart';

const DASHBOARD_MAX_HEIGHT = 188.0;
const DASHBOARD_MIN_HEIGHT = 70.0;
const FILTER_MAX_SIZE = 70.0;
const FILTER_MIN_SIZE = 30.0;
const PAYMENT_LIST_ITEM_HEIGHT = 72.0;

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new BlocConnector<AppBlocs>((context, blocs) => new _AccountPage(blocs.accountBloc, blocs.userProfileBloc));
  }
}

class _AccountPage extends StatefulWidget {
  final AccountBloc _accountBloc;
  final UserProfileBloc _userProfileBloc;  

  _AccountPage(this._accountBloc, this._userProfileBloc);

  @override
  State<StatefulWidget> createState() {
    return new _AccountPageState();
  }
}

class _AccountPageState extends State<_AccountPage> {
  final ScrollController _scrollController = new ScrollController();
  final List<String> currencyList = Currency.currencies.map((c) => c.symbol).toList();
  StreamSubscription<String> _accountActionsSubscription;
  StreamSubscription<AccountModel> _statusSubscription;
  String _filter;  
  String _paymentRequestInProgress;

  @override
  void initState() {
    super.initState();
    _filter = 'All Activities';

    _statusSubscription = widget._accountBloc.accountStream.listen((acc) {
      if (acc.paymentRequestInProgress != null && acc.paymentRequestInProgress.isNotEmpty && acc.paymentRequestInProgress != _paymentRequestInProgress) {        
        Scaffold.of(context).showSnackBar(new SnackBar(
            duration: new Duration(seconds: 5), content: new Text("Processing Payment...")));
      }
      else if (acc.paymentRequestInProgress == null || acc.paymentRequestInProgress.isEmpty){
        Scaffold.of(context).removeCurrentSnackBar();
      }
      setState(() {
        _paymentRequestInProgress = acc.paymentRequestInProgress;
      });
    });

    _accountActionsSubscription = widget._accountBloc.accountActionsStream.listen((data) {}, onError: (e) {
      Scaffold.of(context).showSnackBar(new SnackBar(duration: new Duration(seconds: 10), content: new Text(e.toString())));
    });   
  }

  @override
  dispose() {
    _accountActionsSubscription.cancel();
    _statusSubscription.cancel();
    super.dispose();
  }

  void setFilter(String filter) {
    setState(() {
      _filter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccountModel>(
        stream: widget._accountBloc.accountStream,
        builder: (context, snapshot) {
          AccountModel account = snapshot.data;
          return StreamBuilder<List<PaymentInfo>>(
              stream: widget._accountBloc.paymentsStream,
              builder: (context, snapshot) {
                List<PaymentInfo> payments;
                if (snapshot.hasData) {
                  payments = _filterPayments(snapshot.data);
                }

                if (account == null || payments == null) {
                  // build loading page, wating for account to initialize
                  return _buildLoading(ListLoader());
                }

                if (account.balance == 0 && payments.length == 0) {
                  //build empty account page
                  return _buildEmptyAccount(account);
                }

                //account and payments are ready, build their widgets
                return _buildBalanceAndPayments(payments, account);
              });
        });
  }

  Widget _buildLoading(Widget child) {
    return Column(
      children: <Widget>[
        Expanded(
            flex: 0,
            child: Container(height: DASHBOARD_MAX_HEIGHT, child: WalletDashboard(null, DASHBOARD_MAX_HEIGHT, 0.0, widget._userProfileBloc.currencySink.add, widget._accountBloc.routingNodeConnectionStream))),
        Expanded(flex: 1, child: child)
      ],
    );
  }

  Widget _buildEmptyAccount(AccountModel account){
    return Stack(
      fit: StackFit.expand,
      children: [
      Column(
      children: <Widget>[
        Expanded(
            flex: 0,
            child: Container(height: DASHBOARD_MAX_HEIGHT, child: WalletDashboard(account, DASHBOARD_MAX_HEIGHT, 0.0, widget._userProfileBloc.currencySink.add, widget._accountBloc.routingNodeConnectionStream))),
        Expanded(flex: 1, child: _buildEmptyHomeScreen(account))
      ],
    ),
    FloatingActionsBar(account, DASHBOARD_MAX_HEIGHT, 0.0)
    ]);
  }

  Widget _buildBalanceAndPayments(List<PaymentInfo> payments, AccountModel account) {
    double listHeightSpace = MediaQuery.of(context).size.height - DASHBOARD_MIN_HEIGHT - kToolbarHeight - FILTER_MAX_SIZE - 25.0;
    double bottomPlaceholderSpace = payments == null ? 0.0 : (listHeightSpace - PAYMENT_LIST_ITEM_HEIGHT * payments.length).clamp(0.0, listHeightSpace);

    return Stack(
      fit: StackFit.expand,
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            //Account dashboard header
            SliverPersistentHeader(floating: false, delegate: WalletDashboardHeaderDelegate(widget._accountBloc, widget._userProfileBloc), pinned: true),

            //payment filter
            PaymentFilterSliver(_scrollController, _onFilterChanged, FILTER_MIN_SIZE, FILTER_MAX_SIZE, _filter),

            // //List
            PaymentsList(payments, PAYMENT_LIST_ITEM_HEIGHT),

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

  _onFilterChanged(String newFilter) {
    setState(() {
      _filter = newFilter;
    });
  }

  _filterPayments(List<PaymentInfo> payments) {
    if (_filter == "All Activities") {
      return payments;
    }
    if (_filter == "Sent") {
      return payments.where((p) => p.type == PaymentType.WITHDRAWAL || p.type == PaymentType.SENT).toList();
    }
    if (_filter == "Received") {
      return payments.where((p) => p.type == PaymentType.DEPOSIT || p.type == PaymentType.RECEIVED).toList();
    }
    return null;
  }
}

Widget _buildEmptyHomeScreen(AccountModel account) {
  return new Stack(
    fit: StackFit.expand,
    children: <Widget>[
      new Padding(
        padding: EdgeInsets.only(top: 130.0, left: 40.0, right: 40.0),
        // new status widget
        child: new StatusText(account.statusMessage),
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
