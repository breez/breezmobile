import 'dart:async';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:flutter/material.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/routes/pos/transactions/pos_payments_list.dart';
import 'package:breez/widgets/calendar_dialog.dart';
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/theme_data.dart' as theme;

const PAYMENT_LIST_ITEM_HEIGHT = 72.0;

class PosTransactionsPage extends StatefulWidget {  
  @override
  State<StatefulWidget> createState() {
    return PosTransactionsPageState();
  }
}

class PosTransactionsPageState extends State<PosTransactionsPage> {
  final String _title = "Transactions";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = new ScrollController();

  AccountBloc _accountBloc;
  StreamSubscription<String> _accountActionsSubscription;
  bool _isInit = false;

  @override
  void didChangeDependencies() {        
    if (!_isInit) {
      _accountBloc = AppBlocsProvider.of<AccountBloc>(context);      
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  dispose() {
    _accountActionsSubscription.cancel();
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
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(),
        title: new Text(
          _title,
          style: Theme.of(context).appBarTheme.textTheme.title,
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
                _accountBloc.paymentFilterSink.add(
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
              _accountBloc.paymentFilterSink.add(PaymentFilterModel(
                  filter.paymentType, null,
                  null)),),)
      ],);
  }

}
