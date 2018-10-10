///
//  Generated code. Do not modify.
//  source: breez.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const AddFundRequest$json = const {
  '1': 'AddFundRequest',
  '2': const [
    const {'1': 'PaymentRequest', '3': 1, '4': 1, '5': 9, '10': 'PaymentRequest'},
    const {'1': 'clientID', '3': 2, '4': 1, '5': 9, '10': 'clientID'},
  ],
};

const AddFundReply$json = const {
  '1': 'AddFundReply',
  '2': const [
    const {'1': 'Address', '3': 1, '4': 1, '5': 9, '10': 'Address'},
  ],
};

const RemoveFundRequest$json = const {
  '1': 'RemoveFundRequest',
  '2': const [
    const {'1': 'Address', '3': 1, '4': 1, '5': 9, '10': 'Address'},
    const {'1': 'Amount', '3': 2, '4': 1, '5': 1, '10': 'Amount'},
  ],
};

const RemoveFundReply$json = const {
  '1': 'RemoveFundReply',
};

const MempoolRegisterRequest$json = const {
  '1': 'MempoolRegisterRequest',
  '2': const [
    const {'1': 'clientID', '3': 1, '4': 1, '5': 9, '10': 'clientID'},
    const {'1': 'addresses', '3': 2, '4': 3, '5': 9, '10': 'addresses'},
  ],
};

const MempoolRegisterReply$json = const {
  '1': 'MempoolRegisterReply',
  '2': const [
    const {'1': 'TXS', '3': 1, '4': 3, '5': 11, '6': '.breez.MempoolRegisterReply.Transaction', '10': 'TXS'},
  ],
  '3': const [MempoolRegisterReply_Transaction$json],
};

const MempoolRegisterReply_Transaction$json = const {
  '1': 'Transaction',
  '2': const [
    const {'1': 'TX', '3': 1, '4': 1, '5': 9, '10': 'TX'},
    const {'1': 'Address', '3': 2, '4': 1, '5': 9, '10': 'Address'},
    const {'1': 'Value', '3': 3, '4': 1, '5': 1, '10': 'Value'},
  ],
};

const FundRequest$json = const {
  '1': 'FundRequest',
  '2': const [
    const {'1': 'deviceID', '3': 1, '4': 1, '5': 9, '10': 'deviceID'},
    const {'1': 'lightningID', '3': 2, '4': 1, '5': 9, '10': 'lightningID'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 3, '10': 'amount'},
  ],
};

const FundReply$json = const {
  '1': 'FundReply',
  '2': const [
    const {'1': 'returnCode', '3': 1, '4': 1, '5': 14, '6': '.breez.FundReply.ReturnCode', '10': 'returnCode'},
  ],
  '4': const [FundReply_ReturnCode$json],
};

const FundReply_ReturnCode$json = const {
  '1': 'ReturnCode',
  '2': const [
    const {'1': 'SUCCESS', '2': 0},
    const {'1': 'UNKNOWN_ERROR', '2': -1},
    const {'1': 'NODE_BUSY', '2': -2},
    const {'1': 'CLIENT_NOT_REGISTERED', '2': -3},
    const {'1': 'WRONG_NODE_ID', '2': -4},
    const {'1': 'WRONG_AMOUNT', '2': -5},
  ],
};

const RegisterRequest$json = const {
  '1': 'RegisterRequest',
  '2': const [
    const {'1': 'deviceID', '3': 1, '4': 1, '5': 9, '10': 'deviceID'},
    const {'1': 'lightningID', '3': 2, '4': 1, '5': 9, '10': 'lightningID'},
  ],
};

const RegisterReply$json = const {
  '1': 'RegisterReply',
  '2': const [
    const {'1': 'breezID', '3': 1, '4': 1, '5': 9, '10': 'breezID'},
  ],
};

const PaymentRequest$json = const {
  '1': 'PaymentRequest',
  '2': const [
    const {'1': 'breezID', '3': 1, '4': 1, '5': 9, '10': 'breezID'},
    const {'1': 'invoice', '3': 2, '4': 1, '5': 9, '10': 'invoice'},
    const {'1': 'payee', '3': 3, '4': 1, '5': 9, '10': 'payee'},
    const {'1': 'amount', '3': 4, '4': 1, '5': 3, '10': 'amount'},
  ],
};

const InvoiceReply$json = const {
  '1': 'InvoiceReply',
  '2': const [
    const {'1': 'Error', '3': 1, '4': 1, '5': 9, '10': 'Error'},
  ],
};

const UploadFileRequest$json = const {
  '1': 'UploadFileRequest',
  '2': const [
    const {'1': 'content', '3': 1, '4': 1, '5': 12, '10': 'content'},
  ],
};

const UploadFileReply$json = const {
  '1': 'UploadFileReply',
  '2': const [
    const {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
  ],
};

const PingRequest$json = const {
  '1': 'PingRequest',
};

const PingReply$json = const {
  '1': 'PingReply',
  '2': const [
    const {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
  ],
};

const OrderRequest$json = const {
  '1': 'OrderRequest',
  '2': const [
    const {'1': 'FullName', '3': 1, '4': 1, '5': 9, '10': 'FullName'},
    const {'1': 'Address', '3': 2, '4': 1, '5': 9, '10': 'Address'},
    const {'1': 'City', '3': 3, '4': 1, '5': 9, '10': 'City'},
    const {'1': 'State', '3': 4, '4': 1, '5': 9, '10': 'State'},
    const {'1': 'Zip', '3': 5, '4': 1, '5': 9, '10': 'Zip'},
    const {'1': 'Country', '3': 6, '4': 1, '5': 9, '10': 'Country'},
  ],
};

const OrderReply$json = const {
  '1': 'OrderReply',
};

