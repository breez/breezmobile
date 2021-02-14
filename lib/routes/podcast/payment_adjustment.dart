// Copyright 2020-2021 Ben Hills. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class PaymentAdjustment extends StatefulWidget {
  final int total;

  const PaymentAdjustment({Key key, this.total}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaymentAdjustmentState();
  }
}

class PaymentAdjustmentState extends State<PaymentAdjustment> {
  double position = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 4.0,
        bottom: 4.0,
      ),
      child: Row(
        children: <Widget>[
          Text(_formatAmount(position)),
          Expanded(
            child: Slider(
              onChanged: (val) {
                setState(() {
                  position = val;
                });
              },
              value: position,
              min: 0.0,
              max: 1.0,
              activeColor: Theme.of(context).buttonColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double total) {
    return "${(widget.total.toDouble() * total).toInt()} Sats";
  }
}
