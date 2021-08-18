import 'dart:io';

import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/sats_rooms/bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/sats_rooms/join_sats_room_dialog.dart';
import 'package:breez/routes/sats_rooms/sats_rooms_list.dart';
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
  @override
  Widget build(BuildContext context) {
    SatsZoneBloc satsRoomsBloc = AppBlocsProvider.of<SatsZoneBloc>(context);
    return Scaffold(
      backgroundColor: theme.customData[theme.themeId].dashboardBgColor,
      body: StreamBuilder(
          stream: satsRoomsBloc.satsZonesStream,
          builder: (context, snapshot) {
            var satsRooms = snapshot.data;
            if (satsRooms == null) {
              return Center(child: Loader());
            }
            return SatsZonesList(satsRooms);
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
                      Navigator.of(context).pushNamed("/create_sats_room"),
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
                  onPressed: () => _enterSatsRoomID(satsRoomsBloc),
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

  _enterSatsRoomID(SatsZoneBloc satsRoomsBloc) async {
    Clipboard.getData("text/plain").then((clipboardData) {
      if (clipboardData != null) {
        var clipboard = clipboardData.text;
        if (clipboard.contains("Join Sats Room: ")) {
          _joinSatsRoom(clipboard.substring(16), satsRoomsBloc);
        } else {
          return showDialog(
              context: context,
              builder: (BuildContext context) => JoinSatsZoneDialog(
                  (roomID) => _joinSatsRoom(roomID, satsRoomsBloc)));
        }
      } else {
        return showDialog(
            context: context,
            builder: (BuildContext context) => JoinSatsZoneDialog(
                (roomID) => _joinSatsRoom(roomID, satsRoomsBloc)));
      }
    });
  }

  _joinSatsRoom(String roomID, SatsZoneBloc satsRoomsBloc) async {
    var userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
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
    var options = JitsiMeetingOptions(room: roomID)
      ..userDisplayName = user.name
      ..audioMuted = true
      ..videoMuted = true
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": roomID,
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
}
