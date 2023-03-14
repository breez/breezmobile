import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePathProviderPlatform extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  final basePath = "${Directory.current.path}/.dart_tool/fpp/${DateTime.now().millisecondsSinceEpoch}";

  Future<void> setUp() async {
    Directory(basePath).createSync(recursive: true);
    for (var path in [
      await getTemporaryPath(),
      await getApplicationSupportPath(),
      await getLibraryPath(),
      await getApplicationDocumentsPath(),
      await getExternalStoragePath(),
      await getDownloadsPath(),
    ]) {
      Directory(path).createSync(recursive: true);
    }
    for (var paths in [
      await getExternalCachePaths(),
      await getExternalStoragePaths(),
    ]) {
      for (var path in paths) {
        Directory(path).createSync(recursive: true);
      }
    }
  }

  Future<void> tearDown() async {
    Directory(basePath).deleteSync(recursive: true);
  }

  @override
  Future<String> getTemporaryPath() async => "$basePath/temporaryPath";

  @override
  Future<String> getApplicationSupportPath() async => "$basePath/applicationSupportPath";

  @override
  Future<String> getLibraryPath() async => "$basePath/libraryPath";

  @override
  Future<String> getApplicationDocumentsPath() async => "$basePath/applicationDocumentsPath";

  @override
  Future<String> getExternalStoragePath() async => "$basePath/externalStoragePath";

  @override
  Future<List<String>> getExternalCachePaths() async => ["$basePath/externalCachePath"];

  @override
  Future<List<String>> getExternalStoragePaths({StorageDirectory type}) async => ["$basePath/externalStoragePath"];

  @override
  Future<String> getDownloadsPath() async => "$basePath/downloadsPath";
}
