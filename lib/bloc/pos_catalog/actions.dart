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

class AddSale extends AsyncAction {
  final Sale sale;

  AddSale(this.sale);
}

class FetchSale extends AsyncAction {
  final int id;

  FetchSale(this.id);
}

class SetCurrentSale extends AsyncAction {
  final Sale currentSale;

  SetCurrentSale(this.currentSale);
}

class FilterItems extends AsyncAction {
  final String filter;

  FilterItems(this.filter);
}
