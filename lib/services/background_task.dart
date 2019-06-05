import 'package:flutter/services.dart';

class BackgroundTaskService{
  static const _methodChannel = const MethodChannel('com.breez.client/background_task');
  static const _eventsChannel = const EventChannel('com.breez.client/background_task_notifications');

  Map<dynamic, Function()> _tasksCallbacks = Map<dynamic, Function()>();

  BackgroundTaskService(){
    _eventsChannel.receiveBroadcastStream().listen((taskID){
      var callback = _tasksCallbacks.remove(taskID);
      if (callback != null) {        
        callback();
      }
    });
  }

  Future<void> runAsTask(Future future, Function() onEnd) {
    return _methodChannel.invokeMethod("startBackgroundTask")
      .then((taskID){
        _tasksCallbacks[taskID] = onEnd;
        future.whenComplete((){
          if (_tasksCallbacks.containsKey(taskID)) {
            _methodChannel.invokeMethod("stopBackgroundTask", {"taskID": taskID});          
          }
        });
      });
  }
}