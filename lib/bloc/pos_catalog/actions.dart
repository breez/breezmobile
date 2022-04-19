import 'dart:io';

import 'package:breez/bloc/async_action.dart';

import 'model.dart';

class AddItem extends AsyncAction {
  final Item item;

  AddItem(this.item);
}

class UpdateItem extends AsyncAction {
  final Item item;

  UpdateItem(this.item);
}

class DeleteItem extends AsyncAction {
  final int id;

  DeleteItem(this.id);
}

class FetchItem extends AsyncAction {
  final int id;

  FetchItem(this.id);
}

class SubmitCurrentSale extends AsyncAction {
  final String paymentHash;

  SubmitCurrentSale(this.paymentHash);
}

class FetchSale extends AsyncAction {
  final int id;
  final String paymentHash;

  FetchSale({this.id, this.paymentHash});
}

class SetCurrentSale extends AsyncAction {
  final Sale currentSale;

  SetCurrentSale(this.currentSale);
}

class FilterItems extends AsyncAction {
  final String filter;

  FilterItems(this.filter);
}

class ExportItems extends AsyncAction {}

class ImportItems extends AsyncAction {
  final File importFile;

  ImportItems(this.importFile);
}

class UpdatePosItemAdditionCurrency extends AsyncAction {
  final String currency;

  UpdatePosItemAdditionCurrency(this.currency);
}

class UpdatePosSelectedTab extends AsyncAction {
  final String tab;

  UpdatePosSelectedTab(this.tab);
}

class UpdatePosCatalogItemSort extends AsyncAction {
  final PosCatalogItemSort sort;

  UpdatePosCatalogItemSort(this.sort);
}

class UpdatePosReportTimeRange extends AsyncAction {
  final PosReportTimeRange range;

  UpdatePosReportTimeRange(this.range);
}

class FetchPosReport extends AsyncAction {
  final PosReportTimeRange range;

  FetchPosReport(this.range);
}
