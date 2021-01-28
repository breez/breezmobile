import 'dart:async';
import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/entities/episode.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:anytime/ui/widgets/transport_controls.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';

class PodcastPaymentsBloc with AsyncActionsHandler {
  final _listeningTime = Map<String, int>();
  final AudioBloc audioBloc;
  BreezBridge _breezLib;
  Timer _paymentTimer;

  PodcastPaymentsBloc(this.audioBloc) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    listenAudioState();
  }

  void listenAudioState() {
    Rx.combineLatest2(
        audioBloc.playingState,
        audioBloc.nowPlaying,
        (AudioState audioState, Episode episode) =>
            PlayerControlState(audioState, episode, null)).listen((event) {
      _stopPaymentTimer();
      if (event.audioState == AudioState.playing) {
        startPaymentTimer(event.episode);
      }
    });
  }

  void startPaymentTimer(Episode episode) {
    _paymentTimer = Timer.periodic(Duration(seconds: 10), (t) {
      var currentDuration = _listeningTime[episode.contentUrl] ?? 0 + 10;
      _listeningTime[episode.contentUrl] = currentDuration;
      if (currentDuration % 60 == 0) {
        print(
            "sending payment for episode ${episode.contentUrl}, duration: $currentDuration");
        //_breezLib.sendSpontaneousPayment(destNode, amount, description)
      }
    });
  }

  void _stopPaymentTimer() {
    _paymentTimer?.cancel();
  }
}
