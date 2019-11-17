import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/calendar_dialog.dart';
import 'package:breez/widgets/fixed_sliver_delegate.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

class PaymentFilterSliver extends StatefulWidget {
  final ScrollController _controller;
  final double _minSize;
  final double _maxSize;
  final AccountBloc _accountBloc;
  final PaymentsModel _paymentsModel;

  PaymentFilterSliver(this._controller, this._minSize, this._maxSize, this._accountBloc, this._paymentsModel);

  @override
  State<StatefulWidget> createState() {
    return PaymentFilterSliverState();
  }
}

class PaymentFilterSliverState extends State<PaymentFilterSliver> {
  bool _hasNoFilter;

  @override
  void initState() {
    super.initState();
    widget._controller.addListener(onScroll);
  }

  @override
  void dispose() {
    widget._controller.removeListener(onScroll);
    super.dispose();
  }

  void onScroll(){
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    double scrollOffset = widget._controller.position.pixels;
    _hasNoFilter = (widget._paymentsModel.filter.paymentType.contains(PaymentType.SENT) &&
        widget._paymentsModel.filter.paymentType.contains(PaymentType.DEPOSIT) &&
        widget._paymentsModel.filter.paymentType.contains(PaymentType.WITHDRAWAL) &&
        widget._paymentsModel.filter.paymentType.contains(PaymentType.RECEIVED)) && (widget._paymentsModel.filter.startDate == null || widget._paymentsModel.filter.endDate == null);
    return SliverPersistentHeader(
        pinned: true,
        delegate: new FixedSliverDelegate(!_hasNoFilter ? widget._maxSize : (scrollOffset).clamp(widget._minSize, widget._maxSize),
            builder: (context, shrinkedHeight, overlapContent) {
          return Container(
              decoration: BoxDecoration(color: Theme.of(context).canvasColor),
              height: widget._maxSize,
              child: AnimatedOpacity(
                  duration: Duration(milliseconds: 100),
                  opacity: !_hasNoFilter ? 1.0 : (scrollOffset - widget._maxSize / 2).clamp(0.0, 1.0),
                  child: PaymentsFilter(widget._accountBloc, widget._paymentsModel)));
        }),
      );
  }
}

class PaymentsFilter extends StatefulWidget {
  final AccountBloc _accountBloc;
  final PaymentsModel _paymentsModel;

  PaymentsFilter(this._accountBloc, this._paymentsModel);

  @override
  State<StatefulWidget> createState() {
    return PaymentsFilterState();
  }
}

class PaymentsFilterState extends State<PaymentsFilter> {
  String _filter;

  @override
  void initState() {
    super.initState();
    _filter = "All Activities";
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [_buildExportButton(context),_buildCalendarButton(context), _buildFilterDropdown(context)]);
  }

  Padding _buildCalendarButton(BuildContext context) {
    return new Padding(
      padding: EdgeInsets.only(left: 0.0, right: 0.0),
      child: IconButton(
        icon: ImageIcon(
          AssetImage("src/icon/calendar.png"),
          color: Colors.white,
          size: 24.0,
        ),
        onPressed: () => widget._paymentsModel.firstDate != null
            ? showDialog(
                context: context,
                builder: (_) => CalendarDialog(context, widget._paymentsModel.firstDate),
              ).then((result) {
                widget._accountBloc.paymentFilterSink
                    .add(widget._paymentsModel.filter.copyWith(filter: _getFilterType(_filter), startDate: result[0], endDate: result[1]));
              })
            : Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Please wait while Breez is loading transactions."))),
      ),
    );
  }

  Theme _buildFilterDropdown(BuildContext context) {
    return Theme(
      data: theme.themeId == "BLUE" ? Theme.of(context) : Theme.of(context).copyWith(canvasColor: Theme.of(context).backgroundColor),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: new DropdownButton(
              value: _filter,
              style: theme.transactionTitleStyle,
              items: <String>['All Activities', 'Sent', 'Received'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(
                    value,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _filter = value;
                });
                widget._accountBloc.paymentFilterSink.add(widget._paymentsModel.filter.copyWith(filter: _getFilterType(_filter)));
              }),
        ),
      ),
    );
  }

  _getFilterType(String _filter){
    if (_filter == "Sent") {
      return [PaymentType.SENT, PaymentType.WITHDRAWAL];
    } else if (_filter == "Received") {
      return [PaymentType.RECEIVED, PaymentType.DEPOSIT];
    }
    return [PaymentType.RECEIVED, PaymentType.DEPOSIT, PaymentType.SENT, PaymentType.WITHDRAWAL];
  }

  Padding _buildExportButton(BuildContext context) {
    if (widget._paymentsModel.paymentsList.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: PopupMenuButton(
          color: Theme.of(context).backgroundColor,
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).iconTheme.color,
          ),
          padding: EdgeInsets.zero,
          offset: Offset(12, 36),
          onSelected: _select,
          itemBuilder: (context) => [
            PopupMenuItem(
              height: 36,
              value: Choice(() => _exportPayments(context)),
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

  Future _exportPayments(BuildContext context) async {
    var action = ExportPayments();
    widget._accountBloc.userActionsSink.add(action);
    Navigator.of(context).push(createLoaderRoute(context));
    action.future.then((filePath) {
      Navigator.of(context).pop();
      ShareExtend.share(filePath, "file");
    }).catchError((err) {
      Navigator.of(context).pop();
      showFlushbar(context, message: "Failed to export payments.");
    });
  }
}

class Choice {
  const Choice(this.function);

  final Function function;
}
