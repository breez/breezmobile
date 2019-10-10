import 'package:flutter/material.dart';
import 'package:breez/widgets/fixed_sliver_delegate.dart';
import 'package:breez/widgets/calendar_dialog.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/theme_data.dart' as theme;

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
    List<Widget> children = <Widget>[];
    children.add(
      new Padding(
        padding: EdgeInsets.only(left: 12.0, right: 0.0),
        child: IconButton(
          icon: ImageIcon(
            AssetImage("src/icon/calendar.png"),
            color: Colors.white,
            size: 24.0,
          ),
          onPressed: () =>
          widget._paymentsModel.firstDate != null ?
          showDialog(
            context: context,
            builder: (_) =>
                CalendarDialog(context, widget._paymentsModel.firstDate),
          ).then((result) {
            widget._accountBloc.paymentFilterSink.add(
                widget._paymentsModel.filter.copyWith(
                    filter: _getFilterType(_filter),
                    startDate: result[0],
                    endDate: result[1]));
          })
              : Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Please wait while Breez is loading transactions."))),
        ),
      ),
    );
    children.add(
      Theme(
        data: Theme.of(context).backgroundColor != theme.transactionTitleStyle.color ? Theme.of(context).copyWith(canvasColor: Theme.of(context).backgroundColor) : Theme.of(context),
        child:  DropdownButtonHideUnderline(
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
      ),
    );
    return Row(children: children);
  }

  _getFilterType(String _filter){
    if (_filter == "Sent") {
      return [PaymentType.SENT, PaymentType.WITHDRAWAL];
    } else if (_filter == "Received") {
      return [PaymentType.RECEIVED, PaymentType.DEPOSIT];
    }
    return [PaymentType.RECEIVED, PaymentType.DEPOSIT, PaymentType.SENT, PaymentType.WITHDRAWAL];
  }
}
