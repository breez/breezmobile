import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class BackgroundTaskService {
  static const _methodChannel =
      MethodChannel('com.breez.client/background_task');
  static const _eventsChannel =
      EventChannel('com.breez.client/background_task_notifications');

  Map<dynamic, Function()> _tasksCallbacks = Map<dynamic, Function()>();

  BackgroundTaskService() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      _eventsChannel.receiveBroadcastStream().listen((taskID) {
        var callback = _tasksCallbacks.remove(taskID);
        if (callback != null) {
          callback();
        }
      });
    }
  }

  Future<void> runAsTask(Future future, Function() onEnd) {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      future.whenComplete(onEnd);
      return Future.value(null);
    }

    return _methodChannel.invokeMethod("startBackgroundTask").then((taskID) {
      _tasksCallbacks[taskID] = onEnd;
      future.whenComplete(() {
        if (_tasksCallbacks.containsKey(taskID)) {
          _methodChannel.invokeMethod("stopBackgroundTask", {"taskID": taskID});
        }
      });
    });
  }
}
