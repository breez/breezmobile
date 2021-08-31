import 'dart:io';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/sats_zones/actions.dart';
import 'package:breez/bloc/sats_zones/bloc.dart';
import 'package:breez/bloc/sats_zones/model.dart';
import 'package:breez/bloc/sats_zones/sats_zone_payments_bloc.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:share_extend/share_extend.dart';

class SatsZoneItem extends StatefulWidget {
  final SatsZone satsZone;

  const SatsZoneItem(this.satsZone);

  @override
  _SatsZoneItemState createState() => _SatsZoneItemState();
}

class _SatsZoneItemState extends State<SatsZoneItem> {

  @override
  void initState() {
    super.initState();

    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError,
        onBoost: _onBoost,
        changeSatsPerMinute: _changeSatsPerMinute,
        setCustomBoostAmount: _setCustomBoostValue,
        setCustomSatsPerMinAmount: _setCustomSatsPerMinAmount));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: theme.customData[theme.themeId].paymentListBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  widget.satsZone.title,
                  style: Theme.of(context).accentTextTheme.subtitle2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  widget.satsZone.zoneID,
                  style: Theme.of(context).accentTextTheme.caption,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        SatsZonesBloc satsZonesBloc =
                            AppBlocsProvider.of<SatsZonesBloc>(context);
                        DeleteSatsZone deleteSatsZone =
                            DeleteSatsZone(widget.satsZone.id);
                        satsZonesBloc.actionsSink.add(deleteSatsZone);
                        deleteSatsZone.future.then((_) {
                          showFlushbar(context,
                              duration: Duration(seconds: 4),
                              messageWidget: Text("Deleted " + widget.satsZone.title,
                                  style: theme.snackBarStyle,
                                  textAlign: TextAlign.center));
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share_outlined,
                        color: theme.BreezColors.blue[500],
                        size: 22,
                      ),
                      onPressed: () {
                        final RenderBox box = context.findRenderObject();
                        ShareExtend.share(
                            "Join Sats Zone: " + widget.satsZone.zoneID, "text",
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size);
                      },
                    ),
                    Tooltip(
                      message: "Join",
                      child: IconButton(
                        icon: Icon(
                          Icons.open_in_new,
                          color: theme.BreezColors.blue[500],
                          size: 22,
                        ),
                        onPressed: () =>
                            _joinSatsZone(widget.satsZone.zoneID, context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _joinSatsZone(String zoneID, BuildContext context) async {
    var userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    var accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    var user = await userProfileBloc.userStream.firstWhere((u) => u != null);

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: zoneID)
      //..serverURL = null
      ..subject = widget.satsZone.title
      ..userDisplayName = user.name
      ..userEmail = "breez:" + await accountBloc.getPersistentNodeID()
      //..userEmail = emailText.text
      //..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      //..audioOnly = isAudioOnly
      //..audioMuted = isAudioMuted
      //..videoMuted = isVideoMuted
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": zoneID,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": user.name}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
          },
          onBoost: (message) {
            debugPrint("Called onBoost with message: $message");
          },
          changeSatsPerMinute: (message) {
            debugPrint("Called changeSatsPerMinute with message: $message");
          },
          setCustomBoostAmount: (message) {
            debugPrint("Called setCustomBoostAmount");
          },
          setCustomSatsPerMinAmount: (message) {
            debugPrint("Called setCustomSatsPerMinAmount");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  void _onBoost(message) {
    final paymentsBloc = AppBlocsProvider.of<SatsZonePaymentsBloc>(context);
    var boostAmount = double.parse(message["boostAmount"]).toInt();
    var paymentInfo = message["paymentInfo"];
    paymentsBloc.actionsSink.add(PayBoost(boostAmount, widget.satsZone.title,
        widget.satsZone.zoneID, paymentInfo));
  }

  void _changeSatsPerMinute(message) async {
    final paymentsBloc = AppBlocsProvider.of<SatsZonePaymentsBloc>(context);
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    var user = await userProfileBloc.userStream.firstWhere((u) => u != null);
    var satsPerMinute = double.parse(message["satsPerMinute"]).toInt();
    paymentsBloc.actionsSink.add(AdjustAmount(satsPerMinute));
    userProfileBloc.userActionsSink.add(SetSatsZonePaymentOptions(user
        .satsZonePaymentOptions
        .copyWith(preferredSatsPerMinValue: satsPerMinute)));
  }

  void _setCustomBoostValue(message) async {
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    var user = await userProfileBloc.userStream.firstWhere((u) => u != null);
    var customBoostValue = double.parse(message["customBoostValue"]).toInt();
    userProfileBloc.userActionsSink.add(SetSatsZonePaymentOptions(user
        .satsZonePaymentOptions
        .copyWith(customBoostValue: customBoostValue)));
  }

  void _setCustomSatsPerMinAmount(message) async {
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    var user = await userProfileBloc.userStream.firstWhere((u) => u != null);
    var customSatsPerMinValue =
        double.parse(message["customSatsPerMinValue"]).toInt();
    userProfileBloc.userActionsSink.add(SetSatsZonePaymentOptions(user
        .satsZonePaymentOptions
        .copyWith(customSatsPerMinValue: customSatsPerMinValue)));
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
