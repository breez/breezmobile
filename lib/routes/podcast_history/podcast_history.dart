import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:breez/bloc/podcast_history/model.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../bloc/blocs_provider.dart';
import '../../bloc/podcast_history/actions.dart';
import '../../bloc/podcast_history/podcast_history_bloc.dart';
import '../../widgets/network_image_builder.dart';

class PodcastHistoryPage extends StatefulWidget {
  const PodcastHistoryPage({
    Key key,
  }) : super(key: key);

  @override
  PodcastHistoryPageState createState() {
    return PodcastHistoryPageState();
  }
}

class PodcastHistoryPageState extends State<PodcastHistoryPage> {
  ScreenshotController _screenshotController = ScreenshotController();

  @override
  Future<void> didChangeDependencies() async {
    final podcastHistoryBloc = AppBlocsProvider.of<PodcastHistoryBloc>(context);
    PodcastHistoryTimeRange timeRange =
        await podcastHistoryBloc.getPodcastHistoryTimeRageFromPrefs();

    podcastHistoryBloc.fetchPodcastHistory(
        startDate: timeRange.startDate, endDate: timeRange.endDate);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context);

    final podcastHistoryBloc = AppBlocsProvider.of<PodcastHistoryBloc>(context);
    return StreamBuilder<PodcastHistoryTimeRange>(
        stream: podcastHistoryBloc.posReportRange.distinct(),
        initialData: PodcastHistoryTimeRange.monthly(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final timeRange = snapshot.data ?? PodcastHistoryTimeRange.daily();

            return _build(context, timeRange, podcastHistoryBloc);
          } else {
            return const Text('Empty data');
          }
        });
  }

  _build(BuildContext context, PodcastHistoryTimeRange timeRange,
      PodcastHistoryBloc podcastHistoryBloc) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: themeData.appBarTheme.iconTheme,
        textTheme: themeData.appBarTheme.textTheme,
        backgroundColor: themeData.canvasColor,
        automaticallyImplyLeading: false,
        leading: backBtn.BackButton(),
        title: Text(
          _getAppBarDisplayString(timeRange, context),
          style: themeData.appBarTheme.textTheme.headline6,
        ),
        elevation: 0.0,
        actions: [
          PopupMenuButton<PodcastHistoryTimeRange>(
            icon: SvgPicture.asset(
              "src/icon/calendar.svg",
              color: themeData.iconTheme.color,
              width: 24.0,
              height: 24.0,
            ),
            onSelected: (value) {
              AppBlocsProvider.of<PodcastHistoryBloc>(context)
                  .actionsSink
                  .add(UpdatePodcastHistoryTimeRange(value));
            },
            itemBuilder: (ctx) => [
              PodcastHistoryTimeRange.daily(),
              PodcastHistoryTimeRange.weekly(),
              PodcastHistoryTimeRange.monthly(),
              PodcastHistoryTimeRange.yearly(),
              PodcastHistoryTimeRange.allTime()
            ].map((e) => _timeRangeDropdownItem(context, e)).toList(),
          )
        ],
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: podcastHistoryBloc.showShareButton,
        initialData: false,
        builder: (context, snapshot) {
          return snapshot.data
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    await _screenshotController
                        .captureFromWidget(
                            Container(
                              color: themeData.canvasColor,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 60, bottom: 16, left: 16, right: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "My ${_getAppBarDisplayString(timeRange, context)}",
                                      style: themeData
                                          .appBarTheme.textTheme.headline6,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _getPodcastHistoryList(
                                        context: context,
                                        getScreenshotWidget: true,
                                        timeRange: timeRange),
                                  ],
                                ),
                              ),
                            ),
                            context: context,
                            delay: const Duration(milliseconds: 10))
                        .then((Uint8List image) async {
                      if (image != null) {
                        final directory =
                            await getApplicationDocumentsDirectory();
                        final imagePath =
                            await File('${directory.path}/image.jpg').create();
                        await imagePath.writeAsBytes(image);
                        await Share.shareFiles([imagePath.path],
                            text: AppLocalizations.of(context)
                                .podcast_history_share_message);

                        // await ShareExtend.share(imagePath.path, "image");
                      }
                    });
                  },
                  icon: Icon(
                    Icons.share,
                    color: Theme.of(context).canvasColor,
                  ),
                  label: Text(
                      AppLocalizations.of(context).podcast_history_share_text),
                )
              : SizedBox();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<PodcastHistoryRecord>(
                  stream: podcastHistoryBloc.podcastHistoryRecord,
                  initialData: PodcastHistoryRecord(
                      totalDurationInMinsSum: 0,
                      totalBoostagramSentSum: 0,
                      totalSatsStreamedSum: 0),
                  builder: (context, snapshot) {
                    return snapshot.data != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _PodcastStatItem(
                                  svg: "src/icon/schedule_icon.svg",
                                  label:
                                      '${_podcastListingTimeMap(durationInMins: snapshot.data.totalDurationInMinsSum)["unit"]} listened',
                                  value: _podcastListingTimeMap(
                                      durationInMins: snapshot.data
                                          .totalDurationInMinsSum)["value"]),
                              _PodcastStatItem(
                                svg: "src/icon/satoshi_icon.svg",
                                label: AppLocalizations.of(context)
                                    .podcast_history_sats_streamed,
                                value: _getCompactNumber(
                                    snapshot.data.totalSatsStreamedSum),
                              ),
                              _PodcastStatItem(
                                svg: "src/icon/rocket_launch_icon.svg",
                                label: AppLocalizations.of(context)
                                    .podcast_history_boostagrams_sent,
                                value: _getCompactNumber(
                                    snapshot.data.totalBoostagramSentSum),
                              ),
                            ],
                          )
                        : SizedBox();
                  }),
              SizedBox(
                height: 16,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("PODCASTS"),
                  Spacer(),
                  StreamBuilder<bool>(
                      stream: podcastHistoryBloc.showShareButton,
                      initialData: false,
                      builder: (context, snapshot) {
                        return snapshot.data
                            ? StreamBuilder<PodcastHistorySortOptions>(
                                initialData:
                                    PodcastHistorySortOptions.recentlyHeard(),
                                stream:
                                    podcastHistoryBloc.podcastHistorySortOption,
                                builder: (context, sortOptionSnapshot) {
                                  return PopupMenuButton<
                                      PodcastHistorySortOptions>(
                                    padding: EdgeInsets.all(0),
                                    enableFeedback: true,
                                    child: Icon(
                                      Icons.filter_list,
                                      color: theme.themeId != "BLUE"
                                          ? Colors.white
                                          : theme.BreezColors.white[400],
                                    ),
                                    onSelected: (value) {
                                      AppBlocsProvider.of<PodcastHistoryBloc>(
                                              context)
                                          .actionsSink
                                          .add(UpdatePodcastHistorySort(value));
                                    },
                                    itemBuilder: (ctx) => [
                                      PodcastHistorySortOptions.recentlyHeard(),
                                      PodcastHistorySortOptions
                                          .durationDescending(),
                                      PodcastHistorySortOptions.satsDecending(),
                                    ]
                                        .map((e) => _listSortDropdownItem(
                                              context,
                                              e,
                                            ))
                                        .toList(),
                                  );
                                })
                            : SizedBox();
                      }),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              _getPodcastHistoryList(
                  context: context,
                  getScreenshotWidget: false,
                  timeRange: timeRange),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _getPodcastHistoryList(
    {BuildContext context,
    bool getScreenshotWidget,
    PodcastHistoryTimeRange timeRange}) {
  final podcastHistoryBloc = AppBlocsProvider.of<PodcastHistoryBloc>(context);
  final texts = AppLocalizations.of(context);
  return StreamBuilder<PodcastHistoryRecord>(
      stream: podcastHistoryBloc.podcastHistoryRecord,
      builder: (context, podcastHistoryListSnapshot) {
        if (podcastHistoryListSnapshot.data != null) {
          if (podcastHistoryListSnapshot.data.podcastHistoryList.isEmpty) {
            return Center(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      texts.podcast_history_empty_list_title,
                      style:
                          Theme.of(context).primaryTextTheme.headline3.copyWith(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '"${_getAppBarDisplayString(timeRange, context)}"',
                      style:
                          Theme.of(context).primaryTextTheme.headline3.copyWith(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 40),
                      child: Text(texts.podcast_history_empty_list_subtitle),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(texts.podcast_history_open_podcast_button))
                  ],
                ),
              ),
            );
          } else {
            //This enables sharing of upto 5 podcasts
            int podcastHistoryLength = 0;
            if (getScreenshotWidget) {
              podcastHistoryLength =
                  podcastHistoryListSnapshot.data.podcastHistoryList.length <= 5
                      ? podcastHistoryListSnapshot
                          .data.podcastHistoryList.length
                      : 5;
            } else {
              podcastHistoryLength =
                  podcastHistoryListSnapshot.data.podcastHistoryList.length;
            }

            return Column(
              children: [
                for (var i = 0; i < podcastHistoryLength; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PodcastListTile(
                        title: podcastHistoryListSnapshot
                            .data.podcastHistoryList[i].podcastName,
                        sats: _getCompactNumber(podcastHistoryListSnapshot
                            .data.podcastHistoryList[i].satsSpent),
                        boostagrams: _getCompactNumber(
                            podcastHistoryListSnapshot
                                .data.podcastHistoryList[i].boostagramsSent),
                        durationInMins: podcastHistoryListSnapshot
                            .data.podcastHistoryList[i].durationInMins,
                        imageUrl: podcastHistoryListSnapshot
                            .data.podcastHistoryList[i].podcastImageUrl),
                  ),
              ],
            );
          }
        } else {
          return Center(child: Loader());
        }
      });
}

String _getAppBarDisplayString(
  PodcastHistoryTimeRange timeRange,
  BuildContext context,
) {
  final texts = AppLocalizations.of(context);
  String title;
  if (timeRange is PodcastHistoryTimeRangeDaily) {
    title = texts.podcast_history_appbar_top_daily;
  } else if (timeRange is PodcastHistoryTimeRangeWeekly) {
    title = texts.podcast_history_appbar_top_weekly;
  } else if (timeRange is PodcastHistoryTimeRangeMonthly) {
    title = texts.podcast_history_appbar_top_monthly;
  } else if (timeRange is PodcastHistoryTimeRangeYearly) {
    title = texts.podcast_history_appbar_top_yearly;
  } else if (timeRange is PodcastHistoryTimeRangeAllTime) {
    title = texts.podcast_history_appbar_top_alltime;
  } else {
    title = "";
  }
  return title;
}

PopupMenuEntry<PodcastHistoryTimeRange> _timeRangeDropdownItem(
  BuildContext context,
  PodcastHistoryTimeRange timeRange,
) {
  final texts = AppLocalizations.of(context);
  final themeData = Theme.of(context);

  String title;
  if (timeRange is PodcastHistoryTimeRangeDaily) {
    title = texts.podcast_history_timerange_dropdown_today;
  } else if (timeRange is PodcastHistoryTimeRangeWeekly) {
    title = texts.podcast_history_timerange_dropdown_week;
  } else if (timeRange is PodcastHistoryTimeRangeMonthly) {
    title = texts.podcast_history_timerange_dropdown_month;
  } else if (timeRange is PodcastHistoryTimeRangeYearly) {
    title = texts.podcast_history_timerange_dropdown_year;
  } else if (timeRange is PodcastHistoryTimeRangeAllTime) {
    title = texts.podcast_history_timerange_dropdown_alltime;
  } else {
    title = "";
  }

  return PopupMenuItem<PodcastHistoryTimeRange>(
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

PopupMenuEntry<PodcastHistorySortOptions> _listSortDropdownItem(
  BuildContext context,
  PodcastHistorySortOptions sortOption,
) {
  final themeData = Theme.of(context);
  final texts = AppLocalizations.of(context);

  String title;
  if (sortOption is PodcastHistorySortRecentlyHeard) {
    title = texts.podcast_history_sort_dropdown_recent;
  } else if (sortOption is PodcastHistorySortDurationDescending) {
    title = texts.podcast_history_sort_dropdown_duration;
  } else if (sortOption is PodcastHistorySortSatsDescendings) {
    title = texts.podcast_history_sort_dropdown_sats;
  } else {
    title = "";
  }

  return PopupMenuItem<PodcastHistorySortOptions>(
    value: sortOption,
    child: Text(
      title,
      textAlign: TextAlign.end,
      style: themeData.textTheme.titleSmall.copyWith(color: Colors.white),
    ),
  );
}

class _PodcastStatItem extends StatelessWidget {
  const _PodcastStatItem({
    Key key,
    @required this.label,
    @required this.value,
    @required this.svg,
  }) : super(key: key);
  final String label;
  final String value;
  final String svg;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              value,
              style: Theme.of(context).primaryTextTheme.headline3.copyWith(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(
              width: 8,
            ),
            SvgPicture.asset(
              svg,
              height: 22,
              width: 40,
              color: theme.themeId != "BLUE"
                  ? Colors.white
                  : theme.BreezColors.white[400],
            )
          ],
        ),
        Text(label)
      ],
    );
  }
}

class _PodcastListTile extends StatelessWidget {
  final String title;
  final String sats;
  final String boostagrams;
  final double durationInMins;
  final String imageUrl;
  const _PodcastListTile(
      {Key key,
      this.title,
      this.sats,
      this.boostagrams,
      this.durationInMins,
      this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: theme.themeId != "BLUE"
            ? Theme.of(context).backgroundColor
            : theme.podcastHistoryTileBackGroundColorBlue,
        height: 100,
        child: Row(
          children: [
            CustomImageBuilderWidget(
              imageurl: imageUrl,
              width: 100,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8, left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline3
                            .copyWith(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(_podcastListingTimeString(
                                    podcastListeningTimeMap:
                                        _podcastListingTimeMap(
                                            durationInMins: durationInMins)))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.rocket_launch_outlined,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(boostagrams + " Boostagrams")
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            "$sats sats",
                            style: Theme.of(context)
                                .primaryTextTheme
                                .headline3
                                .copyWith(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Map<String, String> _podcastListingTimeMap({double durationInMins}) {
  if (durationInMins < 1) {
    return {
      "value": "${_truncateDecimals(durationInMins * 60, 2)}",
      "unit": "secs"
    };
  } else if (durationInMins >= 60) {
    return {
      "value": "${_truncateDecimals(durationInMins / 60, 2)}",
      "unit": "hours"
    };
  } else {
    return {"value": "${_truncateDecimals(durationInMins, 2)}", "unit": "mins"};
  }
}

String _podcastListingTimeString(
    {Map<String, String> podcastListeningTimeMap}) {
  return "${podcastListeningTimeMap["value"]} ${podcastListeningTimeMap["unit"]}";
}

//Converts the number into compact form (1000 to 1K)
String _getCompactNumber(num number) {
  return NumberFormat.compact().format(number);
}

num _truncateDecimals(num number, int decimalPlaces) =>
    (number * pow(10, decimalPlaces)).truncate() / pow(10, decimalPlaces);
