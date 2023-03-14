import 'dart:async';

import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

class CalendarDialog extends StatefulWidget {
  final DateTime firstDate;
  final DateTime endDate;
  final DateTime initialRangeDate;

  const CalendarDialog(
    this.firstDate, {
    this.endDate,
    this.initialRangeDate,
  });

  @override
  CalendarDialogState createState() => CalendarDialogState();
}

class CalendarDialogState extends State<CalendarDialog> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  DateTime _startDate;
  DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.firstDate;
    _endDate = widget.endDate ?? DateTime.now();
    _applyControllers();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return AlertDialog(
      title: Text(
        texts.pos_transactions_range_dialog_title,
        style: themeData.dialogTheme.titleTextStyle,
      ),
      content: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: _selectDateButton(
              texts.pos_transactions_range_dialog_start,
              _startDateController,
              true,
            ),
          ),
          Flexible(
            child: _selectDateButton(
              texts.pos_transactions_range_dialog_end,
              _endDateController,
              false,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _clearFilter,
          child: Text(
            texts.pos_transactions_range_dialog_clear,
            style: theme.cancelButtonStyle.copyWith(
              color:
                  theme.themeId == "BLUE" ? Colors.red : themeData.colorScheme.error,
            ),
          ),
        ),
        TextButton(
          child: Text(
            texts.pos_transactions_range_dialog_apply,
            style: themeData.primaryTextTheme.labelLarge,
          ),
          onPressed: () => _applyFilter(context),
        ),
      ],
    );
  }

  void _applyFilter(BuildContext context) {
    Navigator.of(context).pop([
      DateTime(_startDate.year, _startDate.month, _startDate.day, 0, 0, 0),
      DateTime(_endDate.year, _endDate.month, _endDate.day, 23, 59, 59, 999),
    ]);
  }

  Widget _selectDateButton(
    String label,
    TextEditingController textEditingController,
    bool isStartBtn,
  ) {
    final themeData = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectDate(context, isStartBtn);
        });
      },
      behavior: HitTestBehavior.translucent,
      child: Theme(
        data: theme.themeId == "BLUE"
            ? themeData
            : themeData.copyWith(
                disabledColor: themeData.colorScheme.background,
              ),
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: themeData.dialogTheme.contentTextStyle,
          ),
          controller: textEditingController,
          enabled: false,
          style: themeData.dialogTheme.contentTextStyle,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartBtn) async {
    DateTime selectedDate = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: isStartBtn ? _startDate : _endDate,
      firstDate: widget.initialRangeDate ?? widget.firstDate,
      lastDate: _endDate.isAfter(DateTime.now()) ? _endDate : DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: theme.calendarTheme,
          child: child,
        );
      },
    );
    if (selectedDate != null) {
      Duration difference = isStartBtn
          ? selectedDate.difference(_endDate)
          : selectedDate.difference(_startDate);
      if (difference.inDays < 0) {
        setState(() {
          isStartBtn ? _startDate = selectedDate : _endDate = selectedDate;
          _applyControllers();
        });
      } else {
        setState(() {
          if (isStartBtn) {
            _startDate = selectedDate;
          } else {
            _endDate = selectedDate;
          }
          _applyControllers();
        });
      }
    }
  }

  void _applyControllers() {
    if (_startDate != null &&
        _endDate != null &&
        _endDate.isBefore(_startDate)) {
      final temp = _endDate;
      _endDate = _startDate;
      _startDate = temp;
    }
    _startDateController.text = BreezDateUtils.formatYearMonthDay(_startDate);
    _endDateController.text = BreezDateUtils.formatYearMonthDay(_endDate);
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
