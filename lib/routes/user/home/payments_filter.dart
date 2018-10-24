import 'package:flutter/material.dart';
import 'package:breez/widgets/fixed_sliver_delegate.dart';
import 'package:breez/widgets/calendar_dialog.dart';
import 'package:breez/theme_data.dart' as theme;

class PaymentFilterSliver extends StatefulWidget {

  final ScrollController _controller;
  final Function(String fitler) _onFilterChanged;
  final double _minSize;
  final double _maxSize;
  final String _filter;
  final DateTime _firstDate;

  PaymentFilterSliver(this._controller, this._onFilterChanged, this._minSize, this._maxSize, this._filter, this._firstDate);

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
                  child: PaymentsFilter(widget._filter, widget._onFilterChanged, widget._firstDate)));
        }),
      );
  }
}

class PaymentsFilter extends StatelessWidget {
  final String _filter;
  final Function(String fitler) _onFilterChanged;
  final DateTime _firstDate;

  PaymentsFilter(this._filter, this._onFilterChanged, this._firstDate);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    children.add(
      new Padding(
        padding: EdgeInsets.only(left: 12.0, right: 0.0),
        child: IconButton(icon: ImageIcon(
          AssetImage("src/icon/calendar.png"),
          color: Colors.white,
          size: 24.0,
        ),
          onPressed: () =>
              showDialog(barrierDismissible: false,
                context: context,
                builder: (_) => CalendarDialog(context, _firstDate),),),
      ),
    );
    children.add(
      new DropdownButtonHideUnderline(
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
              onChanged: (value) => _onFilterChanged(value)),
        ),
      ),
    );
    return Row(children: children);
  }
}
