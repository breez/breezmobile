import '../async_action.dart';

class ConnectLSP extends AsyncAction {
  final String lspID;
  final String lnurl;

  ConnectLSP(this.lspID, this.lnurl);
}

class FetchLSPList extends AsyncAction {}
