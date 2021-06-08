import 'dart:io';

import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/sats_rooms/actions.dart';
import 'package:breez/bloc/sats_rooms/bloc.dart';
import 'package:breez/bloc/sats_rooms/model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:share_extend/share_extend.dart';

class SatsRoomItem extends StatelessWidget {
  final SatsRoom satsRoom;

  const SatsRoomItem(this.satsRoom);

  @override
  Widget build(BuildContext context) {
    var userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

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
                  satsRoom.title,
                  style: Theme.of(context).accentTextTheme.subtitle2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  satsRoom.roomID,
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
                        SatsRoomsBloc satsRoomsBloc =
                            AppBlocsProvider.of<SatsRoomsBloc>(context);
                        DeleteSatsRoom deleteSatsRoom =
                            DeleteSatsRoom(satsRoom.id);
                        satsRoomsBloc.actionsSink.add(deleteSatsRoom);
                        deleteSatsRoom.future.then((_) {
                          showFlushbar(context,
                              duration: Duration(seconds: 4),
                              messageWidget: Text("Deleted " + satsRoom.title,
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
                            "Join Sats Room: " + satsRoom.roomID, "text",
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
                            _joinSatsRoom(satsRoom.roomID, userProfileBloc),
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

  _joinSatsRoom(String roomID, UserProfileBloc userProfileBloc) async {
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
      //..serverURL = null
      ..subject = satsRoom.title
      ..userDisplayName = user.name
      //..userEmail = emailText.text
      //..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      //..audioOnly = isAudioOnly
      //..audioMuted = isAudioMuted
      //..videoMuted = isVideoMuted
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
  }
}
