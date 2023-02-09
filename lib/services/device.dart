import 'dart:async';
import 'package:breez/logger.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NotificationType { RESUME, PAUSE }

class Device extends ClipboardListener {
  static const EventChannel _notificationsChannel =
      EventChannel('com.breez.client/lifecycle_events_notifications');

  final StreamController _eventsController =
      StreamController<NotificationType>.broadcast();
  Stream<NotificationType> get eventStream => _eventsController.stream;

  final _clipboardController = BehaviorSubject<String>();
  Stream<String> get clipboardStream => _clipboardController.stream.where((e) => e != _lastFromAppClip);

  static const String LAST_CLIPPING_PREFERENCES_KEY = "lastClipping";
  static const String LAST_FROM_APP_CLIPPING_PREFERENCES_KEY = "lastFromAppClipping";

  String _lastFromAppClip;

  Device() {
    log.finest("Initing Device");

    var sharedPreferences = SharedPreferences.getInstance();
    sharedPreferences.then((preferences) {
      _lastFromAppClip = preferences.getString(LAST_FROM_APP_CLIPPING_PREFERENCES_KEY);
      // Start with the last clipping of the previous session so we can avoid
      // triggering a repeat of the same action handled on the previous session.
      _clipboardController.add(preferences.getString(LAST_CLIPPING_PREFERENCES_KEY) ?? "");
      log.finest("Last clipping: $_lastFromAppClip");
      fetchClipboard(preferences);
    });
    clipboardWatcher.addListener(this);
    clipboardWatcher.start();

    _notificationsChannel.receiveBroadcastStream().listen((event) {
      log.finest("Received lifecycle event: $event");
      if (event == "resume") {
        _eventsController.add(NotificationType.RESUME);
      }
      if (event == "pause") {
        _eventsController.add(NotificationType.PAUSE);
      }
    });
  }

  Future setClipboardText(String text) async {
    log.finest("Setting clipboard text: $text");
    _lastFromAppClip = text;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(LAST_FROM_APP_CLIPPING_PREFERENCES_KEY, text);
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future shareText(String text) {
    log.finest("Sharing text: $text");
    return Share.share(text);
  }

  void fetchClipboard(SharedPreferences preferences) {
    log.finest("Fetching clipboard");
    Clipboard.getData("text/plain").then((clipboardData) {
      final text = clipboardData?.text;
      log.finest("Clipboard text: $text");
      if (text != null) {
        _clipboardController.add(text);
        preferences.setString(LAST_CLIPPING_PREFERENCES_KEY, text);
      }
    });
  }

  Future<String> appVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "${packageInfo.version}.${packageInfo.buildNumber}";
  }

  @override
  void onClipboardChanged() {
    log.finest("Clipboard changed");
    SharedPreferences.getInstance().then((preferences) {
      fetchClipboard(preferences);
    });
  }
}
