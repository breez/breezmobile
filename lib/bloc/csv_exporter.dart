import 'dart:io';

import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/utils/date.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class CsvExporter {
  final List paymentList;
  final PaymentFilterModel filter;

  CsvExporter(this.paymentList, this.filter);

  Future export() async {
    return await _saveCsvFile(const ListToCsvConverter().convert(_generateList()));
  }

  List _generateList() {
    List<List<dynamic>> paymentList = new List.generate(this.paymentList.length, (index) {
      List paymentItem = new List();
      PaymentInfo paymentInfo = this.paymentList.elementAt(index);
      paymentItem
          .add(DateUtils.formatYearMonthDayHourMinute(DateTime.fromMillisecondsSinceEpoch(paymentInfo.creationTimestamp.toInt() * 1000)));
      paymentItem.add(paymentInfo.title);
      paymentItem.add(paymentInfo.description);
      paymentItem.add(paymentInfo.destination);
      paymentItem.add(paymentInfo.amount.toString());
      paymentItem.add(paymentInfo.preimage);
      paymentItem.add(paymentInfo.paymentHash);
      return paymentItem;
    });
    paymentList.insert(0, ["Date & Time", "Title", "Description", "Node ID", "Amount", "Preimage", "TX Hash"]);
    return paymentList;
  }

  Future<String> _saveCsvFile(String csv) async {
    String filePath = await _createCsvFilePath();
    final file = File(filePath);
    await file.writeAsString(csv);
    return file.path;
  }

  Future<String> _createCsvFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/breez_payment_list';
    filePath = appendFilterInformation(filePath);
    filePath += ".csv";
    return filePath;
  }

  String appendFilterInformation(String filePath) {
    if (listEquals(this.filter.paymentType, [PaymentType.SENT, PaymentType.WITHDRAWAL])) {
      filePath += "_sent";
    } else if (listEquals(this.filter.paymentType, [PaymentType.RECEIVED, PaymentType.DEPOSIT])) {
      filePath += "_received";
    }
    if (this.filter.startDate != null && this.filter.endDate != null) {
      DateFormat dateFilterFormat = DateFormat("d.M.yy");
      String dateFilter = '${dateFilterFormat.format(this.filter.startDate)}-${dateFilterFormat.format(this.filter.endDate)}';
      filePath += "_$dateFilter";
    }
    return filePath;
  }
}
