import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/widgets/breez_date_picker.dart';
import 'package:breez/utils/date.dart';
import 'package:breez/theme_data.dart' as theme;

class CalendarDialog extends StatefulWidget {
  final BuildContext context;
  final DateTime firstDate;
  final DateTime startDate;
  final DateTime endDate;

  CalendarDialog(this.context, this.firstDate, [this.startDate, this.endDate]);

  @override
  _CalendarDialogState createState() => new _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  TextEditingController _startDateController = new TextEditingController();
  TextEditingController _endDateController = new TextEditingController();
  DateTime _startDate;
  DateTime _endDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      _startDate = widget.startDate == null ? widget.firstDate : widget.startDate;
      _endDate = widget.endDate == null ? DateTime.now() : widget.endDate;
      _startDateController.text = DateUtils.formatYearMonthDay(_startDate);
      _endDateController.text = DateUtils.formatYearMonthDay(_endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return pickDate();
  }

  Widget pickDate() {
    return AlertDialog(
      title: Text(
        "Choose a date range:",
        style: theme.alertTitleStyle,
      ),
      content: SingleChildScrollView(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _selectDateButton("Start", _startDateController),
            _selectDateButton("End", _endDateController),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Clear", style: theme.cancelButtonStyle),
          onPressed: _clearFilter,
        ),
        FlatButton(
          child: Text("Apply Filter", style: theme.buttonStyle),
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
      DateTime startDate = DateTime(_startDate.year, _startDate.month, _startDate.day, 0, 0, 0);
      DateTime endDate = DateTime(_endDate.year, _endDate.month, _endDate.day, 0, 0, 0);
      // If selected dates are equal to each other, apply filter to the whole day
      if (startDate.compareTo(endDate) == 0) {
        endDate = DateTime(_endDate.year, _endDate.month, _endDate.day, 23, 59, 59, 999);
        Navigator.of(context).pop([startDate, endDate]);
      } else {
        Navigator.of(context).pop([_startDate, _endDate]);
      }
    } else {
      Navigator.of(context).pop([null, null]);
    }
  }

  Widget _selectDateButton(String label, TextEditingController textEditingController) {
    return FlatButton(
      child: Container(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: theme.alertStyle,
          ),
          controller: textEditingController,
          enabled: false,
          style: theme.alertStyle,
        ),
        width: 84.0,
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        setState(() {
          label == "Start" ? _selectDate(context, true) : _selectDate(context, false);
        });
      },
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
      Duration difference = isStartBtn ? selectedDate.difference(_endDate) : selectedDate.difference(_startDate);
      if (difference.inDays < 0) {
        setState(() {
          isStartBtn ? _startDate = selectedDate : _endDate = selectedDate;
          _startDateController.text = DateUtils.formatYearMonthDay(_startDate);
          _endDateController.text = DateUtils.formatYearMonthDay(_endDate);
        });
      } else {
        setState(() {
          if (isStartBtn) {
            _startDate = selectedDate;
            _endDate = DateTime.now();
          } else {
            _startDate = widget.firstDate;
            _endDate = selectedDate;
          }
          _startDateController.text = DateUtils.formatYearMonthDay(_startDate);
          _endDateController.text = DateUtils.formatYearMonthDay(_endDate);
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
