import 'dart:convert';
import 'dart:io';

import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

final _log = Logger("PosCsvUtils");

class PosCsvUtils {
  final List itemList;

  PosCsvUtils({this.itemList});

  Future export() async {
    _log.info("export pos items started");
    String tmpFilePath =
        await _saveCsvFile(const ListToCsvConverter().convert(_generateList()));
    _log.info("export pos items finished");
    return tmpFilePath;
  }

  List _generateList() {
    final texts = getSystemAppLocalizations();
    _log.info("generating payment list started");
    List<List<dynamic>> paymentList = List.generate(itemList.length, (index) {
      List paymentItem = [];
      Item paymentInfo = itemList.elementAt(index);
      paymentItem.add(paymentInfo.id.toString());
      paymentItem.add(paymentInfo.name);
      paymentItem.add(paymentInfo.sku ?? "");
      paymentItem.add(paymentInfo.imageURL ?? "");
      paymentItem.add(paymentInfo.currency);
      paymentItem.add(paymentInfo.price.toString());
      return paymentItem;
    });
    paymentList.insert(0, [
      texts.pos_settings_id,
      texts.pos_settings_name,
      texts.pos_settings_sku,
      texts.pos_settings_image_url,
      texts.pos_settings_currency,
      texts.pos_settings_price,
    ]);
    _log.info("generating pos items finished");
    return paymentList;
  }

  Future<String> _saveCsvFile(String csv) async {
    _log.info("save breez pos items to csv started");
    String filePath = await _createCsvFilePath();
    final file = File(filePath);
    await file.writeAsString(csv);
    _log.info("save breez pos items to csv finished");
    return file.path;
  }

  Future<String> _createCsvFilePath() async {
    _log.info("create breez pos items path started");
    final directory = await getTemporaryDirectory();
    String filePath = '${directory.path}/BreezPosItems';
    filePath += ".csv";
    _log.info("create breez pos items path finished");
    return filePath;
  }

  Future retrieveItemListFromCSV(File csvFile) async {
    _log.info("retrieve item list from csv started");
    return _populateItemListFromCsv(await _getCsvList(csvFile));
  }

  Future<List> _getCsvList(File csvFile) async {
    final texts = getSystemAppLocalizations();
    try {
      List csvList = await csvFile
          .openRead()
          .transform(utf8.decoder)
          .transform(const CsvToListConverter(shouldParseNumbers: false))
          .toList();
      _log.info("header control started");
      List<String> headerRow = List<String>.from(csvList.elementAt(0));
      var defaultHeaders = [
        texts.pos_settings_id,
        texts.pos_settings_name,
        texts.pos_settings_sku,
        texts.pos_settings_image_url,
        texts.pos_settings_currency,
        texts.pos_settings_price,
      ];
      if (!listEquals(headerRow, defaultHeaders)) {
        throw PosCatalogBloc.InvalidFile;
      }
      // remove header row
      csvList.removeAt(0);
      _log.info("header control finished");
      return csvList;
    } catch (e) {
      throw PosCatalogBloc.InvalidFile;
    }
  }

  List<Item> _populateItemListFromCsv(List csvList) {
    try {
      var itemsList = <Item>[];
      for (var csvItem in csvList) {
        List notNullColumns = [0, 1, 4, 5];
        for (var index in notNullColumns) {
          if (csvItem[index].toString().isEmpty) {
            throw PosCatalogBloc.InvalidData;
          }
        }
        Item item = Item(
          id: int.parse(csvItem[0]),
          name: csvItem[1],
          sku: csvItem[2],
          imageURL: csvItem[3],
          currency: csvItem[4],
          price: double.parse(csvItem[5]),
        );
        itemsList.add(item);
      }
      _log.info("retrieving item list from csv finished");
      return itemsList;
    } catch (e) {
      throw PosCatalogBloc.InvalidData;
    }
  }
}
