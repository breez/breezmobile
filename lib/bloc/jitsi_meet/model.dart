import 'package:breez/services/breezlib/data/rpc.pb.dart';

class BreezDataProperty {
  final String nodeID;
  final List<int> proof;
  final RoutingHints hints;

  BreezDataProperty(this.nodeID, this.proof, this.hints);

  BreezDataProperty.fromMap(Map<String, dynamic> json)
      : nodeID = json["nodeID"],
        proof = json["proof"],
        hints = RoutingHints()..mergeFromJson(json["title"].toString());

  Map<String, dynamic> toMap() {
    return {
      'nodeID': nodeID,
      'proof': proof,
      'hints': hints.writeToJson(),
    };
  }
}
