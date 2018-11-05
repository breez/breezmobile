///
//  Generated code. Do not modify.
//  source: breez.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const OpenChannelRequest$json = const {
  '1': 'OpenChannelRequest',
  '2': const [
    const {'1': 'pubKey', '3': 1, '4': 1, '5': 9, '10': 'pubKey'},
  ],
};

const OpenChannelReply$json = const {
  '1': 'OpenChannelReply',
};

const AddFundInitRequest$json = const {
  '1': 'AddFundInitRequest',
  '2': const [
    const {'1': 'nodeID', '3': 1, '4': 1, '5': 9, '10': 'nodeID'},
    const {'1': 'notificationToken', '3': 2, '4': 1, '5': 9, '10': 'notificationToken'},
    const {'1': 'pubkey', '3': 3, '4': 1, '5': 12, '10': 'pubkey'},
    const {'1': 'hash', '3': 4, '4': 1, '5': 12, '10': 'hash'},
  ],
};

const AddFundInitReply$json = const {
  '1': 'AddFundInitReply',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'pubkey', '3': 2, '4': 1, '5': 12, '10': 'pubkey'},
    const {'1': 'lockHeight', '3': 3, '4': 1, '5': 3, '10': 'lockHeight'},
    const {'1': 'maxAllowedDeposit', '3': 4, '4': 1, '5': 3, '10': 'maxAllowedDeposit'},
    const {'1': 'errorMessage', '3': 5, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

const AddFundRequest$json = const {
  '1': 'AddFundRequest',
  '2': const [
    const {'1': 'paymentRequest', '3': 1, '4': 1, '5': 9, '10': 'paymentRequest'},
    const {'1': 'notificationToken', '3': 2, '4': 1, '5': 9, '10': 'notificationToken'},
  ],
};

const AddFundReply$json = const {
  '1': 'AddFundReply',
  '2': const [
    const {'1': 'errorMessage', '3': 3, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

const AddFundStatusRequest$json = const {
  '1': 'AddFundStatusRequest',
  '2': const [
    const {'1': 'addresses', '3': 1, '4': 3, '5': 9, '10': 'addresses'},
    const {'1': 'notificationToken', '3': 2, '4': 1, '5': 9, '10': 'notificationToken'},
  ],
};

const AddFundStatusReply$json = const {
  '1': 'AddFundStatusReply',
  '2': const [
    const {'1': 'statuses', '3': 1, '4': 3, '5': 11, '6': '.breez.AddFundStatusReply.StatusesEntry', '10': 'statuses'},
  ],
  '3': const [AddFundStatusReply_AddressStatus$json, AddFundStatusReply_StatusesEntry$json],
};

const AddFundStatusReply_AddressStatus$json = const {
  '1': 'AddressStatus',
  '2': const [
    const {'1': 'tx', '3': 1, '4': 1, '5': 9, '10': 'tx'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
    const {'1': 'confirmed', '3': 3, '4': 1, '5': 8, '10': 'confirmed'},
    const {'1': 'blockHash', '3': 4, '4': 1, '5': 9, '10': 'blockHash'},
  ],
};

const AddFundStatusReply_StatusesEntry$json = const {
  '1': 'StatusesEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.breez.AddFundStatusReply.AddressStatus', '10': 'value'},
  ],
  '7': const {'7': true},
};

const RemoveFundRequest$json = const {
  '1': 'RemoveFundRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
  ],
};

const RemoveFundReply$json = const {
  '1': 'RemoveFundReply',
  '2': const [
    const {'1': 'paymentRequest', '3': 1, '4': 1, '5': 9, '10': 'paymentRequest'},
    const {'1': 'errorMessage', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

const RedeemRemovedFundsRequest$json = const {
  '1': 'RedeemRemovedFundsRequest',
  '2': const [
    const {'1': 'paymenthash', '3': 1, '4': 1, '5': 9, '10': 'paymenthash'},
  ],
};

const RedeemRemovedFundsReply$json = const {
  '1': 'RedeemRemovedFundsReply',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 1, '5': 9, '10': 'txid'},
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

const GetPaymentRequest$json = const {
  '1': 'GetPaymentRequest',
  '2': const [
    const {'1': 'paymentRequest', '3': 1, '4': 1, '5': 9, '10': 'paymentRequest'},
    const {'1': 'address', '3': 2, '4': 1, '5': 9, '10': 'address'},
  ],
};

const GetPaymentReply$json = const {
  '1': 'GetPaymentReply',
  '2': const [
    const {'1': 'paymentError', '3': 1, '4': 1, '5': 9, '10': 'paymentError'},
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

