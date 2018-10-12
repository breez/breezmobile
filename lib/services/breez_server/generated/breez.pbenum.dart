///
//  Generated code. Do not modify.
//  source: breez.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class FundReply_ReturnCode extends $pb.ProtobufEnum {
  static const FundReply_ReturnCode SUCCESS = const FundReply_ReturnCode._(0, 'SUCCESS');
  static const FundReply_ReturnCode UNKNOWN_ERROR = const FundReply_ReturnCode._(-1, 'UNKNOWN_ERROR');
  static const FundReply_ReturnCode NODE_BUSY = const FundReply_ReturnCode._(-2, 'NODE_BUSY');
  static const FundReply_ReturnCode CLIENT_NOT_REGISTERED = const FundReply_ReturnCode._(-3, 'CLIENT_NOT_REGISTERED');
  static const FundReply_ReturnCode WRONG_NODE_ID = const FundReply_ReturnCode._(-4, 'WRONG_NODE_ID');
  static const FundReply_ReturnCode WRONG_AMOUNT = const FundReply_ReturnCode._(-5, 'WRONG_AMOUNT');

  static const List<FundReply_ReturnCode> values = const <FundReply_ReturnCode> [
    SUCCESS,
    UNKNOWN_ERROR,
    NODE_BUSY,
    CLIENT_NOT_REGISTERED,
    WRONG_NODE_ID,
    WRONG_AMOUNT,
  ];

  static final Map<int, FundReply_ReturnCode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FundReply_ReturnCode valueOf(int value) => _byValue[value];
  static void $checkItem(FundReply_ReturnCode v) {
    if (v is! FundReply_ReturnCode) $pb.checkItemFailed(v, 'FundReply_ReturnCode');
  }

  const FundReply_ReturnCode._(int v, String n) : super(v, n);
}

