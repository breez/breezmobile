import 'dart:async';
import 'package:anytime/bloc/podcast/audio_bloc.dart';
import 'package:anytime/entities/episode.dart';
import 'package:anytime/repository/repository.dart';
import 'package:anytime/services/audio/audio_player_service.dart';
import 'package:anytime/ui/widgets/transport_controls.dart';
import 'package:breez/bloc/async_actions_handler.dart';
import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fixnum/fixnum.dart';

class _Destination {
  final String name;
  final String address;
  final double split;

  _Destination(this.name, this.address, this.split);
}

List<_Destination> _destinations = [
  _Destination(
      "Adam Curry (Podcaster)",
      "02d5c1bf8b940dc9cadca86d1b0a3c37fbe39cee4c7e839e33bef9174531d27f52",
      49.0),
  _Destination(
      "Dave Jones (Podcaster)",
      "032f4ffbbafffbe51726ad3c164a3d0d37ec27bc67b29a159b0f49ae8ac21b8508",
      44.0),
  _Destination(
      "Podcastindex.org (Platform\/Host\/etc.)",
      "03ae9f91a0cb8ff43840e3c322c4c61f019d8c1c3cea15a25cfc425ac605e61a4a",
      1.0),
];

class PodcastPaymentsBloc with AsyncActionsHandler {
  final _listeningTime = Map<String, int>();
  final AudioBloc audioBloc;
  final Repository repository;
  BreezBridge _breezLib;
  Timer _paymentTimer;

  PodcastPaymentsBloc(this.audioBloc, this.repository) {
    ServiceInjector injector = ServiceInjector();
    _breezLib = injector.breezBridge;
    listenAudioState();
  }

  void listenAudioState() {
    Rx.combineLatest2(
        audioBloc.playingState,
        audioBloc.nowPlaying,
        (AudioState audioState, Episode episode) =>
            PlayerControlState(audioState, episode)).listen((event) async {
      _stopPaymentTimer();
      if (event.audioState == AudioState.playing) {
        print("metadata" + event.episode.metadata?.toString());
        startPaymentTimer(event.episode);
      }
    });
  }

  void startPaymentTimer(Episode episode) {
    _paymentTimer = Timer.periodic(Duration(seconds: 10), (t) {
      var currentDuration = (_listeningTime[episode.contentUrl] ?? 0) + 10;
      _listeningTime[episode.contentUrl] = currentDuration;
      if (currentDuration % 60 == 0) {
        print(
            "sending payment for episode ${episode.contentUrl}, duration: $currentDuration");
        int total = 10;
        _destinations.forEach((d) {
          var amount = Int64((d.split * total / 100).floor()).toInt();
          if (amount > 0 && amount <= total) {
            _breezLib.sendSpontaneousPayment(d.address, Int64(amount), d.name,
                groupKey: episode.contentUrl, groupName: episode.title);
          }
        });
      }
    });
  }

  void _stopPaymentTimer() {
    _paymentTimer?.cancel();
  }
}
