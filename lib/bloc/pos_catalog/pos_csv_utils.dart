import 'dart:convert';
import 'dart:io';

import 'package:breez/bloc/pos_catalog/bloc.dart';
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
      List paymentItem = [];
      Item paymentInfo = this.itemList.elementAt(index);
      paymentItem.add(paymentInfo.id.toString());
      paymentItem.add(paymentInfo.name);
      paymentItem.add(paymentInfo.sku ?? "");
      paymentItem.add(paymentInfo.imageURL ?? "");
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
    return _populateItemListFromCsv(await _getCsvList(csvFile));
  }

  Future<List> _getCsvList(File csvFile) async {
    try {
      List csvList = await csvFile
          .openRead()
          .transform(utf8.decoder)
          .transform(new CsvToListConverter(shouldParseNumbers: false))
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
      if (!listEquals(headerRow, defaultHeaders)) {
        throw PosCatalogBloc.InvalidFile;
      }
      // remove header row
      csvList.removeAt(0);
      log.info("header control finished");
      return csvList;
    } catch (e) {
      throw PosCatalogBloc.InvalidFile;
    }
  }

  List<Item> _populateItemListFromCsv(List csvList) {
    try {
      var itemsList = <Item>[];
      csvList.forEach((csvItem) {
        List notNullColumns = [0, 1, 4, 5];
        notNullColumns.forEach((index) {
          if (csvItem[index].toString().isEmpty)
            throw PosCatalogBloc.InvalidData;
        });
        Item item = Item(
          id: int.parse(csvItem[0]),
          name: csvItem[1],
          sku: csvItem[2],
          imageURL: csvItem[3],
          currency: csvItem[4],
          price: double.parse(csvItem[5]),
        );
        itemsList.add(item);
      });
      log.info("retrieving item list from csv finished");
      return itemsList;
    } catch (e) {
      throw PosCatalogBloc.InvalidData;
    }
  }
}
