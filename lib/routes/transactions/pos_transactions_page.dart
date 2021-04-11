import 'dart:async';

import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/calendar_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:share_extend/share_extend.dart';

import 'pos_payments_list.dart';

const PAYMENT_LIST_ITEM_HEIGHT = 72.0;

class PosTransactionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PosTransactionsPageState();
  }
}

class PosTransactionsPageState extends State<PosTransactionsPage> {
  final String _title = "transactions";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  AccountBloc _accountBloc;
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

                if (account == null || paymentsModel == null) {
                  return Container();
                }

                if ((account != null && !account.initial) &&
                    (paymentsModel != null &&
                        paymentsModel.paymentsList.length == 0 &&
                        paymentsModel.filter == PaymentFilterModel.initial())) {
                  return _buildScaffold(Center(
                      child:
                          Text("Successful transactions are displayed here.")));
                }

                // account and payments are ready, build their widgets
                return _buildScaffold(_buildTransactions(paymentsModel), [
                  _calendarButton(paymentsModel),
                  _exportButton(paymentsModel, context)
                ]);
              });
        });
  }

  Widget _buildScaffold(Widget body, [List<Widget> actions]) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        leading: backBtn.BackButton(),
        title: Text(
          FlutterI18n.translate(context, _title),
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        actions: actions == null ? <Widget>[] : actions,
        elevation: 0.0,
      ),
      body: body,
    );
  }

  Widget _calendarButton(PaymentsModel paymentsModel) {
    return IconButton(
        icon: ImageIcon(AssetImage("src/icon/calendar.png"),
            color: Colors.white, size: 24.0),
        onPressed: () => showDialog(
            useRootNavigator: false,
            context: context,
            builder: (_) =>
                CalendarDialog(context, paymentsModel.firstDate)).then(
            ((result) => _accountBloc.paymentFilterSink.add(paymentsModel.filter
                .copyWith(startDate: result[0], endDate: result[1])))));
  }

  Padding _exportButton(PaymentsModel paymentsModel, BuildContext context) {
    if (paymentsModel.paymentsList.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: PopupMenuButton(
          color: Theme.of(context).backgroundColor,
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).iconTheme.color,
          ),
          padding: EdgeInsets.zero,
          offset: Offset(0, 48),
          onSelected: _select,
          itemBuilder: (context) => [
            PopupMenuItem(
              height: 36,
              value: Choice(() => _exportTransactions(context)),
              child: Text('Export', style: Theme.of(context).textTheme.button),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: IconButton(
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).disabledColor,
          size: 24.0,
        ),
      ),
    );
  }

  void _select(Choice choice) {
    choice.function();
  }

  Future _exportTransactions(BuildContext context) async {
    var action = ExportPayments();
    _accountBloc.userActionsSink.add(action);
    Navigator.of(context).push(createLoaderRoute(context));
    action.future.then((filePath) {
      Navigator.of(context).pop();
      ShareExtend.share(filePath, "file");
    }).catchError((err) {
      Navigator.of(context).pop();
      showFlushbar(context, message: "Failed to export payments.");
    });
  }

  Widget _buildTransactions(PaymentsModel paymentsModel) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ((paymentsModel.filter.startDate != null &&
                    paymentsModel.filter.endDate != null) &&
                paymentsModel.paymentsList.length == 0)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    _buildDateFilterChip(paymentsModel.filter),
                    Expanded(
                        child: Center(
                      child:
                          Text("There are no transactions in this date range"),
                    )),
                  ])
            : CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  (paymentsModel.filter.startDate != null &&
                          paymentsModel.filter.endDate != null)
                      ? SliverAppBar(
                          pinned: true,
                          elevation: 0.0,
                          expandedHeight: 32.0,
                          automaticallyImplyLeading: false,
                          backgroundColor: Theme.of(context).canvasColor,
                          flexibleSpace:
                              _buildDateFilterChip(paymentsModel.filter),
                        )
                      : SliverPadding(padding: EdgeInsets.zero),
                  PosPaymentsList(
                      paymentsModel.paymentsList, PAYMENT_LIST_ITEM_HEIGHT),
                ],
              ),
      ],
    );
  }

  _buildDateFilterChip(PaymentFilterModel filter) {
    return (filter.startDate != null && filter.endDate != null)
        ? _filterChip(filter)
        : Container();
  }

  Widget _filterChip(PaymentFilterModel filter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Chip(
            label: Text(BreezDateUtils.formatFilterDateRange(
                filter.startDate, filter.endDate)),
            onDeleted: () => _accountBloc.paymentFilterSink
                .add(PaymentFilterModel(filter.paymentType, null, null)),
          ),
        )
      ],
    );
  }
}

class Choice {
  const Choice(this.function);

  final Function function;
}
