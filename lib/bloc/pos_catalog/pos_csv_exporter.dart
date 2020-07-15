import 'dart:io';

import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/logger.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class PosCsvUtils {
  final List paymentList;

  PosCsvUtils(this.paymentList);

  Future export() async {
    log.info("export pos items started");
    String tmpFilePath =
        await _saveCsvFile(const ListToCsvConverter().convert(_generateList()));
    log.info("export pos items finished");
    return tmpFilePath;
  }

  List _generateList() {
    log.info("generating payment list started");
    List<List<dynamic>> paymentList =
        List.generate(this.paymentList.length, (index) {
      List paymentItem = List();
      Item paymentInfo = this.paymentList.elementAt(index);
      paymentItem.add(paymentInfo.id.toString());
      paymentItem.add(paymentInfo.name);
      paymentItem.add(paymentInfo.sku);
      paymentItem.add(paymentInfo.imageURL);
      paymentItem.add(paymentInfo.currency);
      paymentItem.add(paymentInfo.price.toString());
      return paymentItem;
    });
    paymentList.insert(0, [
      "ID",
      "Name",
      "SKU",
      "Image URL",
      "Currency",
      "Price",
    ]);
    log.info("generating pos items finished");
    return paymentList;
  }

  Future<String> _saveCsvFile(String csv) async {
    log.info("save breez pos items to csv started");
    String filePath = await _createCsvFilePath();
    final file = File(filePath);
    await file.writeAsString(csv);
    log.info("save breez pos items to csv finished");
    return file.path;
  }

  Future<String> _createCsvFilePath() async {
    log.info("create breez pos items path started");
    final directory = await getTemporaryDirectory();
    String filePath = '${directory.path}/BreezPosItems';
    filePath += ".csv";
    log.info("create breez pos items path finished");
    return filePath;
  }
}
