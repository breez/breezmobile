// Copyright 2020-2021 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:breez/bloc/podcast_payments/actions.dart';
import 'package:breez/bloc/podcast_payments/podcast_payments_bloc.dart';
import 'package:breez/routes/podcast/boost.dart';
import 'package:breez/routes/podcast/payment_adjuster.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentAdjustment extends StatefulWidget {
  final int total;

  const PaymentAdjustment({Key key, this.total}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaymentAdjustmentState();
  }
}

class PaymentAdjustmentState extends State<PaymentAdjustment> {
  Map<int, String> boostAmountMap = {
    500: '500',
    1000: '1K',
    5000: '5K',
    10000: '10K',
    50000: '50K',
  };

  @override
  Widget build(BuildContext context) {
    final paymentsBloc = Provider.of<PodcastPaymentsBloc>(context);

    return StreamBuilder<int>(
      stream: paymentsBloc.amountStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 4.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BoostWidget(
                amountList: boostAmountMap.values.toList(),
                onBoost: (String value) {
                  int boostAmount = boostAmountMap.keys.firstWhere(
                      (element) => boostAmountMap[element] == value);
                  paymentsBloc.actionsSink.add(PayBoost(boostAmount));
                },
              ),
              PaymentAdjuster(
                  amountList: boostAmountMap.values.toList(),
                  onChanged: (String value) {
                    int boostAmount = boostAmountMap.keys.firstWhere(
                        (element) => boostAmountMap[element] == value);
                    paymentsBloc.actionsSink.add(AdjustAmount(boostAmount));
                  }),
            ],
          ),
        );
      },
    );
  }
}
