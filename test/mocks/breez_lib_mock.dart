import 'dart:async';

import 'package:breez/services/breezlib/breez_bridge.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:mockito/mockito.dart';

class BreezLibMock extends Mock implements BreezBridge {
  Future<AddInvoiceReply> addInvoice(
    Int64 amount, {
    String payeeName,
    String payeeImageURL,
    String payerName,
    String payerImageURL,
    String description,
    Int64 expiry,
    LSPInformation inputLSP,
  }) {
    return Future.value(AddInvoiceReply());
  }

  StreamController eventsController = StreamController<NotificationEvent>.broadcast();

  Stream<NotificationEvent> get notificationStream => eventsController.stream;

  String backupProviderSet;
  String backupAuthDataSet;

  @override
  Future setBackupProvider(String backupProvider, String backupAuthData) {
    backupProviderSet = backupProvider;
    backupAuthDataSet = backupAuthData;
    return Future.value();
  }

  void dispose() {
    eventsController.close();
  }
}
