// Copyright 2020-2021 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/podcast_payments/actions.dart';
import 'package:breez/bloc/podcast_payments/model.dart';
import 'package:breez/bloc/podcast_payments/payment_options.dart';
import 'package:breez/bloc/podcast_payments/podcast_payments_bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/podcast/boost.dart';
import 'package:breez/routes/podcast/payment_adjuster.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';
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

  TutorialCoachMark tutorial;
  List<TargetFocus> targets = [];

  @override
  void initState() {
    super.initState();
    postInit(() {
      _buildTutorial();
      tutorial.show();
    });
  }

  void _buildTutorial() {
    tutorial = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Theme.of(context).primaryColor,
      hideSkip: true,
    );
    _buildTutorialTargets();
  }

  void _buildTutorialTargets() {
    targets.add(TargetFocus(
      identify: "BoostWidget",
      keyTarget: boostWidgetKey,
      shape: ShapeLightFocus.RRect,
      radius: 4,
      paddingFocus: 8,
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Boost Title",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Boost Description",
                    style: TextStyle(color: Colors.white),
                  ),
                )
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
      contents: [
        TargetContent(
            align: ContentAlign.top,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Payment Adjuster Title",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Payment Adjuster Description",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final paymentsBloc = Provider.of<PodcastPaymentsBloc>(context);
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    return StreamBuilder<PaymentOptions>(
        stream: paymentsBloc.paymentOptionsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Loader());
          }

          var paymentOptions = snapshot.data;

          return StreamBuilder<BreezUserModel>(
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 0),
                        child: WithConfettyPaymentEffect(
                            type: PaymentEventType.BoostStarted,
                            child: BoostWidget(
                              key: boostWidgetKey,
                              userModel: userModel,
                              boostAmountList: paymentOptions.boostAmountList,
                              onBoost: (int boostAmount) {
                                paymentsBloc.actionsSink
                                    .add(PayBoost(boostAmount));
                                userProfileBloc.userActionsSink
                                    .add(SetBoostAmount(boostAmount));
                              },
                            )),
                      ),
                      Container(
                        height: 64,
                        width: 1,
                        child: VerticalDivider(
                          thickness: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0, right: 0),
                        child: PaymentAdjuster(
                            key: paymentAdjusterKey,
                            userModel: userModel,
                            satsPerMinuteList:
                                paymentOptions.satsPerMinuteIntervalsList,
                            onChanged: (int satsPerMinute) {
                              paymentsBloc.actionsSink
                                  .add(AdjustAmount(satsPerMinute));
                              userProfileBloc.userActionsSink
                                  .add(SetSatsPerMinAmount(satsPerMinute));
                            }),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}

extension StateExtension<T extends StatefulWidget> on State<T> {
  Stream waitForStateLoading() async* {
    while (!mounted) {
      yield false;
    }
    yield true;
  }

  Future<void> postInit(VoidCallback action) async {
    await for (var isLoaded in waitForStateLoading()) {}
    action();
  }
}
