import 'dart:convert';
import 'dart:io';

import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lounge/bloc.dart';
import 'package:breez/bloc/lounge/actions.dart';
import 'package:breez/bloc/lounge/lounge_payments_bloc.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/lounge/enter_lounge_dialog.dart';
import 'package:breez/routes/lounge/lounges_list.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class Lounges extends StatefulWidget {
  @override
  _LoungesState createState() => _LoungesState();
}

class _LoungesState extends State<Lounges> {
  String currentLoungeID;
  LoungePaymentsBloc paymentsBloc;
  UserProfileBloc userProfileBloc;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      paymentsBloc = AppBlocsProvider.of<LoungePaymentsBloc>(context);
      userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
      _isInit = true;
    }
    super.didChangeDependencies();
  }

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
    LoungesBloc loungesBloc = AppBlocsProvider.of<LoungesBloc>(context);
    return Scaffold(
      backgroundColor: theme.customData[theme.themeId].dashboardBgColor,
      body: StreamBuilder(
          stream: loungesBloc.loungesStream,
          builder: (context, snapshot) {
            var lounges = snapshot.data;
            if (lounges == null) {
              return Center(child: Loader());
            }
            return LoungesList(lounges);
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
                      Navigator.of(context).pushNamed("/host_lounge"),
                  child: Text(
                    "HOST",
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
                  onPressed: () => _enterLoungeID(loungesBloc),
                  child: Text(
                    "ENTER",
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

  _enterLoungeID(LoungesBloc loungesBloc) async {
    Clipboard.getData("text/plain").then((clipboardData) {
      if (clipboardData != null) {
        var clipboard = clipboardData.text;
        if (clipboard.contains("Enter Lounge: ")) {
          _enterLounge(clipboard.substring(16), loungesBloc);
        } else {
          return showDialog(
              context: context,
              builder: (BuildContext context) => EnterLoungeDialog(
                  (loungeID) => _enterLounge(loungeID, loungesBloc)));
        }
      } else {
        return showDialog(
            context: context,
            builder: (BuildContext context) => EnterLoungeDialog(
                (loungeID) => _enterLounge(loungeID, loungesBloc)));
      }
    });
  }

  _enterLounge(String loungeID, LoungesBloc loungesBloc) async {
    var userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    var user = await userProfileBloc.userStream.firstWhere((u) => u != null);

    setState(() {
      currentLoungeID = loungeID;
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

    String paymentOptions = jsonEncode({
      "presetBoostAmountsList": user.loungePaymentOptions.presetBoostAmountsList,
      "presetSatsPerMinuteAmountsList": user.loungePaymentOptions.presetSatsPerMinuteAmountsList,
      "customBoostValue": user.loungePaymentOptions.customBoostValue,
      "customSatsPerMinAmountValue": user.loungePaymentOptions.customSatsPerMinValue,
      "selectedBoostAmountIndex": user.loungePaymentOptions.boostAmountList
          .indexOf(user.loungePaymentOptions.preferredBoostValue),
      "selectedSatsPerMinuteAmountIndex": user.loungePaymentOptions.satsPerMinuteIntervalsList
          .indexOf(user.loungePaymentOptions.preferredSatsPerMinValue),
    });

    // Define meetings options here
    var options = JitsiMeetingOptions(room: loungeID)
      ..userDisplayName = user.name
      ..userEmail = ""
      ..audioMuted = true
      ..videoMuted = true
      ..featureFlags.addAll(featureFlags)
      ..paymentOptions = paymentOptions
      ..isLightTheme = theme.themeId == "BLUE"
      ..webOptions = {
        "roomName": loungeID,
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
    var boostAmount = double.parse(message["boostAmount"]).toInt();
    var paymentInfo = message["paymentInfo"];
    paymentsBloc.actionsSink.add(PayBoost(boostAmount, "", currentLoungeID, paymentInfo));
  }

  void _changeSatsPerMinute(message) async {
    var user = await userProfileBloc.userStream.firstWhere((u) => u != null);
    var satsPerMinute = double.parse(message["satsPerMinute"]).toInt();
    paymentsBloc.actionsSink.add(AdjustAmount(satsPerMinute));
    userProfileBloc.userActionsSink.add(SetLoungePaymentOptions(user
        .loungePaymentOptions
        .copyWith(preferredSatsPerMinValue: satsPerMinute)));
  }

  void _setCustomBoostValue(message) async {
    var user = await userProfileBloc.userStream.firstWhere((u) => u != null);
    var customBoostValue = double.parse(message["customBoostValue"]).toInt();
    userProfileBloc.userActionsSink.add(SetLoungePaymentOptions(user
        .loungePaymentOptions
        .copyWith(customBoostValue: customBoostValue)));
  }

  void _setCustomSatsPerMinAmount(message) async {
    var user = await userProfileBloc.userStream.firstWhere((u) => u != null);
    var customSatsPerMinValue =
        double.parse(message["customSatsPerMinValue"]).toInt();
    userProfileBloc.userActionsSink.add(SetLoungePaymentOptions(user
        .loungePaymentOptions
        .copyWith(customSatsPerMinValue: customSatsPerMinValue)));
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
