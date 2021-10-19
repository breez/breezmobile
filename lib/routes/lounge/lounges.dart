import 'dart:convert';
import 'dart:io';

import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/jitsi_meet/bloc.dart';
import 'package:breez/bloc/lounge/actions.dart';
import 'package:breez/bloc/lounge/bloc.dart';
import 'package:breez/bloc/lounge/lounge_payments_bloc.dart';
import 'package:breez/bloc/lounge/model.dart';
import 'package:breez/routes/lounge/enter_lounge_dialog.dart';
import 'package:breez/routes/lounge/lounges_list.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/flushbar.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

import 'host_lounge.dart';

class Lounges extends StatefulWidget {
  @override
  _LoungesState createState() => _LoungesState();
}

class _LoungesState extends State<Lounges> {
  LoungePaymentsBloc paymentsBloc;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      paymentsBloc = AppBlocsProvider.of<LoungePaymentsBloc>(context);
      _isInit = true;
    }
    super.didChangeDependencies();
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
                  onPressed: () => Navigator.of(context).push(FadeInRoute(
                    builder: (_) => HostLounge(
                        loungesBloc, (lounge) => _hostLounge(lounge, context)),
                  )),
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
          String loungeID = clipboard.substring(14);
          _onEnter(loungeID, loungesBloc);
        } else {
          return showDialog(
              useRootNavigator: false,
              context: context,
              builder: (BuildContext context) => EnterLoungeDialog(
                  (loungeID) => _onEnter(loungeID, loungesBloc)));
        }
      } else {
        return showDialog(
            useRootNavigator: false,
            context: context,
            builder: (BuildContext context) => EnterLoungeDialog(
                (loungeID) => _onEnter(loungeID, loungesBloc)));
      }
    });
  }

  _onEnter(String loungeID, LoungesBloc loungesBloc) async {
    List<Lounge> lounges =
        await loungesBloc.loungesStream.firstWhere((l) => l != null);
    Lounge lounge = lounges.firstWhere(
        (lounge) => (lounge.loungeID == loungeID && lounge.isHosted),
        orElse: () => null);
    if (lounge != null) {
      _hostLounge(lounge, context);
    } else {
      _enterLounge(loungeID, loungesBloc);
    }
  }

  _hostLounge(Lounge lounge, BuildContext context) async {
    var accountBloc = AppBlocsProvider.of<AccountBloc>(context);

    var user = await paymentsBloc.userProfile.userStream.firstWhere((u) => u != null);

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
    var options = JitsiMeetingOptions(room: lounge.loungeID)
      ..subject = lounge.title
      ..userDisplayName = user.name
      ..userEmail = "breez:" + await accountBloc.getPersistentNodeID()
      ..isLightTheme = theme.themeId == "BLUE"
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": lounge.loungeID,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": user.name}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(options);
  }

  _enterLounge(String loungeID, LoungesBloc loungesBloc) async {
    var user = await paymentsBloc.userProfile.userStream.firstWhere((u) => u != null);
    var jitsiMeetBloc = AppBlocsProvider.of<JitsiMeetBloc>(context);
    jitsiMeetBloc.currentLoungeSink.add(loungeID);

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
      "presetBoostAmountsList":
          user.loungePaymentOptions.presetBoostAmountsList,
      "presetSatsPerMinuteAmountsList":
          user.loungePaymentOptions.presetSatsPerMinuteAmountsList,
      "customBoostValue": user.loungePaymentOptions.customBoostValue,
      "customSatsPerMinAmountValue":
          user.loungePaymentOptions.customSatsPerMinValue,
      "selectedBoostAmountIndex": user.loungePaymentOptions.boostAmountList
          .indexOf(user.loungePaymentOptions.preferredBoostValue),
      "selectedSatsPerMinuteAmountIndex": user
          .loungePaymentOptions.satsPerMinuteIntervalsList
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
      await JitsiMeet.joinMeeting(options).then((value) async {
        List<Lounge> lounges =
            await loungesBloc.loungesStream.firstWhere((l) => l != null);
        Lounge lounge = lounges.firstWhere(
            (lounge) => lounge.loungeID == loungeID,
            orElse: () => null);
        if (lounge == null) {
          AddLounge addLounge = AddLounge(
            Lounge(loungeID: loungeID, title: loungeID, isHosted: false),
          );

          loungesBloc.actionsSink.add(addLounge);
          addLounge.future.then((_) {});
        }
      });
    } catch (e) {
      showFlushbar(context, message: e.message.toString());
    }
  }
}
