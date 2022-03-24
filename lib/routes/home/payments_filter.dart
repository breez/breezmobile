import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/calendar_dialog.dart';
import 'package:breez/widgets/fixed_sliver_delegate.dart';
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_extend/share_extend.dart';

class PaymentFilterSliver extends StatefulWidget {
  final ScrollController _controller;
  final double _minSize;
  final double _maxSize;
  final AccountBloc _accountBloc;
  final PaymentsModel _paymentsModel;

  PaymentFilterSliver(
    this._controller,
    this._minSize,
    this._maxSize,
    this._accountBloc,
    this._paymentsModel,
  );

  @override
  State<StatefulWidget> createState() {
    return PaymentFilterSliverState();
  }
}

class PaymentFilterSliverState extends State<PaymentFilterSliver> {
  bool _hasNoFilter;
  bool _hasNoTypeFilter;
  bool _hasNoDateFilter;

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

  void onScroll() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scrollOffset = widget._controller.position.pixels;
    final filter = widget._paymentsModel.filter;
    final paymentType = filter.paymentType;

    _hasNoTypeFilter = (paymentType.contains(PaymentType.SENT) &&
        paymentType.contains(PaymentType.DEPOSIT) &&
        paymentType.contains(PaymentType.WITHDRAWAL) &&
        paymentType.contains(PaymentType.RECEIVED));
    _hasNoDateFilter = (filter.startDate == null || filter.endDate == null);
    _hasNoFilter = _hasNoTypeFilter && _hasNoDateFilter;

    return SliverPersistentHeader(
      pinned: true,
      delegate: FixedSliverDelegate(
        !_hasNoFilter
            ? widget._maxSize
            : scrollOffset.clamp(
                widget._minSize,
                widget._maxSize,
              ),
        builder: (context, shrinkedHeight, overlapContent) {
          return AnimatedOpacity(
            duration: Duration(milliseconds: 100),
            opacity: !_hasNoFilter
                ? 1.0
                : (scrollOffset - widget._maxSize / 2).clamp(0.0, 1.0),
            child: Container(
              color: theme.customData[theme.themeId].dashboardBgColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: theme.customData[theme.themeId].paymentListBgColor,
                    height: widget._maxSize,
                    child: PaymentsFilter(
                      widget._accountBloc,
                      widget._paymentsModel,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PaymentsFilter extends StatefulWidget {
  final AccountBloc _accountBloc;
  final PaymentsModel _paymentsModel;

  PaymentsFilter(
    this._accountBloc,
    this._paymentsModel,
  );

  @override
  State<StatefulWidget> createState() {
    return PaymentsFilterState();
  }
}

class PaymentsFilterState extends State<PaymentsFilter> {
  String _filter;
  Map<String, List<PaymentType>> _filterMap;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filter = null;
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);

    if (_filter == null) {
      _filterMap = {
        texts.payments_filter_option_all: PaymentType.values,
        texts.payments_filter_option_sent: [
          PaymentType.SENT,
          PaymentType.WITHDRAWAL,
          PaymentType.CLOSED_CHANNEL,
        ],
        texts.payments_filter_option_received: [
          PaymentType.RECEIVED,
          PaymentType.DEPOSIT,
        ],
      };
      _filter = _getFilterTypeString(
        context,
        widget._paymentsModel.filter.paymentType,
      );
    }

    return Row(children: [
      _buildExportButton(context),
      _buildCalendarButton(context),
      _buildFilterDropdown(context)
    ]);
  }

  Padding _buildCalendarButton(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(left: 0.0, right: 0.0),
      child: IconButton(
        icon: SvgPicture.asset(
          "src/icon/calendar.svg",
          color: themeData.accentTextTheme.subtitle2.color,
          width: 24.0,
          height: 24.0,
        ),
        onPressed: () => widget._paymentsModel.firstDate != null
            ? showDialog(
                useRootNavigator: false,
                context: context,
                builder: (_) => CalendarDialog(widget._paymentsModel.firstDate),
              ).then((result) {
                widget._accountBloc.paymentFilterSink.add(
                  widget._paymentsModel.filter.copyWith(
                      filter: _getFilterType(_filter),
                      startDate: result[0],
                      endDate: result[1]),
                );
              })
            : ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    texts.payments_filter_message_loading_transactions,
                  ),
                ),
              ),
      ),
    );
  }

  Theme _buildFilterDropdown(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return Theme(
      data: themeData.copyWith(
        canvasColor: theme.customData[theme.themeId].paymentListBgColor,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            iconEnabledColor: themeData.accentTextTheme.subtitle2.color,
            value: _filter,
            style: themeData.accentTextTheme.subtitle2,
            items: [
              texts.payments_filter_option_all,
              texts.payments_filter_option_sent,
              texts.payments_filter_option_received,
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Material(
                  child: Text(
                    value,
                    style: themeData.accentTextTheme.subtitle2,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _filter = value;
              });
              widget._accountBloc.paymentFilterSink.add(
                widget._paymentsModel.filter.copyWith(
                  filter: _getFilterType(_filter),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<PaymentType> _getFilterType(String _filter) {
    return _filterMap[_filter] ?? PaymentType.values;
  }

  String _getFilterTypeString(
    BuildContext context,
    List<PaymentType> filterList,
  ) {
    for (var entry in _filterMap.entries) {
      if (listEquals(filterList, entry.value)) {
        return entry.key;
      }
    }
    final texts = AppLocalizations.of(context);
    return texts.payments_filter_option_all;
  }

  Padding _buildExportButton(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    if (widget._paymentsModel.paymentsList.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: PopupMenuButton(
          color: themeData.backgroundColor,
          icon: Icon(
            Icons.more_vert,
            color: themeData.accentTextTheme.subtitle2.color,
          ),
          padding: EdgeInsets.zero,
          offset: Offset(12, 24),
          onSelected: _select,
          itemBuilder: (context) => [
            PopupMenuItem(
              height: 36,
              value: Choice(() => _exportPayments(context)),
              child: Text(
                texts.payments_filter_action_export,
                style: themeData.textTheme.button,
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: IconButton(
        icon: Icon(
          Icons.more_vert,
          color: theme.themeId == "BLUE"
              ? themeData.accentTextTheme.subtitle2.color.withOpacity(0.25)
              : themeData.disabledColor,
          size: 24.0,
        ),
        onPressed: null,
      ),
    );
  }

  void _select(Choice choice) {
    choice.function();
  }

  Future _exportPayments(BuildContext context) async {
    final texts = AppLocalizations.of(context);
    var action = ExportPayments();
    widget._accountBloc.userActionsSink.add(action);
    Navigator.of(context).push(createLoaderRoute(context));
    action.future.then((filePath) {
      Navigator.of(context).pop();
      ShareExtend.share(filePath, "file");
    }).catchError((err) {
      Navigator.of(context).pop();
      showFlushbar(
        context,
        message: texts.payments_filter_action_export_failed,
      );
    });
  }
}

class Choice {
  const Choice(this.function);

  final Function function;
}
