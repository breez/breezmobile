import 'dart:async';
import 'package:flutter/material.dart';
import 'package:breez/bloc/app_blocs.dart';
import 'package:breez/bloc/bloc_widget_connector.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/pos/transactions/pos_payments_list.dart';
import 'package:breez/widgets/calendar_dialog.dart';
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/theme_data.dart' as theme;

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

  @override
  void initState() {
    super.initState();
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
              return StreamBuilder<PaymentsModel>(
                  stream: widget._accountBloc.paymentsStream,
                  builder: (context, snapshot) {
                    PaymentsModel paymentsModel;
                    if (snapshot.hasData) {
                      paymentsModel = snapshot.data;
                    }

                    if(account == null || paymentsModel == null){
                      return Container();
                    }

                    if ((account != null && !account.initial) && (paymentsModel != null && paymentsModel.paymentsList.length == 0)) {
                      return _buildScaffold(Center(child: Text("Successful transactions are displayed here.")));
                    }

                    // account and payments are ready, build their widgets
                    return _buildScaffold(_buildTransactions(paymentsModel),_calendarButton(paymentsModel));
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

  Widget _calendarButton(PaymentsModel paymentsModel) {
    return Padding(padding: EdgeInsets.only(right: 16.0), child:
    IconButton(icon: ImageIcon(AssetImage("src/icon/calendar.png"), color: Colors.white, size: 24.0),
        onPressed: () =>
            showDialog(
                context: context,
                builder: (_) => CalendarDialog(context, paymentsModel.firstDate)).then(((result) =>
                widget._accountBloc.paymentFilterSink.add(
                    paymentsModel.filter.copyWith(startDate: result[0], endDate: result[1]))))));
  }

  Widget _buildTransactions(PaymentsModel paymentsModel) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ((paymentsModel.filter.startDate != null && paymentsModel.filter.endDate != null) &&
            paymentsModel.paymentsList.length == 0) ? Column(mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_buildDateFilterChip(paymentsModel.filter), Center(child: Text("There are no transactions in this date range"),heightFactor: 20.0,),]) :
        CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            (paymentsModel.filter.startDate != null && paymentsModel.filter.endDate != null)
                ? SliverAppBar(
              pinned: true,
              elevation: 0.0,
              expandedHeight: 32.0,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).canvasColor,
              flexibleSpace: _buildDateFilterChip(paymentsModel.filter),
            ) : SliverPadding(padding: EdgeInsets.zero)
            ,
            PosPaymentsList(paymentsModel.paymentsList, PAYMENT_LIST_ITEM_HEIGHT),
          ],
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
              widget._accountBloc.paymentFilterSink.add(PaymentFilterModel(
                  filter.paymentType, null,
                  null)),),)
      ],);
  }

}
