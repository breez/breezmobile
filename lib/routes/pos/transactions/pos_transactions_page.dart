import 'dart:async';
import 'package:flutter/material.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/pos/transactions/pos_payments_list.dart';
import 'package:breez/widgets/calendar_dialog.dart';
import 'package:breez/widgets/loading_animated_text.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/theme_data.dart' as theme;
import 'dart:io' show Platform;
import 'package:intl/intl.dart';

const PAYMENT_LIST_ITEM_HEIGHT = 72.0;

class PosTransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConnector<AppBlocs>((context, blocs) => new _PosTransactionsPage(blocs.accountBloc));
  }
}

class _PosTransactionsPage extends StatefulWidget {
  final AccountBloc _accountBloc;

  _PosTransactionsPage(this._accountBloc);

  @override
  State<StatefulWidget> createState() {
    return _PosTransactionsState();
  }
}

class _PosTransactionsState extends State<_PosTransactionsPage> {
  final String _title = "Transactions";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = new ScrollController();

  StreamSubscription<String> _accountActionsSubscription;

  DateTime _startDate;
  DateTime _endDate;
  DateTime _firstDate;

  double _sliverPadding = 0.0;

  @override
  void initState() {
    super.initState();
    _startDate = null;
    _endDate = null;
    _accountActionsSubscription = widget._accountBloc.accountActionsStream.listen((data) {}, onError: (e) {
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(duration: new Duration(seconds: 10), content: new Text(e.toString())));
    });
  }

  @override
  dispose() {
    _accountActionsSubscription.cancel();
    super.dispose();
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
                  payments = snapshot.data;
                  if(payments.isNotEmpty){
                    DateTime _firstPaymentDate = DateTime.fromMillisecondsSinceEpoch(payments[payments.length-1].creationTimestamp.toInt() * 1000);
                    _firstDate = new DateTime(_firstPaymentDate.year, _firstPaymentDate.month, _firstPaymentDate.day, 0, 0, 0, 0, 0);
                  }

                }

                if (account == null || payments == null) {
                  return _buildScaffold(Center(child: Loader()));
                }

                if (account.balance == 0 && payments.length == 0) {
                  return _buildScaffold(Center(child: Text("Successful transactions are displayed here."),),
                      Padding(padding: EdgeInsets.only(right: 16.0), child:
                      IconButton(icon: ImageIcon(AssetImage("src/icon/calendar.png"), color: Colors.white, size: 24.0),
                          onPressed: () =>
                              showDialog(barrierDismissible: false, context: context, builder: (_) => CalendarDialog(context, _firstDate, _startDate, _endDate)).then(((result) => setDateFilter(result[0],result[1]))))));
                }

                // account and payments are ready, build their widgets
                return _buildScaffold(_buildTransactions(payments),
                    Padding(padding: EdgeInsets.only(right: 16.0), child:
                    IconButton(icon: ImageIcon(AssetImage("src/icon/calendar.png"), color: Colors.white, size: 24.0),
                        onPressed: () =>
                            showDialog(barrierDismissible: false, context: context, builder: (_) => CalendarDialog(context, _firstDate, _startDate, _endDate)).then((result) => setDateFilter(result[0],result[1])))));
              });
        });
  }

  Widget _buildScaffold(Widget body, [Widget actions]) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        iconTheme: theme.appBarIconTheme,
        textTheme: theme.appBarTextTheme,
        backgroundColor: Color.fromRGBO(5, 93, 235, 1.0),
        leading: backBtn.BackButton(),
        title: new Text(
          _title,
          style: theme.appBarTextStyle,
        ),
        actions: <Widget>[actions == null ? Container() : actions],
        elevation: 0.0,
      ),
      body: body,
    );
  }

  Widget _buildTransactions(List<PaymentInfo> payments) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ((_startDate != null && _endDate != null) && payments.length == 0) ? Center(child: Text("There are no transactions in this date range"),) :
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            new SliverPadding(
              padding: EdgeInsets.symmetric(vertical: _sliverPadding),
              sliver: PosPaymentsList(payments, PAYMENT_LIST_ITEM_HEIGHT),)
          ],
        ),
        _buildDateFilterChip(_startDate, _endDate),
      ],
    );
  }

  _buildDateFilterChip(DateTime startDate,DateTime endDate){
    if(_startDate != null && _endDate != null){
      return Positioned(left: 0.0, top: 0.0, child: Padding(padding: EdgeInsets.only(left: 16.0), child:Chip(label: new Text(_formatFilterDateRange(_startDate, _endDate)),onDeleted: () {setDateFilter(null, null);},),),);
    }
    return Container();
  }

  String _formatFilterDateRange(DateTime startDate,DateTime endDate) {
    var formatter = DateFormat.Md(Platform.localeName);
    if(startDate.year != endDate.year) {
      formatter = new DateFormat.yMd(Platform.localeName);
    }
    String _startDate = formatter.format(startDate);
    String _endDate = formatter.format(endDate);
    return _startDate + "-" + _endDate;
  }

  void setDateFilter(DateTime startDate, DateTime endDate) {
    setState(() {
      _startDate = startDate;
      _endDate = endDate;
      if(startDate == null && endDate == null){
        _sliverPadding = 0.0;
      } else {
        _sliverPadding = 32.0;
      }
      PaymentFilterModel filterData = PaymentFilterModel("All Activities", _firstDate, startDate, endDate);
      widget._accountBloc.paymentFilterSink.add(filterData);
    });
  }

}
