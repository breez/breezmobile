import 'dart:async';

import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/build_context.dart';
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/breez_date_picker.dart';
import 'package:flutter/material.dart';

class CalendarDialog extends StatefulWidget {
  final DateTime firstDate;

  const CalendarDialog(this.firstDate);

  @override
  _CalendarDialogState createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  DateTime _endDate = DateTime.now();
  DateTime _startDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.firstDate;
    _startDateController.text = BreezDateUtils.formatYearMonthDay(_startDate);
    _endDateController.text = BreezDateUtils.formatYearMonthDay(_endDate);
  }

  @override
  Widget build(BuildContext context) {
    var l10n = context.l10n;
    ThemeData themeData = context.theme;
    DialogTheme dialogTheme = themeData.dialogTheme;
    TextStyle btnTextStyle = themeData.primaryTextTheme.button;

    return AlertDialog(
      title: Text(
        l10n.pos_transactions_range_dialog_title,
        style: dialogTheme.titleTextStyle,
      ),
      content: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: _selectDateButton(
              l10n.pos_transactions_range_dialog_start,
              _startDateController,
              true,
            ),
          ),
          Flexible(
            child: _selectDateButton(
              l10n.pos_transactions_range_dialog_end,
              _endDateController,
              false,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            l10n.pos_transactions_range_dialog_clear,
            style: theme.cancelButtonStyle.copyWith(
              color:
                  theme.themeId == "BLUE" ? Colors.red : themeData.errorColor,
            ),
          ),
          onPressed: _clearFilter,
        ),
        TextButton(
          child: Text(
            l10n.pos_transactions_range_dialog_apply,
            style: btnTextStyle,
          ),
          onPressed: () => _applyFilter(context),
        ),
      ],
    );
  }

  void _applyFilter(BuildContext context) {
    // Check if filter is unchanged
    if (_startDate != widget.firstDate || _endDate.day != DateTime.now().day) {
      context.pop([
        DateTime(_startDate.year, _startDate.month, _startDate.day, 0, 0, 0),
        DateTime(_endDate.year, _endDate.month, _endDate.day, 23, 59, 59, 999),
      ]);
    } else {
      context.pop([null, null]);
    }
  }

  Widget _selectDateButton(
    String label,
    TextEditingController textEditingController,
    bool isStartBtn,
  ) {
    ThemeData themeData = context.theme;
    TextStyle dialogContentTextStyle = themeData.dialogTheme.contentTextStyle;

    return GestureDetector(
      child: Theme(
        data: theme.themeId == "BLUE"
            ? themeData
            : themeData.copyWith(
                disabledColor: themeData.backgroundColor,
              ),
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: dialogContentTextStyle,
          ),
          controller: textEditingController,
          enabled: false,
          style: dialogContentTextStyle,
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
          _startDateController.text =
              BreezDateUtils.formatYearMonthDay(_startDate);
          _endDateController.text = BreezDateUtils.formatYearMonthDay(_endDate);
        });
      } else {
        setState(() {
          if (isStartBtn) {
            _startDate = selectedDate;
          } else {
            _endDate = selectedDate;
          }
          _startDateController.text =
              BreezDateUtils.formatYearMonthDay(_startDate);
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
