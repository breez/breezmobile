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

import 'confetti.dart';

class PaymentAdjustment extends StatefulWidget {
  const PaymentAdjustment({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaymentAdjustmentState();
  }
}

class PaymentAdjustmentState extends State<PaymentAdjustment> {
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
                  color: Theme.of(context).brightness == Brightness.light
                      ? Color(0xFFf3f8fc)
                      : Color(0xFF152a3d),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: WithConfettyPaymentEffect(
                              type: PaymentEventType.BoostStarted,
                              child: BoostWidget(
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
                          height: 80,
                          width: 1,
                          child: VerticalDivider(
                            thickness: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        PaymentAdjuster(
                            userModel: userModel,
                            satsPerMinuteList:
                                paymentOptions.satsPerMinuteIntervalsList,
                            onChanged: (int satsPerMinute) {
                              paymentsBloc.actionsSink
                                  .add(AdjustAmount(satsPerMinute));
                              userProfileBloc.userActionsSink
                                  .add(SetSatsPerMinAmount(satsPerMinute));
                            }),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
