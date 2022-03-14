import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/pos_catalog/actions.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/routes/charge/currency_wrapper.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/date.dart';
import 'package:breez/widgets/calendar_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PosReportDialog extends StatelessWidget {
  const PosReportDialog();

  @override
  Widget build(BuildContext context) {
    final posCatalogBloc = AppBlocsProvider.of<PosCatalogBloc>(context);
    final accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    return StreamBuilder<AccountModel>(
      stream: accountBloc.accountStream,
      builder: (context, snapshot) {
        final accountModel = snapshot.data;
        if (accountModel == null) return Loader();

        return StreamBuilder<PosReportTimeRange>(
          stream: posCatalogBloc.posReportRange.distinct(),
          initialData: PosReportTimeRange.daily(),
          builder: (context, snapshot) {
            final timeRange = snapshot.data ?? PosReportTimeRange.daily();
            posCatalogBloc.actionsSink.add(FetchPosReport(timeRange));

            return StreamBuilder<PosReportResult>(
              stream: posCatalogBloc.posReportResult,
              initialData: PosReportResult.load(),
              builder: (context, snapshot) {
                final result = snapshot.data ?? PosReportResult.load();

                return _buildDialog(context, accountModel, timeRange, result);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDialog(
    BuildContext context,
    AccountModel accountModel,
    PosReportTimeRange timeRange,
    PosReportResult result,
  ) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    return AlertDialog(
      title: _titleRow(context, timeRange),
      titlePadding: const EdgeInsets.fromLTRB(32.0, 16.0, 16.0, 0.0),
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      content: Builder(
        builder: (context) {
          final size = MediaQuery.of(context).size;
          return Container(
            height: timeRange is PosReportTimeRangeDaily ? 180 : 220,
            width: size.width - 64,
            child: result is PosReportResultLoad
                ? _contentLoad(context)
                : _contentData(context, accountModel, timeRange, result),
          );
        },
      ),
      actions: [
        TextButton(
          child: Text(
            texts.pos_report_dialog_action_close,
            style: themeData.primaryTextTheme.button.copyWith(
              color: _highlight(themeData),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Container(
          width: 8.0,
        ),
      ],
    );
  }

  Widget _titleRow(
    BuildContext context,
    PosReportTimeRange timeRange,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        _title(context, timeRange),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
          child: _dropdownTrigger(context, timeRange),
        ),
      ],
    );
  }

  Widget _title(
    BuildContext context,
    PosReportTimeRange timeRange,
  ) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    String title;
    if (timeRange is PosReportTimeRangeDaily) {
      title = texts.pos_report_dialog_title_daily;
    } else if (timeRange is PosReportTimeRangeWeekly) {
      title = texts.pos_report_dialog_title_weekly;
    } else if (timeRange is PosReportTimeRangeMonthly) {
      title = texts.pos_report_dialog_title_monthly;
    } else if (timeRange is PosReportTimeRangeCustom) {
      title = texts.pos_report_dialog_title_custom;
    } else {
      title = "";
    }

    return Text(
      title,
      style: themeData.primaryTextTheme.headline6.copyWith(
        color: _highlight(themeData),
      ),
    );
  }

  Widget _dropdownTrigger(
    BuildContext context,
    PosReportTimeRange timeRange,
  ) {
    TapDownDetails _details;
    return GestureDetector(
      onTapDown: (details) {
        _details = details;
      },
      onTap: () async {
        final offset = _details?.globalPosition;
        if (offset == null) return;
        final newOption = await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
          items: [
            PosReportTimeRange.daily(),
            PosReportTimeRange.weekly(),
            PosReportTimeRange.monthly(),
            PosReportTimeRange.custom(timeRange.startDate, timeRange.endDate),
          ].map((e) => _dropdownItem(context, e)).toList(),
        );
        if (newOption != null) {
          if (newOption is PosReportTimeRangeCustom) {
            showDialog(
              useRootNavigator: false,
              context: context,
              builder: (_) => CalendarDialog(
                newOption.startDate,
                initialRangeDate: DateTime(2018),
              ),
            ).then((result) {
              final DateTime startDate = result[0] ?? newOption.startDate;
              final DateTime endDate = result[1] ?? newOption.endDate;

              if (startDate.isBefore(endDate)) {
                AppBlocsProvider.of<PosCatalogBloc>(context)
                    .actionsSink
                    .add(UpdatePosReportTimeRange(
                      PosReportTimeRange.custom(startDate, endDate),
                    ));
              }
            });
          } else {
            AppBlocsProvider.of<PosCatalogBloc>(context)
                .actionsSink
                .add(UpdatePosReportTimeRange(newOption));
          }
        }
      },
      child: _dropdownHandler(context),
    );
  }

  Widget _dropdownHandler(
    BuildContext context,
  ) {
    final themeData = Theme.of(context);

    return SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: SvgPicture.asset(
          "src/icon/calendar.svg",
          color: _highlight(themeData),
          width: 24.0,
          height: 24.0,
        ),
      ),
    );
  }

  PopupMenuEntry<PosReportTimeRange> _dropdownItem(
    BuildContext context,
    PosReportTimeRange timeRange,
  ) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    String title;
    if (timeRange is PosReportTimeRangeDaily) {
      title = texts.pos_report_dialog_dropdown_item_daily;
    } else if (timeRange is PosReportTimeRangeWeekly) {
      title = texts.pos_report_dialog_dropdown_item_weekly;
    } else if (timeRange is PosReportTimeRangeMonthly) {
      title = texts.pos_report_dialog_dropdown_item_monthly;
    } else if (timeRange is PosReportTimeRangeCustom) {
      title = texts.pos_report_dialog_dropdown_item_custom;
    } else {
      title = "";
    }

    return PopupMenuItem<PosReportTimeRange>(
      value: timeRange,
      child: Text(
        title,
        textAlign: TextAlign.end,
        style: themeData.textTheme.titleSmall.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _contentLoad(
    BuildContext context,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Loader(),
      ],
    );
  }

  Widget _contentData(
    BuildContext context,
    AccountModel accountModel,
    PosReportTimeRange timeRange,
    PosReportResult result,
  ) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);
    final isDaily = timeRange is PosReportTimeRangeDaily;
    final showTotal = result is PosReportResultData && result.isSingleFiat();

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    isDaily
                        ? Container()
                        : _labelText(
                            themeData,
                            texts.pos_report_dialog_content_start_date_label,
                          ),
                    isDaily
                        ? Container()
                        : _labelText(
                            themeData,
                            texts.pos_report_dialog_content_end_date_label,
                          ),
                    _labelText(
                      themeData,
                      texts.pos_report_dialog_content_sales_label,
                    ),
                    _labelText(
                      themeData,
                      texts.pos_report_dialog_content_amount_label,
                    ),
                    !showTotal
                        ? Container()
                        : _labelText(
                            themeData,
                            "",
                          ),
                  ],
                ),
              ],
            ),
            Container(
              width: 8.0,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isDaily
                        ? Container()
                        : _valueText(
                            themeData,
                            BreezDateUtils.formatYearMonthDay(
                              timeRange.startDate,
                            ),
                          ),
                    isDaily
                        ? Container()
                        : _valueText(
                            themeData,
                            BreezDateUtils.formatYearMonthDay(
                              timeRange.endDate,
                            ),
                          ),
                    _valueText(
                      themeData,
                      _contentAmount(result),
                    ),
                    _valueText(
                      themeData,
                      _contentTotalInSats(result),
                    ),
                    !showTotal
                        ? Container()
                        : _valueText(
                            themeData,
                            _contentTotalInFiat(result, accountModel),
                          ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _labelText(
    ThemeData themeData,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: themeData.primaryTextTheme.headline4.copyWith(
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget _valueText(
    ThemeData themeData,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: themeData.primaryTextTheme.headline3.copyWith(
          fontSize: 16.0,
        ),
      ),
    );
  }

  Color _highlight(ThemeData themeData) {
    return theme.themeId == "BLUE" ? themeData.canvasColor : Colors.white;
  }

  String _contentAmount(
    PosReportResult result,
  ) {
    if (result is PosReportResultData) {
      return "${result.totalSales}";
    } else {
      return "0";
    }
  }

  String _contentTotalInSats(
    PosReportResult result,
  ) {
    return Currency.SAT.format(
      Int64(result is PosReportResultData ? result.totalSalesInSatoshi : 0),
      includeCurrencySymbol: false,
      includeDisplayName: true,
    );
  }

  String _contentTotalInFiat(
    PosReportResult result,
    AccountModel accountModel,
  ) {
    if (result is PosReportResultData && result.isSingleFiat()) {
      CurrencyWrapper saleCurrency = CurrencyWrapper.fromShortName(
        result.currency,
        accountModel,
      );
      return saleCurrency.format(
        result.amount,
        includeCurrencySymbol: true,
      );
    } else {
      return "";
    }
  }
}
