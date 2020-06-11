const NODE_URI_SEPARATOR = "@";
const NODE_ID_LENGTH = 66;

String parseNodeId(String nodeID) {
  if (nodeID == null) {
    return null;
  }
  if (nodeID.length == NODE_ID_LENGTH) {
    return nodeID;
  }

  if (nodeID.length > NODE_ID_LENGTH &&
      nodeID.substring(NODE_ID_LENGTH, NODE_ID_LENGTH + 1) ==
          NODE_URI_SEPARATOR) {
    return nodeID.substring(0, 66);
  }

  return null;
}
