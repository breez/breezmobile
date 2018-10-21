import 'dart:async';
import 'dart:io' show Platform;
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:breez/widgets/breez_date_picker.dart';
import 'package:breez/theme_data.dart' as theme;

class CalendarDialog extends StatefulWidget {
  final BuildContext context;
  final DateTime _firstDate;
  final DateTime startDate;
  final DateTime endDate;

  CalendarDialog(this.context, this._firstDate, [this.startDate, this.endDate]);

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
      _startDate = widget.startDate == null ? widget._firstDate : widget.startDate;
      _endDate = widget.endDate == null ? new DateTime.now() : widget.endDate;
      _startDateController.text = _formatTransactionDate(_startDate);
      _endDateController.text = _formatTransactionDate(_endDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return pickDate();
  }

  // pickDate should get payment info and set firstDate to earliest transactions date
  Widget pickDate() {
    return new AlertDialog(
      title: new Text(
        "Choose a date range:",
        style: theme.alertTitleStyle,
      ),
      content: new SingleChildScrollView(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new FlatButton(
              child: new Container(
                child: new TextFormField(
                  decoration: new InputDecoration(
                    labelText: "Start",
                    labelStyle: theme.alertStyle,
                  ),
                  controller: _startDateController,
                  enabled: false,
                  style: theme.alertStyle,
                ),
                width: 84.0,
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                setState(() {
                  _selectStartDate(context);
                });
              },
            ),
            new FlatButton(
              child: new Container(
                child: new TextFormField(
                  decoration: new InputDecoration(
                    labelText: "End",
                    labelStyle: theme.alertStyle,
                  ),
                  controller: _endDateController,
                  enabled: false,
                  style: theme.alertStyle,
                ),
                width: 84.0,
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                setState(() {
                  _selectEndDate(context);
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Clear", style: theme.cancelButtonStyle),
          onPressed: _clearFilter,
        ),
        new FlatButton(
          child: new Text("Apply Filter", style: theme.buttonStyle),
          onPressed: () {
            if (_startDate != widget._firstDate || _endDate.day != new DateTime.now().day) {
              DateTime startDate = new DateTime(_startDate.year, _startDate.month, _startDate.day, 0, 0, 0);
              DateTime endDate = new DateTime(_endDate.year, _endDate.month, _endDate.day, 0, 0, 0);
              if(startDate.compareTo(endDate) == 0) {
                endDate = new DateTime(_endDate.year, _endDate.month, _endDate.day, 23, 59, 59, 999);
                Navigator.of(context).pop([startDate, endDate]);
              } else {
                Navigator.of(context).pop([_startDate, _endDate]);
              }
            } else {
              Navigator.of(context).pop([null,null]);
            }
          },
        ),
      ],
    );
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    DateTime selectedStartDate = await showBreezDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: widget._firstDate,
      lastDate: DateTime.now(),
    );
    Duration difference = selectedStartDate.difference(_endDate);
    if (selectedStartDate != null && difference.inDays < 0) {
      setState(() {
        _startDate = selectedStartDate;
        _startDateController.text = _formatTransactionDate(_startDate);
        _endDateController.text = _formatTransactionDate(_endDate);
      });
    } else {
      setState(() {
        _startDate = selectedStartDate;
        _endDate = DateTime.now();
        _startDateController.text = _formatTransactionDate(_startDate);
        _endDateController.text = _formatTransactionDate(_endDate);
      });
    }
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    DateTime selectedEndDate = await showBreezDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: widget._firstDate,
      lastDate: DateTime.now(),
    );
    Duration difference = selectedEndDate.difference(_startDate);
    if (selectedEndDate != null && difference.inDays > 0) {
      setState(() {
        _endDate = selectedEndDate;
        _startDateController.text = _formatTransactionDate(_startDate);
        _endDateController.text = _formatTransactionDate(_endDate);
      });
    } else {
      setState(() {
        _startDate = widget._firstDate;
        _endDate = selectedEndDate;
        _startDateController.text = _formatTransactionDate(_startDate);
        _endDateController.text = _formatTransactionDate(_endDate);
      });
    }
  }

  _clearFilter() {
    setState(() {
      _startDate = widget._firstDate;
      _endDate = new DateTime.now();
      _startDateController.text = "";
      _endDateController.text = "";
    });
  }

  String _formatTransactionDate(DateTime date) {
    initializeDateFormatting(Platform.localeName,null);
    var formatter = new DateFormat.yMd(Platform.localeName);
    String formattedDate = formatter.format(date);
    return formattedDate;
  }
}
