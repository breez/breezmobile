///
//  Generated code. Do not modify.
//  source: breez.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const RatesRequest$json = {
  '1': 'RatesRequest',
};

const Rate$json = {
  '1': 'Rate',
  '2': [
    {'1': 'coin', '3': 1, '4': 1, '5': 9, '10': 'coin'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
};

const RatesReply$json = {
  '1': 'RatesReply',
  '2': [
    {'1': 'rates', '3': 1, '4': 3, '5': 11, '6': '.breez.Rate', '10': 'rates'},
  ],
};

const LSPListRequest$json = {
  '1': 'LSPListRequest',
  '2': [
    {'1': 'pubkey', '3': 2, '4': 1, '5': 9, '10': 'pubkey'},
  ],
};

const LSPInformation$json = {
  '1': 'LSPInformation',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'widget_url', '3': 2, '4': 1, '5': 9, '10': 'widget_url'},
    {'1': 'pubkey', '3': 3, '4': 1, '5': 9, '10': 'pubkey'},
    {'1': 'host', '3': 4, '4': 1, '5': 9, '10': 'host'},
    {'1': 'channel_capacity', '3': 5, '4': 1, '5': 3, '10': 'channel_capacity'},
    {'1': 'target_conf', '3': 6, '4': 1, '5': 5, '10': 'target_conf'},
    {'1': 'base_fee_msat', '3': 7, '4': 1, '5': 3, '10': 'base_fee_msat'},
    {'1': 'fee_rate', '3': 8, '4': 1, '5': 1, '10': 'fee_rate'},
    {'1': 'time_lock_delta', '3': 9, '4': 1, '5': 13, '10': 'time_lock_delta'},
    {'1': 'min_htlc_msat', '3': 10, '4': 1, '5': 3, '10': 'min_htlc_msat'},
  ],
};

const LSPListReply$json = {
  '1': 'LSPListReply',
  '2': [
    {
      '1': 'lsps',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.breez.LSPListReply.LspsEntry',
      '10': 'lsps'
    },
  ],
  '3': [LSPListReply_LspsEntry$json],
};

const LSPListReply_LspsEntry$json = {
  '1': 'LspsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.breez.LSPInformation',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

const OpenLSPChannelRequest$json = {
  '1': 'OpenLSPChannelRequest',
  '2': [
    {'1': 'lsp_id', '3': 1, '4': 1, '5': 9, '10': 'lspId'},
    {'1': 'pubkey', '3': 2, '4': 1, '5': 9, '10': 'pubkey'},
  ],
};

const OpenLSPChannelReply$json = {
  '1': 'OpenLSPChannelReply',
};

const OpenChannelRequest$json = {
  '1': 'OpenChannelRequest',
  '2': [
    {'1': 'pubKey', '3': 1, '4': 1, '5': 9, '10': 'pubKey'},
    {
      '1': 'notificationToken',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'notificationToken'
    },
  ],
};

const OpenChannelReply$json = {
  '1': 'OpenChannelReply',
};

const Captcha$json = {
  '1': 'Captcha',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'image', '3': 2, '4': 1, '5': 12, '10': 'image'},
  ],
};

const UpdateChannelPolicyRequest$json = {
  '1': 'UpdateChannelPolicyRequest',
  '2': [
    {'1': 'pubKey', '3': 1, '4': 1, '5': 9, '10': 'pubKey'},
  ],
};

const UpdateChannelPolicyReply$json = {
  '1': 'UpdateChannelPolicyReply',
};

const AddFundInitRequest$json = {
  '1': 'AddFundInitRequest',
  '2': [
    {'1': 'nodeID', '3': 1, '4': 1, '5': 9, '10': 'nodeID'},
    {
      '1': 'notificationToken',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'notificationToken'
    },
    {'1': 'pubkey', '3': 3, '4': 1, '5': 12, '10': 'pubkey'},
    {'1': 'hash', '3': 4, '4': 1, '5': 12, '10': 'hash'},
  ],
};

const AddFundInitReply$json = {
  '1': 'AddFundInitReply',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'pubkey', '3': 2, '4': 1, '5': 12, '10': 'pubkey'},
    {'1': 'lockHeight', '3': 3, '4': 1, '5': 3, '10': 'lockHeight'},
    {
      '1': 'maxAllowedDeposit',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'maxAllowedDeposit'
    },
    {'1': 'errorMessage', '3': 5, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'requiredReserve', '3': 6, '4': 1, '5': 3, '10': 'requiredReserve'},
  ],
};

const AddFundStatusRequest$json = {
  '1': 'AddFundStatusRequest',
  '2': [
    {'1': 'addresses', '3': 1, '4': 3, '5': 9, '10': 'addresses'},
    {
      '1': 'notificationToken',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'notificationToken'
    },
  ],
};

const AddFundStatusReply$json = {
  '1': 'AddFundStatusReply',
  '2': [
    {
      '1': 'statuses',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.breez.AddFundStatusReply.StatusesEntry',
      '10': 'statuses'
    },
  ],
  '3': [
    AddFundStatusReply_AddressStatus$json,
    AddFundStatusReply_StatusesEntry$json
  ],
};

const AddFundStatusReply_AddressStatus$json = {
  '1': 'AddressStatus',
  '2': [
    {'1': 'tx', '3': 1, '4': 1, '5': 9, '10': 'tx'},
    {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
    {'1': 'confirmed', '3': 3, '4': 1, '5': 8, '10': 'confirmed'},
    {'1': 'blockHash', '3': 4, '4': 1, '5': 9, '10': 'blockHash'},
  ],
};

const AddFundStatusReply_StatusesEntry$json = {
  '1': 'StatusesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.breez.AddFundStatusReply.AddressStatus',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

const RemoveFundRequest$json = {
  '1': 'RemoveFundRequest',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
  ],
};

const RemoveFundReply$json = {
  '1': 'RemoveFundReply',
  '2': [
    {'1': 'paymentRequest', '3': 1, '4': 1, '5': 9, '10': 'paymentRequest'},
    {'1': 'errorMessage', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

const RedeemRemovedFundsRequest$json = {
  '1': 'RedeemRemovedFundsRequest',
  '2': [
    {'1': 'paymenthash', '3': 1, '4': 1, '5': 9, '10': 'paymenthash'},
  ],
};

const RedeemRemovedFundsReply$json = {
  '1': 'RedeemRemovedFundsReply',
  '2': [
    {'1': 'txid', '3': 1, '4': 1, '5': 9, '10': 'txid'},
  ],
};

const GetSwapPaymentRequest$json = {
  '1': 'GetSwapPaymentRequest',
  '2': [
    {'1': 'paymentRequest', '3': 1, '4': 1, '5': 9, '10': 'paymentRequest'},
  ],
};

const GetSwapPaymentReply$json = {
  '1': 'GetSwapPaymentReply',
  '2': [
    {'1': 'paymentError', '3': 1, '4': 1, '5': 9, '10': 'paymentError'},
    {
      '1': 'funds_exceeded_limit',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'fundsExceededLimit'
    },
    {
      '1': 'swap_error',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.breez.GetSwapPaymentReply.SwapError',
      '10': 'swapError'
    },
  ],
  '4': [GetSwapPaymentReply_SwapError$json],
};

const GetSwapPaymentReply_SwapError$json = {
  '1': 'SwapError',
  '2': [
    {'1': 'NO_ERROR', '2': 0},
    {'1': 'FUNDS_EXCEED_LIMIT', '2': 1},
    {'1': 'TX_TOO_SMALL', '2': 2},
    {'1': 'INVOICE_AMOUNT_MISMATCH', '2': 3},
    {'1': 'SWAP_EXPIRED', '2': 4},
  ],
};

const RegisterRequest$json = {
  '1': 'RegisterRequest',
  '2': [
    {'1': 'deviceID', '3': 1, '4': 1, '5': 9, '10': 'deviceID'},
    {'1': 'lightningID', '3': 2, '4': 1, '5': 9, '10': 'lightningID'},
  ],
};

const RegisterReply$json = {
  '1': 'RegisterReply',
  '2': [
    {'1': 'breezID', '3': 1, '4': 1, '5': 9, '10': 'breezID'},
  ],
};

const PaymentRequest$json = {
  '1': 'PaymentRequest',
  '2': [
    {'1': 'breezID', '3': 1, '4': 1, '5': 9, '10': 'breezID'},
    {'1': 'invoice', '3': 2, '4': 1, '5': 9, '10': 'invoice'},
    {'1': 'payee', '3': 3, '4': 1, '5': 9, '10': 'payee'},
    {'1': 'amount', '3': 4, '4': 1, '5': 3, '10': 'amount'},
  ],
};

const InvoiceReply$json = {
  '1': 'InvoiceReply',
  '2': [
    {'1': 'Error', '3': 1, '4': 1, '5': 9, '10': 'Error'},
  ],
};

const UploadFileRequest$json = {
  '1': 'UploadFileRequest',
  '2': [
    {'1': 'content', '3': 1, '4': 1, '5': 12, '10': 'content'},
  ],
};

const UploadFileReply$json = {
  '1': 'UploadFileReply',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
  ],
};

const PingRequest$json = {
  '1': 'PingRequest',
};

const PingReply$json = {
  '1': 'PingReply',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
  ],
};

const OrderRequest$json = {
  '1': 'OrderRequest',
  '2': [
    {'1': 'FullName', '3': 1, '4': 1, '5': 9, '10': 'FullName'},
    {'1': 'Address', '3': 2, '4': 1, '5': 9, '10': 'Address'},
    {'1': 'City', '3': 3, '4': 1, '5': 9, '10': 'City'},
    {'1': 'State', '3': 4, '4': 1, '5': 9, '10': 'State'},
    {'1': 'Zip', '3': 5, '4': 1, '5': 9, '10': 'Zip'},
    {'1': 'Country', '3': 6, '4': 1, '5': 9, '10': 'Country'},
    {'1': 'Email', '3': 7, '4': 1, '5': 9, '10': 'Email'},
  ],
};

const OrderReply$json = {
  '1': 'OrderReply',
};

const JoinCTPSessionRequest$json = {
  '1': 'JoinCTPSessionRequest',
  '2': [
    {
      '1': 'partyType',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.breez.JoinCTPSessionRequest.PartyType',
      '10': 'partyType'
    },
    {'1': 'partyName', '3': 2, '4': 1, '5': 9, '10': 'partyName'},
    {
      '1': 'notificationToken',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'notificationToken'
    },
    {'1': 'sessionID', '3': 4, '4': 1, '5': 9, '10': 'sessionID'},
  ],
  '4': [JoinCTPSessionRequest_PartyType$json],
};

const JoinCTPSessionRequest_PartyType$json = {
  '1': 'PartyType',
  '2': [
    {'1': 'PAYER', '2': 0},
    {'1': 'PAYEE', '2': 1},
  ],
};

const JoinCTPSessionResponse$json = {
  '1': 'JoinCTPSessionResponse',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    {'1': 'expiry', '3': 2, '4': 1, '5': 3, '10': 'expiry'},
  ],
};

const TerminateCTPSessionRequest$json = {
  '1': 'TerminateCTPSessionRequest',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
  ],
};

const TerminateCTPSessionResponse$json = {
  '1': 'TerminateCTPSessionResponse',
};

const RegisterTransactionConfirmationRequest$json = {
  '1': 'RegisterTransactionConfirmationRequest',
  '2': [
    {'1': 'txID', '3': 1, '4': 1, '5': 9, '10': 'txID'},
    {
      '1': 'notificationToken',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'notificationToken'
    },
    {
      '1': 'notificationType',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.breez.RegisterTransactionConfirmationRequest.NotificationType',
      '10': 'notificationType'
    },
  ],
  '4': [RegisterTransactionConfirmationRequest_NotificationType$json],
};

const RegisterTransactionConfirmationRequest_NotificationType$json = {
  '1': 'NotificationType',
  '2': [
    {'1': 'READY_RECEIVE_PAYMENT', '2': 0},
    {'1': 'CHANNEL_OPENED', '2': 1},
  ],
};

const RegisterTransactionConfirmationResponse$json = {
  '1': 'RegisterTransactionConfirmationResponse',
};

const RegisterPeriodicSyncRequest$json = {
  '1': 'RegisterPeriodicSyncRequest',
  '2': [
    {
      '1': 'notificationToken',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'notificationToken'
    },
  ],
};

const RegisterPeriodicSyncResponse$json = {
  '1': 'RegisterPeriodicSyncResponse',
};
