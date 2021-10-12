import 'dart:io';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lounge/actions.dart';
import 'package:breez/bloc/lounge/bloc.dart';
import 'package:breez/bloc/lounge/model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:share_extend/share_extend.dart';

class LoungeItem extends StatefulWidget {
  final Lounge lounge;

  const LoungeItem(this.lounge);

  @override
  _LoungeItemState createState() => _LoungeItemState();
}

class _LoungeItemState extends State<LoungeItem> {
  final GlobalKey _menuKey = new GlobalKey();

  @override
  void initState() {
    super.initState();

    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PopupMenuButton(
            key: _menuKey,
            color: Theme.of(context).highlightColor,
            offset: Offset(12, 24),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            itemBuilder: (_) => <PopupMenuItem>[
              PopupMenuItem(
                padding: EdgeInsets.only(left: 8, right: 0),
                child: TextButton.icon(
                  label: Text(
                    "Delete Lounge",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  icon: Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    LoungesBloc loungesBloc =
                        AppBlocsProvider.of<LoungesBloc>(context);
                    DeleteLounge deleteLounge =
                        DeleteLounge(widget.lounge.id);
                    loungesBloc.actionsSink.add(deleteLounge);
                    deleteLounge.future.then((_) {
                      showFlushbar(context,
                          duration: Duration(seconds: 4),
                          messageWidget: Text(
                              "Deleted " + widget.lounge.title,
                              style: theme.snackBarStyle,
                              textAlign: TextAlign.center));
                    });
                  },
                ),
              ),
            ],
            child: Theme(
              data: ThemeData(
                highlightColor: theme.customData[theme.themeId].paymentListBgColor,
                splashColor: theme.customData[theme.themeId].paymentListBgColor,
              ),
              child: ListTile(
                tileColor: theme.customData[theme.themeId].paymentListBgColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                title: Text(
                  widget.lounge.title,
                  style: Theme.of(context).accentTextTheme.subtitle2,
                  overflow: TextOverflow.ellipsis,
                ),
                onLongPress: () {
                  dynamic popUpMenuState = _menuKey.currentState;
                  popUpMenuState.showButtonMenu();
                },
                subtitle: Text(
                  widget.lounge.loungeID,
                  style: Theme.of(context).accentTextTheme.caption,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.share_outlined,
                        color: theme.BreezColors.blue[500],
                        size: 22,
                      ),
                      onPressed: () {
                        final RenderBox box = context.findRenderObject();
                        ShareExtend.share(
                            "Join Lounge: " + widget.lounge.loungeID,
                            "text",
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) &
                                    box.size);
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
                            _enterLounge(widget.lounge.loungeID, context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _enterLounge(String loungeID, BuildContext context) async {
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
    var options = JitsiMeetingOptions(room: loungeID)
      ..subject = widget.lounge.title
      ..userDisplayName = user.name
      ..userEmail = "breez:" + await accountBloc.getPersistentNodeID()
      ..isLightTheme = theme.themeId == "BLUE"
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": loungeID,
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

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
