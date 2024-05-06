import 'package:breez/bloc/lsp/lsp_actions.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/services/breezlib/data/messages.pb.dart';

Future<List<LSPInfo>> fetchLSPList(LSPBloc lspBloc) async {
  var fetchAction = FetchLSPList();
  lspBloc.actionsSink.add(fetchAction);
  return await fetchAction.future;
}

bool hasFeesChanged(OpeningFeeParams oldFees, OpeningFeeParams newFees) {
  // Mark fee as changed only if new fees are higher
  return (newFees.minMsat > oldFees.minMsat) || (newFees.proportional > oldFees.proportional);
}
