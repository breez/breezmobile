import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:breez/bloc/status_indicator/status_update_model.dart';

class StatusIndicatorBloc {
  final _statusUpdateController = BehaviorSubject<StatusUpdateModel>();
  Sink<StatusUpdateModel> get statusUpdateSink => _statusUpdateController.sink;

  final _statusIndicatorUpdatesController = BehaviorSubject<String>();
  Stream<String> get statusIndicatorUpdatesStream =>
      _statusIndicatorUpdatesController.stream.asBroadcastStream();

  bool _showingMessage = false;
  StatusUpdatePriority _currentMessagePriority;

  StatusIndicatorBloc() {
    _listenStatusUpdates();
  }

  void _listenStatusUpdates() {
    _statusUpdateController.stream.listen((update) {
      if (update == null) {
        _blankOutStatusIndicator();
      } else {
        _statusIndicatorUpdatesController.add(update.message);
        _showingMessage = true;
        _currentMessagePriority = update.priority;
      }
    });
  }

  void _blankOutStatusIndicator() {
    _showingMessage = false;
    _statusIndicatorUpdatesController.add("");
  }

  close() {
    _statusUpdateController.close();
    _statusIndicatorUpdatesController.close();
  }
}
