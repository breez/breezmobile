import 'dart:convert';
import 'dart:io';

import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/logger.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class PosCsvUtils {
  final List itemList;

  PosCsvUtils({this.itemList});

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
        List.generate(this.itemList.length, (index) {
      List paymentItem = List();
      Item paymentInfo = this.itemList.elementAt(index);
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

  Future retrieveItemListFromCSV(File csvFile) async {
    log.info("retrieve item list from csv started");
    List csvList = await csvFile
        .openRead()
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    log.info("header control started");
    List<String> headerRow = List<String>.from(csvList.elementAt(0));
    var defaultHeaders = [
      "ID",
      "Name",
      "SKU",
      "Image URL",
      "Currency",
      "Price",
    ];
    // Need a more sophisticated control here. Check #1
    if (!listEquals(headerRow, defaultHeaders)) {
      throw Exception("INVALID_FILE");
    }
    // remove header row
    csvList.removeAt(0);
    log.info("header control finished");
    // create items list
    var itemsList = <Item>[];
    csvList.forEach((csvItem) {
      // #1: We should extend this so our users will be able
      // to import files that does not have this exact column order.
      Item item = Item(
          id: csvItem[0],
          name: csvItem[1],
          sku: csvItem[2].toString(),
          imageURL: csvItem[3] != "null" ? csvItem[3] : null,
          currency: csvItem[4] != "null" ? csvItem[4] : null,
          price: csvItem[5]);
      itemsList.add(item);
    });
    log.info("retrieving item list from csv finished");
    return itemsList;
  }
}
