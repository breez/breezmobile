import 'dart:io' show Platform;
import 'package:breez/widgets/fixed_sliver_delegate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/calendar_dialog.dart';

class PaymentFilterSliver extends StatefulWidget {

  final ScrollController _controller;
  final Function(String filter, [DateTime startDate, DateTime endDate]) _onFilterChanged;
  final double _minSize;
  final double _maxSize;
  final String _filter;
  final DateTime _firstDate;
  final DateTime _startDate;
  final DateTime _endDate;

  PaymentFilterSliver(this._controller, this._onFilterChanged, this._minSize, this._maxSize, this._filter, this._firstDate, this._startDate, this._endDate);

  @override
  State<StatefulWidget> createState() {
    return PaymentFilterSliverState();
  }
}

class PaymentFilterSliverState extends State<PaymentFilterSliver> {

  @override
  void initState() {
    super.initState();
    widget._controller.addListener((){
      setState((){});
    });
  }

  @override
  Widget build(BuildContext context) {
    double scrollOffset = widget._controller.position.pixels;
    return SliverPersistentHeader(
      pinned: true,
      delegate: new FixedSliverDelegate(widget._filter != "All Activities" ? widget._maxSize : (scrollOffset).clamp(widget._minSize, widget._maxSize),
          builder: (context, shrinkedHeight, overlapContent) {
            return Container(
                decoration: BoxDecoration(color: theme.BreezColors.blue[500]),
                height: widget._maxSize,
                child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: widget._filter != "All Activities" ? 1.0 : (scrollOffset - widget._maxSize / 2).clamp(0.0, 1.0),
                    child: PaymentsFilter(widget._filter, widget._onFilterChanged, widget._firstDate, widget._startDate, widget._endDate)));
          }),
    );
  }
}

class PaymentsFilter extends StatelessWidget {
  final String _filter;
  final Function(String filter, [DateTime startDate, DateTime endDate]) _onFilterChanged;
  final DateTime _firstDate;
  final DateTime _startDate;
  final DateTime _endDate;

  PaymentsFilter(this._filter, this._onFilterChanged, this._firstDate, this._startDate, this._endDate);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    children.add(
        new Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: IconButton(icon: ImageIcon(
              AssetImage("src/icon/calendar.png"),
              color: Colors.white,
              size: 24.0,
            ), onPressed: () => showDialog(barrierDismissible: false, context: context, builder: (_) => CalendarDialog(context, _firstDate, _startDate, _endDate)).then((result){_onFilterChanged(_filter, result[0], result[1]);}))));
    children.add(
      new Container(
        width: 150.0,
        child: new DropdownButtonHideUnderline(
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
                onChanged: (value) => _onFilterChanged(value,_startDate,_endDate)),
          ),
        ),
      ),
    );
    return new Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start
      ,children: <Widget>[new Padding(padding: EdgeInsets.only(top: 16.0,bottom: 0.0),child: Row(children: children)), _buildDateFilterChip(_startDate,_endDate)],);
  }

  _buildDateFilterChip(DateTime startDate,DateTime endDate){
    if(_startDate != null && _endDate != null){
      return new Padding(padding: EdgeInsets.only(left: 16.0,top: 0.0),child: Chip(label: Text(_formatFilterDateRange(_startDate,_endDate)),onDeleted: (){ _onFilterChanged(_filter,null,null);} ,));
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
}
