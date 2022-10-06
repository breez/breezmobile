import 'dart:io';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/csv_exporter.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final platform = _FakePathProviderPlatform();
  group('export', () {
    setUp(() async {
      await platform.setUp();
      PathProviderPlatform.instance = platform;
    });

    tearDown(() async {
      await platform.tearDown();
    });

    test('should create csv file', () async {
      final filePath = await _make().export();
      expect(filePath, isNotNull);
    });

    test('csv file should have header', () async {
      final filePath = await _make().export();
      final lines = await new File(filePath).readAsLines();
      expect(lines[0], "Date & Time,Title,Description,Node ID,Amount,Preimage,TX Hash,Fee,USD");
    });

    test('csv file should have item line', () async {
      final filePath = await _make().export();
      final lines = await new File(filePath).readAsLines();
      expect(lines[1], "9/13/2020 9:26 AM,A title,A description,A destination,1234,A preimage,A payment hash,5,10.0");
    });
  });
}

CsvExporter _make() {
  return CsvExporter(
    [
      CsvData(
        _CsvExporterTestStubPaymentInfo(),
        Sale(
          id: 1,
          saleLines: [
            SaleLine(
              id: 1,
              saleID: 1,
              itemID: 1,
              itemName: "an item name",
              itemSKU: "an item sku",
              quantity: 1,
              itemImageURL: "an item image url",
              pricePerItem: 10,
              currency: "USD",
              satConversionRate: 123.4,
            ),
          ],
          note: "A note",
        ),
      )
    ],
    PaymentFilterModel.initial(),
  );
}

class _CsvExporterTestStubPaymentInfo extends PaymentInfo {
  @override
  Int64 get amount => Int64(1234);

  @override
  bool get containsPaymentInfo => false;

  @override
  PaymentInfo copyWith(AccountModel account) => this;

  @override
  Int64 get creationTimestamp => Int64(1600000000);

  @override
  Currency get currency => Currency.BTC;

  @override
  String get description => "A description";

  @override
  String get destination => "A destination";

  @override
  String get dialogTitle => "A dialog title";

  @override
  Int64 get fee => Int64(5);

  @override
  bool get fullPending => false;

  @override
  bool get hasSale => true;

  @override
  String get imageURL => "An image URL";

  @override
  bool get isTransferRequest => false;

  @override
  bool get keySend => false;

  @override
  LNUrlPayInfo get lnurlPayInfo => LNUrlPayInfo.create();

  @override
  List<LNUrlPayMetadata> get metadata => [];

  @override
  String get paymentGroup => "A payment group";

  @override
  String get paymentGroupName => "A payment group name";

  @override
  String get paymentHash => "A payment hash";

  @override
  bool get pending => false;

  @override
  Int64 get pendingExpirationTimestamp => Int64(1600000000);

  @override
  String get preimage => "A preimage";

  @override
  String get redeemTxID => "A redeem transaction ID";

  @override
  String get title => "A title";

  @override
  PaymentType get type => PaymentType.RECEIVED;

  @override
  PaymentVendor get vendor => PaymentVendor.BREEZ_SALE;
}

class _FakePathProviderPlatform extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  final basePath = "${Directory.current.path}/.dart_tool/fake_path_provider";

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
