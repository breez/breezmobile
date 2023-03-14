import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:anytime/bloc/podcast/podcast_bloc.dart';
import 'package:anytime/entities/podcast.dart';
import 'package:anytime/ui/podcast/podcast_details.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/podcast_history/actions.dart';
import 'package:breez/bloc/podcast_history/model.dart';
import 'package:breez/bloc/podcast_history/podcast_history_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/utils/min_font_size.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/network_image_builder.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:breez_translations/generated/breez_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

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
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Future<void> didChangeDependencies() async {
    final podcastHistoryBloc = AppBlocsProvider.of<PodcastHistoryBloc>(context);
    PodcastHistoryTimeRange timeRange =
        await podcastHistoryBloc.getPodcastHistoryTimeRageFromLocalDb();

    podcastHistoryBloc.fetchPodcastHistory(
        startDate: timeRange.startDate, endDate: timeRange.endDate);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final podcastHistoryBloc = AppBlocsProvider.of<PodcastHistoryBloc>(context);
    return StreamBuilder<PodcastHistoryTimeRange>(
        stream: podcastHistoryBloc.posReportRange.distinct(),
        initialData: PodcastHistoryTimeRange.monthly(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final timeRange =
                snapshot.data ?? PodcastHistoryTimeRange.monthly();

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
        automaticallyImplyLeading: false,
        leading: const backBtn.BackButton(),
        title: Text(_getAppBarDisplayString(timeRange, context)),
        actions: [
          PopupMenuButton<PodcastHistoryTimeRange>(
            color: themeData.canvasColor,
            icon: SvgPicture.asset(
              "src/icon/calendar.svg",
              colorFilter: ColorFilter.mode(
                themeData.iconTheme.color,
                BlendMode.srcATop,
              ),
              width: 24.0,
              height: 24.0,
            ),
            onSelected: (value) {
              AppBlocsProvider.of<PodcastHistoryBloc>(context)
                  .actionsSink
                  .add(UpdatePodcastHistoryTimeRange(value));
            },
            itemBuilder: (ctx) => [
              PodcastHistoryTimeRange.weekly(),
              PodcastHistoryTimeRange.monthly(),
              PodcastHistoryTimeRange.yearly(),
            ].map((e) => _timeRangeDropdownItem(context, e)).toList(),
          )
        ],
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: podcastHistoryBloc.showShareButton,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          return snapshot.data
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    await _screenshotController
                        .captureFromWidget(
                            Container(
                              color: themeData.canvasColor,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 16, left: 16, right: 16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    SvgPicture.asset(
                                      "src/images/logo-color.svg",
                                      width:
                                          (MediaQuery.of(context).size.width) /
                                              6,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcATop,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    Center(
                                      child: Text(
                                        "My ${_getAppBarDisplayString(timeRange, context)}",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .displaySmall
                                            .copyWith(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 32,
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
                        await Share.shareXFiles([XFile(imagePath.path)],
                            text: "My ${_getAppBarDisplayString(timeRange, context)} in Breez ⚡ Download here: https://breez.technology");
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.share_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    BreezTranslations.of(context).podcast_history_share_text,
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : const SizedBox();
        },
      ),
      body: StreamBuilder<bool>(
          stream: podcastHistoryBloc.showShareButton,
          builder: (context, isListEmptySnapshot) {
            if (!isListEmptySnapshot.hasData) {
              return const Center(child: Loader());
            }

            return isListEmptySnapshot.data
                ? SingleChildScrollView(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder<PodcastHistoryRecord>(
                              stream: podcastHistoryBloc.podcastHistoryRecord,
                              initialData: PodcastHistoryRecord(
                                  totalBoostagramSentSum: 0,
                                  totalDurationInMinsSum: 0,
                                  totalSatsStreamedSum: 0,
                                  podcastHistoryList: []),
                              builder: (context, snapshot) {
                                return snapshot.data != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _PodcastStatItem(
                                              svg: "src/icon/schedule_icon.svg",
                                              label:
                                                  '${_podcastListingTimeMap(durationInMins: snapshot.data.totalDurationInMinsSum)["unit"]} listened',
                                              value: _podcastListingTimeMap(
                                                      durationInMins: snapshot
                                                          .data
                                                          .totalDurationInMinsSum)[
                                                  "value"]),
                                          _PodcastStatItem(
                                            svg: "src/icon/satoshi_icon.svg",
                                            label: BreezTranslations.of(context)
                                                .podcast_history_sats_streamed,
                                            value: _getCompactNumber(snapshot
                                                .data.totalSatsStreamedSum),
                                          ),
                                          _PodcastStatItem(
                                            svg:
                                                "src/icon/rocket_launch_icon.svg",
                                            label: BreezTranslations.of(context)
                                                .podcast_history_boostagrams_sent,
                                            value: _getCompactNumber(snapshot
                                                .data.totalBoostagramSentSum),
                                          ),
                                        ],
                                      )
                                    : const SizedBox();
                              }),
                          const SizedBox(
                            height: 16,
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("PODCASTS"),
                              const Spacer(),
                              PopupMenuButton<PodcastHistorySortEnum>(
                                color: themeData.canvasColor,
                                padding: const EdgeInsets.all(0),
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
                                      .updateSortOption(value);
                                },
                                itemBuilder: (ctx) => [
                                  PodcastHistorySortEnum.SORT_RECENTLY_HEARD,
                                  PodcastHistorySortEnum
                                      .SORT_DURATION_DESCENDING,
                                  PodcastHistorySortEnum.SORT_SATS_DESCENDING,
                                  PodcastHistorySortEnum.SORT_BOOSTS_DESCENDING,
                                ]
                                    .map((e) => _listSortDropdownItem(
                                          context,
                                          e,
                                        ))
                                    .toList(),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          _getPodcastHistoryList(
                              context: context,
                              getScreenshotWidget: false,
                              timeRange: timeRange),
                          const SizedBox(
                            height: 40,
                          )
                        ],
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Positioned(
                        child: CustomPaint(
                            painter: _BubblePainterPodcastHistory(context)),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AutoSizeText(
                              BreezTranslations.of(context)
                                  .podcast_history_empty_text,
                              style: themeData.statusTextStyle
                                  .copyWith(color: Colors.white),
                              textAlign: TextAlign.center,
                              minFontSize: MinFontSize(context).minFontSize,
                              stepGranularity: 0.1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height / 25,
                                  top: MediaQuery.of(context).size.height /
                                      2.82),
                              child: SubmitButton(
                                  BreezTranslations.of(context)
                                      .podcast_history_open_podcast_button, () {
                                Navigator.of(context).pop();
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
          }),
    );
  }
}

Widget _getPodcastHistoryList(
    {BuildContext context,
    bool getScreenshotWidget,
    PodcastHistoryTimeRange timeRange}) {
  final podcastHistoryBloc = AppBlocsProvider.of<PodcastHistoryBloc>(context);

  return StreamBuilder<PodcastHistoryRecord>(
      stream: podcastHistoryBloc.podcastHistoryRecord,
      builder: (context, podcastHistoryListSnapshot) {
        if (podcastHistoryListSnapshot.data != null) {
          //This enables sharing of up to 5 podcasts
          int podcastHistoryLength = 0;
          if (getScreenshotWidget) {
            podcastHistoryLength =
                podcastHistoryListSnapshot.data.podcastHistoryList.length <= 5
                    ? podcastHistoryListSnapshot.data.podcastHistoryList.length
                    : 5;
          } else {
            podcastHistoryLength =
                podcastHistoryListSnapshot.data.podcastHistoryList.length;
          }

          return Column(
            mainAxisSize:
                getScreenshotWidget ? MainAxisSize.min : MainAxisSize.max,
            children: [
              for (var i = 0; i < podcastHistoryLength; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PodcastListTile(
                      podcastUrl: podcastHistoryListSnapshot
                          .data.podcastHistoryList[i].podcastUrl,
                      title: podcastHistoryListSnapshot
                          .data.podcastHistoryList[i].podcastName,
                      sats: _getCompactNumber(podcastHistoryListSnapshot
                          .data.podcastHistoryList[i].satsSpent),
                      boostagrams: _getCompactNumber(podcastHistoryListSnapshot
                          .data.podcastHistoryList[i].boostagramsSent),
                      durationInMins: podcastHistoryListSnapshot
                          .data.podcastHistoryList[i].durationInMins,
                      imageUrl: podcastHistoryListSnapshot
                          .data.podcastHistoryList[i].podcastImageUrl),
                ),
            ],
          );
        } else {
          return const Center(child: Loader());
        }
      });
}

String _getAppBarDisplayString(
  PodcastHistoryTimeRange timeRange,
  BuildContext context,
) {
  final texts = context.texts();
  String title;

  if (timeRange is PodcastHistoryTimeRangeWeekly) {
    title = texts.podcast_history_appbar_top_weekly;
  } else if (timeRange is PodcastHistoryTimeRangeMonthly) {
    title = texts.podcast_history_appbar_top_monthly;
  } else if (timeRange is PodcastHistoryTimeRangeYearly) {
    title = texts.podcast_history_appbar_top_yearly;
  } else {
    title = "";
  }
  return title;
}

PopupMenuEntry<PodcastHistoryTimeRange> _timeRangeDropdownItem(
  BuildContext context,
  PodcastHistoryTimeRange timeRange,
) {
  final texts = context.texts();
  final themeData = Theme.of(context);

  String title;
  if (timeRange is PodcastHistoryTimeRangeWeekly) {
    title = texts.podcast_history_timerange_dropdown_week;
  } else if (timeRange is PodcastHistoryTimeRangeMonthly) {
    title = texts.podcast_history_timerange_dropdown_month;
  } else if (timeRange is PodcastHistoryTimeRangeYearly) {
    title = texts.podcast_history_timerange_dropdown_year;
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

PopupMenuEntry<PodcastHistorySortEnum> _listSortDropdownItem(
  BuildContext context,
  PodcastHistorySortEnum sortOption,
) {
  final themeData = Theme.of(context);
  final texts = context.texts();
  String title;
  if (sortOption == PodcastHistorySortEnum.SORT_RECENTLY_HEARD) {
    title = texts.podcast_history_sort_dropdown_recent;
  } else if (sortOption == PodcastHistorySortEnum.SORT_DURATION_DESCENDING) {
    title = texts.podcast_history_sort_dropdown_duration;
  } else if (sortOption == PodcastHistorySortEnum.SORT_SATS_DESCENDING) {
    title = texts.podcast_history_sort_dropdown_sats;
  } else if (sortOption == PodcastHistorySortEnum.SORT_BOOSTS_DESCENDING) {
    title = texts.podcast_history_sort_dropdown_boosts;
  } else {
    title = "";
  }

  return PopupMenuItem<PodcastHistorySortEnum>(
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: SvgPicture.asset(
            svg,
            height: 16,
            width: 36,
            colorFilter: ColorFilter.mode(
              theme.themeId != "BLUE"
                  ? Colors.white
                  : theme.BreezColors.white[400],
              BlendMode.srcATop,
            ),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).primaryTextTheme.displaySmall.copyWith(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(label)
          ],
        ),
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
  final String podcastUrl;

  const _PodcastListTile(
      {Key key,
      this.title,
      this.sats,
      this.boostagrams,
      this.durationInMins,
      this.imageUrl,
      this.podcastUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: theme.themeId != "BLUE"
            ? Theme.of(context).colorScheme.background
            : theme.podcastHistoryTileBackGroundColorBlue,
        height: 100,
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => PodcastDetails(
                      Podcast.fromUrl(url: podcastUrl),
                      Provider.of<PodcastBloc>(
                        context,
                        listen: false,
                      ),
                    ),
                  ),
                  ModalRoute.withName('/'),
                );
              },
              child: CustomImageBuilderWidget(
                imageurl: imageUrl,
                width: 100,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .displaySmall
                            .copyWith(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.schedule,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(_podcastListingTimeString(
                                    podcastListeningTimeMap:
                                        _podcastListingTimeMap(
                                            durationInMins: durationInMins)))
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.rocket_launch_outlined,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text("$boostagrams boosts")
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
                                .displaySmall
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
    return {"value": "${(durationInMins * 60).toInt()}", "unit": "secs"};
  } else if (durationInMins >= 60) {
    return {
      "value": "${_truncateDecimals(durationInMins / 60, 2)}",
      "unit": "hours"
    };
  } else {
    return {"value": "${(durationInMins).toInt()}", "unit": "mins"};
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

class _BubblePainterPodcastHistory extends CustomPainter {
  final BuildContext context;

  const _BubblePainterPodcastHistory(
    this.context,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final size = MediaQuery.of(context).size;
    final bubblePaint = Paint()
      ..color = theme.themeId == "BLUE"
          ? Colors.white.withOpacity(0.3)
          : const Color(0xff4D88EC).withOpacity(0.2)
      ..style = PaintingStyle.fill;
    const bubbleRadius = 12.0;
    final height = size.height - kToolbarHeight;
    canvas.drawCircle(
      Offset(size.width * 0.39, height * 0.2),
      bubbleRadius * 1.75,
      bubblePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, height * 0.1),
      bubbleRadius * 1.5,
      bubblePaint,
    );
    canvas.drawCircle(
      Offset(size.width / 2, height * 0.36),
      bubbleRadius,
      bubblePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.39, height * 0.59),
      bubbleRadius * 1.5,
      bubblePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.65, height * 0.71),
      bubbleRadius * 1.25,
      bubblePaint,
    );
    canvas.drawCircle(
      Offset(size.width / 2, height * 0.80),
      bubbleRadius * 0.75,
      bubblePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
