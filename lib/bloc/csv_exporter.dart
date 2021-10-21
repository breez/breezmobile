import 'dart:io';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/logger.dart';
import 'package:breez/utils/date.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class CsvExporter {
  final List<CsvData> data;
  final PaymentFilterModel filter;

  CsvExporter(this.data, this.filter);

  Future export() async {
    log.info("export payments started");
    String tmpFilePath =
        await _saveCsvFile(const ListToCsvConverter().convert(_generateList()));
    log.info("export payments finished");
    return tmpFilePath;
  }

  List _generateList() {
    log.info("generating payment list started");
    final fiatCurrencies = _fiatCurrencies();
    List<List<String>> paymentList = List.generate(this.data.length, (index) {
      List<String> paymentItem = [];
      final data = this.data.elementAt(index);
      final paymentInfo = data.paymentInfo;
      final sale = data.sale;
      paymentItem.add(BreezDateUtils.formatYearMonthDayHourMinute(
          DateTime.fromMillisecondsSinceEpoch(
              paymentInfo.creationTimestamp.toInt() * 1000)));
      paymentItem.add(paymentInfo.title);
      paymentItem.add(paymentInfo.description);
      paymentItem.add(paymentInfo.destination);
      paymentItem.add(paymentInfo.amount.toString());
      paymentItem.add(paymentInfo.preimage);
      paymentItem.add(paymentInfo.paymentHash);
      for (var currency in fiatCurrencies) {
        final fiat = sale?.totalAmountInFiat;
        if (fiat != null && fiat.containsKey(currency)) {
          paymentItem.add(fiat[currency].toString());
        } else {
          paymentItem.add("-");
        }
      }
      return paymentItem;
    });
    paymentList.insert(0, [
      "Date & Time",
      "Title",
      "Description",
      "Node ID",
      "Amount",
      "Preimage",
      "TX Hash",
      ...fiatCurrencies,
    ]);
    log.info("generating payment finished");
    return paymentList;
  }

  Set<String> _fiatCurrencies() {
    return data
        .map((e) => e.sale?.totalAmountInFiat)
        .map((e) => e?.keys ?? [])
        .fold(Set<String>(), (p, e) => p.union(e.toSet()));
  }

  Future<String> _saveCsvFile(String csv) async {
    log.info("save breez payments to csv started");
    String filePath = await _createCsvFilePath();
    final file = File(filePath);
    await file.writeAsString(csv);
    log.info("save breez payments to csv finished");
    return file.path;
  }

  Future<String> _createCsvFilePath() async {
    log.info("create breez payments path started");
    final directory = await getTemporaryDirectory();
    String filePath = '${directory.path}/BreezPayments';
    filePath = appendFilterInformation(filePath);
    filePath += ".csv";
    log.info("create breez payments path finished");
    return filePath;
  }

  String appendFilterInformation(String filePath) {
    log.info("add filter information to path started");
    if (listEquals(
        this.filter.paymentType, [PaymentType.SENT, PaymentType.WITHDRAWAL])) {
      filePath += "_sent";
    } else if (listEquals(
        this.filter.paymentType, [PaymentType.RECEIVED, PaymentType.DEPOSIT])) {
      filePath += "_received";
    }
    if (this.filter.startDate != null && this.filter.endDate != null) {
      DateFormat dateFilterFormat = DateFormat("d.M.yy");
      String dateFilter =
          '${dateFilterFormat.format(this.filter.startDate)}-${dateFilterFormat.format(this.filter.endDate)}';
      filePath += "_$dateFilter";
    }
    log.info("add filter information to path finished");
    return filePath;
  }
}

class CsvData {
  final PaymentInfo paymentInfo;
  final Sale sale;

  const CsvData(
    this.paymentInfo,
    this.sale,
  );
}
