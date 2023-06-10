import 'package:convert/convert.dart';
import 'package:hex/hex.dart';

const NODE_URI_SEPARATOR = "@";
const NODE_ID_LENGTH = 66;

String parseNodeId(String nodeID) {
  if (nodeID == null) {
    return null;
  }
  nodeID = nodeID.trim();

  if (nodeID.length == NODE_ID_LENGTH && _isParsable(nodeID)) {
    return nodeID;
  }

  if (nodeID.length > NODE_ID_LENGTH &&
      nodeID.substring(NODE_ID_LENGTH, NODE_ID_LENGTH + 1) ==
          NODE_URI_SEPARATOR) {
    nodeID = nodeID.substring(0, NODE_ID_LENGTH);
    if (_isParsable(nodeID)) {
      return nodeID;
    }
  }
  return null;
}

bool _isParsable(String nodeID) {
  try {
    HEX.decode(nodeID);
  } on FormatException catch (_) {
    return false;
  }
  return true;
}
