import '../async_action.dart';

class ConnectLSP extends AsyncAction {
  final String lspID;

  ConnectLSP(this.lspID);
}

class FetchLSPList extends AsyncAction {}