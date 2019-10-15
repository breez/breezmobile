import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/breez_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarDialog extends StatefulWidget {
  final BuildContext context;
  final DateTime firstDate;

  CalendarDialog(this.context, this.firstDate);

  @override
  _CalendarDialogState createState() => new _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  TextEditingController _startDateController = new TextEditingController();
  TextEditingController _endDateController = new TextEditingController();  
  DateTime _endDate = DateTime.now();
  DateTime _startDate;
  AutoSizeGroup _autoSizeGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();   
    _startDate = widget.firstDate;     
    _startDateController.text = DateUtils.formatYearMonthDay(widget.firstDate);
    _endDateController.text = DateUtils.formatYearMonthDay(_endDate);
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
        children: <Widget>[
          _selectDateButton("Start", _startDateController, true),
          _selectDateButton("End", _endDateController, false),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Clear", style: theme.cancelButtonStyle.copyWith(color: theme.themeId == "BLUE" ? Colors.red : Theme.of(context).errorColor)),
          onPressed: _clearFilter,
        ),
        FlatButton(
          child: Text("Apply Filter", style: Theme.of(context).primaryTextTheme.button),
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
      DateTime endDate = DateTime(_endDate.year, _endDate.month, _endDate.day, 23, 59, 59, 999);
      Navigator.of(context).pop([startDate, endDate]);
    } else {
      Navigator.of(context).pop([null, null]);
    }
  }

  Widget _selectDateButton(String label, TextEditingController textEditingController, bool isStartBtn) {
    return Expanded(
      child: GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              AutoSizeText(
                label,
                style: Theme.of(context).dialogTheme.contentTextStyle.copyWith(fontSize: 12),
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
              ),
              AutoSizeText(
                textEditingController.text,
                style: Theme.of(context).dialogTheme.contentTextStyle,
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
                group: _autoSizeGroup,
              )
            ]),
          ],
        ),
        onTap: () {
          setState(() {
            _selectDate(context, isStartBtn);
          });
        },
        behavior: HitTestBehavior.translucent,
      ),
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
          } else {
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
