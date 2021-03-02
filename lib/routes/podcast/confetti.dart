import 'dart:async';

import 'package:breez/bloc/podcast_payments/model.dart';
import 'package:breez/bloc/podcast_payments/podcast_payments_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class Confetty extends StatelessWidget {
  final ConfettiController controller;
  const Confetty({Key key, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      maxBlastForce: 50, // set a lower max blast force
      minBlastForce: 5, // set a lower min blast force
      emissionFrequency: 0.01,
      numberOfParticles: 100,
      confettiController: controller,
      blastDirection: pi * 1.75,
      shouldLoop: false, // start again as soon as the animation is finished
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple
      ], // manually specify the colors to be used
    );
  }
}

class WithConfettyPaymentEffect extends StatefulWidget {
  final Widget child;
  final PaymentEventType type;

  const WithConfettyPaymentEffect({Key key, this.child, this.type})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WithConfettyPaymentEffectState();
  }
}

class WithConfettyPaymentEffectState extends State<WithConfettyPaymentEffect> {
  ConfettiController controller =
      ConfettiController(duration: Duration(seconds: 1));
  StreamSubscription<PaymentEvent> subscription;

  @override
  void initState() {
    super.initState();
    final paymentsBloc =
        Provider.of<PodcastPaymentsBloc>(context, listen: false);
    subscription = paymentsBloc.paymentEventsStream.listen((event) {
      if (event.type == widget.type) {
        controller.play();
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentsBloc = Provider.of<PodcastPaymentsBloc>(context);
    return StreamBuilder<Object>(
        stream: paymentsBloc.paymentEventsStream,
        builder: (context, snapshot) {
          return Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Confetty(controller: controller)),
              widget.child,
            ],
          );
        });
  }
}
