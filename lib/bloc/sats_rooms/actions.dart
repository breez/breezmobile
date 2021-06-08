import 'package:breez/bloc/async_action.dart';

import 'model.dart';

class AddSatsRoom extends AsyncAction {
  final SatsRoom satsRoom;

  AddSatsRoom(this.satsRoom);
}

class FetchSatsRoom extends AsyncAction {
  final int id;

  FetchSatsRoom(this.id);
}

class UpdateSatsRoom extends AsyncAction {
  final SatsRoom satsRoom;

  UpdateSatsRoom(this.satsRoom);
}

class DeleteSatsRoom extends AsyncAction {
  final int id;

  DeleteSatsRoom(this.id);
}

class FilterSatsRooms extends AsyncAction {
  final String filter;

  FilterSatsRooms(this.filter);
}
