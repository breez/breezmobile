import 'dart:async';

import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/breez_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarDialog extends StatefulWidget {
  final BuildContext context;
  final DateTime firstDate;

  CalendarDialog(this.context, this.firstDate);

  @override
  _CalendarDialogState createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  DateTime _endDate = DateTime.now();
  DateTime _startDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.firstDate;
    _startDateController.text = BreezDateUtils.formatYearMonthDay(widget.firstDate);
    _endDateController.text = BreezDateUtils.formatYearMonthDay(_endDate);
  }

  @override
  Widget build(BuildContext context) {
    return pickDate();
  }

  Widget pickDate() {
    return AlertDialog(
      title: Text(
        "Choose a date range:",
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      content: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
              //flex: 0,
              child: _selectDateButton("Start", _startDateController, true)),
          Flexible(
              //flex: 0,
              child: _selectDateButton("End", _endDateController, false)),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("CLEAR",
              style: theme.cancelButtonStyle.copyWith(
                  color: theme.themeId == "BLUE"
                      ? Colors.red
                      : Theme.of(context).errorColor)),
          onPressed: _clearFilter,
        ),
        FlatButton(
          child: Text("APPLY FILTER",
              style: Theme.of(context).primaryTextTheme.button),
          onPressed: () {
            _applyFilter();
          },
        ),
      ],
    );
  }

  void _applyFilter() {
    // Check if filter is unchanged
    if (_startDate != widget.firstDate || _endDate.day != DateTime.now().day) {
      DateTime startDate =
          DateTime(_startDate.year, _startDate.month, _startDate.day, 0, 0, 0);
      DateTime endDate = DateTime(
          _endDate.year, _endDate.month, _endDate.day, 23, 59, 59, 999);
      Navigator.of(context).pop([startDate, endDate]);
    } else {
      Navigator.of(context).pop([null, null]);
    }
  }

  Widget _selectDateButton(String label,
      TextEditingController textEditingController, bool isStartBtn) {
    return GestureDetector(
      child: Theme(
        data: theme.themeId == "BLUE"
            ? Theme.of(context)
            : Theme.of(context)
                .copyWith(disabledColor: Theme.of(context).backgroundColor),
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: Theme.of(context).dialogTheme.contentTextStyle,
          ),
          controller: textEditingController,
          enabled: false,
          style: Theme.of(context).dialogTheme.contentTextStyle,
        ),
      ),
      onTap: () {
        setState(() {
          _selectDate(context, isStartBtn);
        });
      },
      behavior: HitTestBehavior.translucent,
    );
  }

  Future<Null> _selectDate(BuildContext context, bool isStartBtn) async {
    DateTime selectedDate = await showBreezDatePicker(
      context: context,
      initialDate: isStartBtn ? _startDate : _endDate,
      firstDate: widget.firstDate,
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      Duration difference = isStartBtn
          ? selectedDate.difference(_endDate)
          : selectedDate.difference(_startDate);
      if (difference.inDays < 0) {
        setState(() {
          isStartBtn ? _startDate = selectedDate : _endDate = selectedDate;
          _startDateController.text = BreezDateUtils.formatYearMonthDay(_startDate);
          _endDateController.text = BreezDateUtils.formatYearMonthDay(_endDate);
        });
      } else {
        setState(() {
          if (isStartBtn) {
            _startDate = selectedDate;
          } else {
            _endDate = selectedDate;
          }
          _startDateController.text = BreezDateUtils.formatYearMonthDay(_startDate);
          _endDateController.text = BreezDateUtils.formatYearMonthDay(_endDate);
        });
      }
    }
  }

  _clearFilter() {
    setState(() {
      _startDate = widget.firstDate;
      _endDate = DateTime.now();
      _startDateController.text = "";
      _endDateController.text = "";
    });
  }
}
