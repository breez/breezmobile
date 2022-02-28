// Copyright 2020-2021 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/podcast_payments/actions.dart';
import 'package:breez/bloc/podcast_payments/model.dart';
import 'package:breez/bloc/podcast_payments/podcast_payments_bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/podcast/boost.dart';
import 'package:breez/routes/podcast/payment_adjuster.dart';
import 'package:breez/routes/podcast/theme.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'confetti.dart';

class PaymentAdjustment extends StatefulWidget {
  const PaymentAdjustment({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaymentAdjustmentState();
  }
}

class PaymentAdjustmentState extends State<PaymentAdjustment> {
  final GlobalKey boostWidgetKey = GlobalKey();
  final GlobalKey paymentAdjusterKey = GlobalKey();
  AutoSizeGroup tutorialOptionGroup = AutoSizeGroup();

  TutorialCoachMark tutorial;
  List<TargetFocus> targets = [];
  int tutorialStreamSats = 50;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(Duration(seconds: 1)).then((value) async {
        final userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
        final user = await userBloc.userStream.first;
        if (!user.seenTutorials.paymentStripTutorial) {
          _buildTutorial(user);
          tutorial.show();
          setState(() {});
        }
      });
    });
  }

  void _buildTutorial(BreezUserModel user) {
    tutorial = TutorialCoachMark(context,
        targets: targets,
        onClickOverlay: (t) {
          if (t.keyTarget == boostWidgetKey) {
            tutorial.next();
          }
        },
        onClickTarget: (t) {
          if (t.keyTarget != paymentAdjusterKey) {
            tutorial.next();
          }
        },
        colorShadow: Theme.of(context).primaryColor,
        hideSkip: true,
        onFinish: () {
          final userBloc = AppBlocsProvider.of<UserProfileBloc>(context);
          userBloc.userActionsSink.add(SetSeenPaymentStripTutorial(true));
        });
    _buildTutorialTargets(user);
  }

  void _buildTutorialTargets(BreezUserModel user) {
    final texts = AppLocalizations.of(context);
    final theme = Theme.of(context);
    targets.add(TargetFocus(
      identify: "BoostWidget",
      keyTarget: boostWidgetKey,
      shape: ShapeLightFocus.RRect,
      radius: 4,
      paddingFocus: 8,
      enableOverlayTab: true,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Boost",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Send a one-time tip to a show's creators. Long press to add a personalized message.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ))
      ],
    ));
    targets.add(TargetFocus(
      identify: "PaymentAdjuster",
      keyTarget: paymentAdjusterKey,
      shape: ShapeLightFocus.RRect,
      radius: 4,
      paddingFocus: 4,
      enableTargetTab: false,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Stream sats",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Stream sats to the creators while listening to their show. The number indicates the amount of sats sent per minute. To listen for free, set this value to 0.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                StatefulBuilder(builder: (context, changeState) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _tutorialOption(0, changeState),
                        _tutorialOption(10, changeState),
                        _tutorialOption(25, changeState),
                        _tutorialOption(50, changeState),
                        _tutorialOption(100, changeState),
                      ],
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: withBreezTheme(
                      context,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        child: Text(
                          texts.tutorial_gotcha,
                          style: theme
                              .primaryTextTheme
                              .button
                              .copyWith(color: theme.primaryColor),
                        ),
                        onPressed: () {
                          AppBlocsProvider.of<UserProfileBloc>(context)
                              .userActionsSink
                              .add(SetPaymentOptions(user.paymentOptions
                                  .copyWith(
                                      preferredSatsPerMinValue:
                                          tutorialStreamSats)));
                          tutorial.finish();
                        },
                      )),
                ),
              ],
            ))
      ],
    ));
  }

  Widget _tutorialOption(int sats, Function(Function()) changeState) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.only(right: 6.0, left: 6.0),
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              side: tutorialStreamSats == sats
                  ? BorderSide(
                      width: 2.0,
                      color: Colors.white,
                    )
                  : BorderSide(color: Colors.grey, width: 1.0),
            ),
            onPressed: () {
              changeState(() {
                tutorialStreamSats = sats;
              });
            },
            child: Container(
              child: Center(
                child: AutoSizeText(sats.toString(),
                    minFontSize: 0.1,
                    stepGranularity: 0.1,
                    maxLines: 1,
                    group: tutorialOptionGroup,
                    style: TextStyle(color: Colors.white)),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paymentsBloc = Provider.of<PodcastPaymentsBloc>(context);
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    return WillPopScope(
      onWillPop: () {
        tutorial?.skip();
        return Future.value(true);
      },
      child: StreamBuilder<BreezUserModel>(
        stream: userProfileBloc.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Loader());
          }
          var userModel = snapshot.data;
          return Container(
            height: 64,
            color: Theme.of(context).backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 0),
                    child: WithConfettyPaymentEffect(
                        type: PaymentEventType.BoostStarted,
                        child: BoostWidget(
                          key: boostWidgetKey,
                          userModel: userModel,
                          onBoost: (int boostAmount, {String boostMessage}) {
                            paymentsBloc.actionsSink.add(PayBoost(
                              boostAmount,
                              boostMessage: boostMessage,
                              senderName: userModel.name,
                            ));
                          },
                          onChanged: (int boostAmount) {
                            userProfileBloc.userActionsSink.add(
                                SetPaymentOptions(userModel.paymentOptions
                                    .copyWith(
                                        preferredBoostValue: boostAmount)));
                          },
                        )),
                  ),
                ),
                Container(
                  height: 64,
                  width: 1,
                  child: VerticalDivider(
                    thickness: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Center(
                      child: PaymentAdjuster(
                          key: paymentAdjusterKey,
                          userModel: userModel,
                          onChanged: (int satsPerMinute) {
                            paymentsBloc.actionsSink
                                .add(AdjustAmount(satsPerMinute));
                            userProfileBloc.userActionsSink.add(
                                SetPaymentOptions(userModel.paymentOptions
                                    .copyWith(
                                        preferredSatsPerMinValue:
                                            satsPerMinute)));
                          }),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
