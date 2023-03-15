import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/calendar_dialog.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/pos_report_dialog.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import 'pos_payments_list.dart';

const PAYMENT_LIST_ITEM_HEIGHT = 72.0;

class PosTransactionsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PosTransactionsPageState();
  }
}

class PosTransactionsPageState extends State<PosTransactionsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();

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
    final texts = context.texts();

    return StreamBuilder<AccountModel>(
      stream: _accountBloc.accountStream,
      builder: (context, snapshot) {
        final account = snapshot.data;

        return StreamBuilder<PaymentsModel>(
          stream: _accountBloc.paymentsStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            final paymentsModel = snapshot.data;

            if (account == null || paymentsModel == null) return Container();

            if ((account != null && !account.initial) &&
                (paymentsModel != null &&
                    paymentsModel.paymentsList.isEmpty &&
                    paymentsModel.filter == PaymentFilterModel.initial())) {
              return _buildScaffold(
                context,
                Center(
                  child: Text(texts.pos_transactions_placeholder),
                ),
              );
            }

            return _buildScaffold(
              context,
              _buildTransactions(context, paymentsModel, account),
              [
                _reportButton(context),
                _calendarButton(paymentsModel),
                _exportButton(context, paymentsModel),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    Widget body, [
    List<Widget> actions,
  ]) {
    final texts = context.texts();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const backBtn.BackButton(),
        title: Text(texts.pos_transactions_title),
        actions: actions ?? [],
      ),
      body: body,
    );
  }

  Widget _reportButton(
    BuildContext context,
  ) {
    final themeData = Theme.of(context);
    return IconButton(
      icon: SvgPicture.asset(
        "src/icon/pos_report.svg",
        colorFilter: ColorFilter.mode(
          themeData.iconTheme.color,
          BlendMode.srcATop,
        ),
        width: 24.0,
        height: 24.0,
      ),
      onPressed: () => showDialog(
        useRootNavigator: false,
        context: context,
        builder: (_) => const PosReportDialog(),
      ),
    );
  }

  Widget _calendarButton(PaymentsModel paymentsModel) {
    final themeData = Theme.of(context);
    return IconButton(
      icon: SvgPicture.asset(
        "src/icon/calendar.svg",
        colorFilter: ColorFilter.mode(
          themeData.iconTheme.color,
          BlendMode.srcATop,
        ),
        width: 24.0,
        height: 24.0,
      ),
      onPressed: () => showDialog(
        useRootNavigator: false,
        context: context,
        builder: (_) => CalendarDialog(paymentsModel.firstDate),
      ).then(
        (result) => _accountBloc.paymentFilterSink.add(
          paymentsModel.filter.copyWith(
            startDate: result[0],
            endDate: result[1],
          ),
        ),
      ),
    );
  }

  Widget _exportButton(
    BuildContext context,
    PaymentsModel paymentsModel,
  ) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    if (paymentsModel.paymentsList.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: PopupMenuButton(
          color: themeData.colorScheme.background,
          icon: Icon(
            Icons.more_vert,
            color: themeData.iconTheme.color,
          ),
          padding: EdgeInsets.zero,
          offset: const Offset(0, 48),
          onSelected: _select,
          itemBuilder: (context) => [
            PopupMenuItem(
              height: 36,
              value: Choice(() => _exportTransactions(context)),
              child: Text(
                texts.pos_transactions_action_export,
                style: themeData.textTheme.labelLarge,
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.more_vert,
          color: themeData.disabledColor,
          size: 24.0,
        ),
      ),
    );
  }

  void _select(Choice choice) {
    choice.function();
  }

  _exportTransactions(BuildContext context) {
    final texts = context.texts();
    final navigator = Navigator.of(context);
    var action = ExportPayments();
    _accountBloc.userActionsSink.add(action);
    var loaderRoute = createLoaderRoute(context);
    navigator.push(loaderRoute);
    action.future.then((filePath) {
      if (loaderRoute.isActive) {
        navigator.removeRoute(loaderRoute);
      }
      Share.shareXFiles([XFile(filePath)]);
    }).catchError((err) {
      if (loaderRoute.isActive) {
        navigator.removeRoute(loaderRoute);
      }
      showFlushbar(
        context,
        message: texts.pos_transactions_action_export_failed,
      );
    });
  }

  Widget _buildTransactions(
    BuildContext context,
    PaymentsModel paymentsModel,
    AccountModel accountModel,
  ) {
    final texts = context.texts();
    final filter = paymentsModel.filter;
    final payments = paymentsModel.paymentsList;
    final hasDateRange = filter.startDate != null && filter.endDate != null;

    return Stack(
      fit: StackFit.expand,
      children: [
        (hasDateRange && payments.isEmpty)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildDateFilterChip(filter),
                  Expanded(
                    child: Center(
                      child: Text(
                        texts.pos_transactions_range_no_transactions,
                      ),
                    ),
                  ),
                ],
              )
            : CustomScrollView(
                controller: _scrollController,
                slivers: [
                  hasDateRange
                      ? SliverAppBar(
                          pinned: true,
                          expandedHeight: 32.0,
                          automaticallyImplyLeading: false,
                          flexibleSpace: _buildDateFilterChip(filter),
                        )
                      : const SliverPadding(
                          padding: EdgeInsets.zero,
                        ),
                  PosPaymentsList(
                    payments,
                    accountModel,
                    PAYMENT_LIST_ITEM_HEIGHT,
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildDateFilterChip(PaymentFilterModel filter) {
    return (filter.startDate != null && filter.endDate != null)
        ? _filterChip(filter)
        : Container();
  }

  Widget _filterChip(PaymentFilterModel filter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Chip(
            label: Text(
              BreezDateUtils.formatFilterDateRange(
                filter.startDate,
                filter.endDate,
              ),
            ),
            onDeleted: () => _accountBloc.paymentFilterSink.add(
              PaymentFilterModel(
                filter.paymentType,
                null,
                null,
              ),
            ),
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
