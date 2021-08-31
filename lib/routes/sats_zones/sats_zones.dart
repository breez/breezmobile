import 'dart:io';

import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/sats_zones/actions.dart';
import 'package:breez/bloc/sats_zones/bloc.dart';
import 'package:breez/bloc/sats_zones/sats_zone_payments_bloc.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/sats_zones/join_sats_zone_dialog.dart';
import 'package:breez/routes/sats_zones/sats_zones_list.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class SatsZones extends StatefulWidget {
  @override
  _SatsZonesState createState() => _SatsZonesState();
}

class _SatsZonesState extends State<SatsZones> {
  String currentZoneID;

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
    SatsZonesBloc satsZonesBloc = AppBlocsProvider.of<SatsZonesBloc>(context);
    return Scaffold(
      backgroundColor: theme.customData[theme.themeId].dashboardBgColor,
      body: StreamBuilder(
          stream: satsZonesBloc.satsZonesStream,
          builder: (context, snapshot) {
            var satsZones = snapshot.data;
            if (satsZones == null) {
              return Center(child: Loader());
            }
            return SatsZonesList(satsZones);
          }),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).bottomAppBarColor,
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/create_sats_zone"),
                  child: Text(
                    "CREATE",
                    textAlign: TextAlign.center,
                    style: theme.bottomAppBarBtnStyle.copyWith(
                        fontSize:
                            13.5 / MediaQuery.of(context).textScaleFactor),
                    maxLines: 1,
                  ),
                ),
              ),
              VerticalDivider(
                indent: 16,
                endIndent: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => _enterSatsZoneID(satsZonesBloc),
                  child: Text(
                    "JOIN",
                    textAlign: TextAlign.center,
                    style: theme.bottomAppBarBtnStyle.copyWith(
                        fontSize:
                            13.5 / MediaQuery.of(context).textScaleFactor),
                    maxLines: 1,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _enterSatsZoneID(SatsZonesBloc satsZonesBloc) async {
    Clipboard.getData("text/plain").then((clipboardData) {
      if (clipboardData != null) {
        var clipboard = clipboardData.text;
        if (clipboard.contains("Join Sats Zone: ")) {
          _joinSatsZone(clipboard.substring(16), satsZonesBloc);
        } else {
          return showDialog(
              context: context,
              builder: (BuildContext context) => JoinSatsZoneDialog(
                  (zoneID) => _joinSatsZone(zoneID, satsZonesBloc)));
        }
      } else {
        return showDialog(
            context: context,
            builder: (BuildContext context) => JoinSatsZoneDialog(
                (zoneID) => _joinSatsZone(zoneID, satsZonesBloc)));
      }
    });
  }

  _joinSatsZone(String zoneID, SatsZonesBloc satsZonesBloc) async {
    var userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    var user = await userProfileBloc.userStream.firstWhere((u) => u != null);

    setState(() {
      currentZoneID = zoneID;
    });
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
      ..userDisplayName = user.name
      ..audioMuted = true
      ..videoMuted = true
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
    try {
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
    } catch (e) {
      showFlushbar(context, message: e.message.toString());
    }
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
    paymentsBloc.actionsSink.add(PayBoost(boostAmount, "", currentZoneID, paymentInfo));
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
