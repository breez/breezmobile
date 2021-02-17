// Copyright 2020-2021 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:breez/bloc/podcast_payments/actions.dart';
import 'package:breez/bloc/podcast_payments/podcast_payments_bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    final paymentsBloc = Provider.of<PodcastPaymentsBloc>(context);

    return StreamBuilder<int>(
        stream: paymentsBloc.amountStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox();
          }

          final amount = snapshot.data;
          return Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 4.0,
              bottom: 4.0,
            ),
            child: Row(
              children: <Widget>[
                Text(_formatAmount(amount.toDouble())),
                Expanded(
                  child: Slider(
                    onChanged: (val) {
                      paymentsBloc.actionsSink.add(AdjustAmount(val.toInt()));
                    },
                    value: amount.toDouble(),
                    min: 0.0,
                    max: widget.total.toDouble(),
                    activeColor: Theme.of(context).buttonColor,
                  ),
                ),
              ],
            ),
          );
        });
  }

  String _formatAmount(double total) {
    return "${total.toInt()} Sats";
  }
}
