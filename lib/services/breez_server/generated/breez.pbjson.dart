///
//  Generated code. Do not modify.
//  source: breez.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const RatesRequest$json = const {
  '1': 'RatesRequest',
};

const Rate$json = const {
  '1': 'Rate',
  '2': const [
    const {'1': 'coin', '3': 1, '4': 1, '5': 9, '10': 'coin'},
    const {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
};

const RatesReply$json = const {
  '1': 'RatesReply',
  '2': const [
    const {'1': 'rates', '3': 1, '4': 3, '5': 11, '6': '.breez.Rate', '10': 'rates'},
  ],
};

const LSPListRequest$json = const {
  '1': 'LSPListRequest',
  '2': const [
    const {'1': 'pubkey', '3': 2, '4': 1, '5': 9, '10': 'pubkey'},
  ],
};

const LSPInformation$json = const {
  '1': 'LSPInformation',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'widget_url', '3': 2, '4': 1, '5': 9, '10': 'widget_url'},
    const {'1': 'pubkey', '3': 3, '4': 1, '5': 9, '10': 'pubkey'},
    const {'1': 'host', '3': 4, '4': 1, '5': 9, '10': 'host'},
    const {'1': 'channel_capacity', '3': 5, '4': 1, '5': 3, '10': 'channel_capacity'},
    const {'1': 'target_conf', '3': 6, '4': 1, '5': 5, '10': 'target_conf'},
    const {'1': 'base_fee_msat', '3': 7, '4': 1, '5': 3, '10': 'base_fee_msat'},
    const {'1': 'fee_rate', '3': 8, '4': 1, '5': 1, '10': 'fee_rate'},
    const {'1': 'time_lock_delta', '3': 9, '4': 1, '5': 13, '10': 'time_lock_delta'},
    const {'1': 'min_htlc_msat', '3': 10, '4': 1, '5': 3, '10': 'min_htlc_msat'},
  ],
};

const LSPListReply$json = const {
  '1': 'LSPListReply',
  '2': const [
    const {'1': 'lsps', '3': 1, '4': 3, '5': 11, '6': '.breez.LSPListReply.LspsEntry', '10': 'lsps'},
  ],
  '3': const [LSPListReply_LspsEntry$json],
};

const LSPListReply_LspsEntry$json = const {
  '1': 'LspsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.breez.LSPInformation', '10': 'value'},
  ],
  '7': const {'7': true},
};

const OpenLSPChannelRequest$json = const {
  '1': 'OpenLSPChannelRequest',
  '2': const [
    const {'1': 'lsp_id', '3': 1, '4': 1, '5': 9, '10': 'lspId'},
    const {'1': 'pubkey', '3': 2, '4': 1, '5': 9, '10': 'pubkey'},
  ],
};

const OpenLSPChannelReply$json = const {
  '1': 'OpenLSPChannelReply',
};

const OpenChannelRequest$json = const {
  '1': 'OpenChannelRequest',
  '2': const [
    const {'1': 'pubKey', '3': 1, '4': 1, '5': 9, '10': 'pubKey'},
    const {'1': 'notificationToken', '3': 2, '4': 1, '5': 9, '10': 'notificationToken'},
  ],
};

const OpenChannelReply$json = const {
  '1': 'OpenChannelReply',
};

const Captcha$json = const {
  '1': 'Captcha',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'image', '3': 2, '4': 1, '5': 12, '10': 'image'},
  ],
};

const UpdateChannelPolicyRequest$json = const {
  '1': 'UpdateChannelPolicyRequest',
  '2': const [
    const {'1': 'pubKey', '3': 1, '4': 1, '5': 9, '10': 'pubKey'},
  ],
};

const UpdateChannelPolicyReply$json = const {
  '1': 'UpdateChannelPolicyReply',
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
    const {'1': 'requiredReserve', '3': 6, '4': 1, '5': 3, '10': 'requiredReserve'},
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

const GetSwapPaymentRequest$json = const {
  '1': 'GetSwapPaymentRequest',
  '2': const [
    const {'1': 'paymentRequest', '3': 1, '4': 1, '5': 9, '10': 'paymentRequest'},
  ],
};

const GetSwapPaymentReply$json = const {
  '1': 'GetSwapPaymentReply',
  '2': const [
    const {'1': 'paymentError', '3': 1, '4': 1, '5': 9, '10': 'paymentError'},
    const {'1': 'funds_exceeded_limit', '3': 2, '4': 1, '5': 8, '10': 'fundsExceededLimit'},
    const {'1': 'swap_error', '3': 3, '4': 1, '5': 14, '6': '.breez.GetSwapPaymentReply.SwapError', '10': 'swapError'},
  ],
  '4': const [GetSwapPaymentReply_SwapError$json],
};

const GetSwapPaymentReply_SwapError$json = const {
  '1': 'SwapError',
  '2': const [
    const {'1': 'NO_ERROR', '2': 0},
    const {'1': 'FUNDS_EXCEED_LIMIT', '2': 1},
    const {'1': 'TX_TOO_SMALL', '2': 2},
    const {'1': 'INVOICE_AMOUNT_MISMATCH', '2': 3},
    const {'1': 'SWAP_EXPIRED', '2': 4},
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
    const {'1': 'Email', '3': 7, '4': 1, '5': 9, '10': 'Email'},
  ],
};

const OrderReply$json = const {
  '1': 'OrderReply',
};

const JoinCTPSessionRequest$json = const {
  '1': 'JoinCTPSessionRequest',
  '2': const [
    const {'1': 'partyType', '3': 1, '4': 1, '5': 14, '6': '.breez.JoinCTPSessionRequest.PartyType', '10': 'partyType'},
    const {'1': 'partyName', '3': 2, '4': 1, '5': 9, '10': 'partyName'},
    const {'1': 'notificationToken', '3': 3, '4': 1, '5': 9, '10': 'notificationToken'},
    const {'1': 'sessionID', '3': 4, '4': 1, '5': 9, '10': 'sessionID'},
  ],
  '4': const [JoinCTPSessionRequest_PartyType$json],
};

const JoinCTPSessionRequest_PartyType$json = const {
  '1': 'PartyType',
  '2': const [
    const {'1': 'PAYER', '2': 0},
    const {'1': 'PAYEE', '2': 1},
  ],
};

const JoinCTPSessionResponse$json = const {
  '1': 'JoinCTPSessionResponse',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'expiry', '3': 2, '4': 1, '5': 3, '10': 'expiry'},
  ],
};

const TerminateCTPSessionRequest$json = const {
  '1': 'TerminateCTPSessionRequest',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
  ],
};

const TerminateCTPSessionResponse$json = const {
  '1': 'TerminateCTPSessionResponse',
};

const RegisterTransactionConfirmationRequest$json = const {
  '1': 'RegisterTransactionConfirmationRequest',
  '2': const [
    const {'1': 'txID', '3': 1, '4': 1, '5': 9, '10': 'txID'},
    const {'1': 'notificationToken', '3': 2, '4': 1, '5': 9, '10': 'notificationToken'},
    const {'1': 'notificationType', '3': 3, '4': 1, '5': 14, '6': '.breez.RegisterTransactionConfirmationRequest.NotificationType', '10': 'notificationType'},
  ],
  '4': const [RegisterTransactionConfirmationRequest_NotificationType$json],
};

const RegisterTransactionConfirmationRequest_NotificationType$json = const {
  '1': 'NotificationType',
  '2': const [
    const {'1': 'READY_RECEIVE_PAYMENT', '2': 0},
    const {'1': 'CHANNEL_OPENED', '2': 1},
  ],
};

const RegisterTransactionConfirmationResponse$json = const {
  '1': 'RegisterTransactionConfirmationResponse',
};

const RegisterPeriodicSyncRequest$json = const {
  '1': 'RegisterPeriodicSyncRequest',
  '2': const [
    const {'1': 'notificationToken', '3': 1, '4': 1, '5': 9, '10': 'notificationToken'},
  ],
};

const RegisterPeriodicSyncResponse$json = const {
  '1': 'RegisterPeriodicSyncResponse',
};

