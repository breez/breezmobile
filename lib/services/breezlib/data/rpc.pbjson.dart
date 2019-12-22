///
//  Generated code. Do not modify.
//  source: rpc.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const SwapError$json = {
  '1': 'SwapError',
  '2': [
    {'1': 'NO_ERROR', '2': 0},
    {'1': 'FUNDS_EXCEED_LIMIT', '2': 1},
    {'1': 'TX_TOO_SMALL', '2': 2},
    {'1': 'INVOICE_AMOUNT_MISMATCH', '2': 3},
    {'1': 'SWAP_EXPIRED', '2': 4},
  ],
};

const ChainStatus$json = {
  '1': 'ChainStatus',
  '2': [
    {'1': 'blockHeight', '3': 1, '4': 1, '5': 13, '10': 'blockHeight'},
    {'1': 'syncedToChain', '3': 2, '4': 1, '5': 8, '10': 'syncedToChain'},
  ],
};

const Account$json = {
  '1': 'Account',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'balance', '3': 2, '4': 1, '5': 3, '10': 'balance'},
    {'1': 'walletBalance', '3': 3, '4': 1, '5': 3, '10': 'walletBalance'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.data.Account.AccountStatus',
      '10': 'status'
    },
    {
      '1': 'maxAllowedToReceive',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'maxAllowedToReceive'
    },
    {'1': 'maxAllowedToPay', '3': 6, '4': 1, '5': 3, '10': 'maxAllowedToPay'},
    {'1': 'maxPaymentAmount', '3': 7, '4': 1, '5': 3, '10': 'maxPaymentAmount'},
    {'1': 'routingNodeFee', '3': 8, '4': 1, '5': 3, '10': 'routingNodeFee'},
    {'1': 'enabled', '3': 9, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'maxChanReserve', '3': 10, '4': 1, '5': 3, '10': 'maxChanReserve'},
    {'1': 'channelPoint', '3': 11, '4': 1, '5': 9, '10': 'channelPoint'},
    {
      '1': 'readyForPayments',
      '3': 12,
      '4': 1,
      '5': 8,
      '10': 'readyForPayments'
    },
    {'1': 'tipHeight', '3': 13, '4': 1, '5': 3, '10': 'tipHeight'},
  ],
  '4': [Account_AccountStatus$json],
};

const Account_AccountStatus$json = {
  '1': 'AccountStatus',
  '2': [
    {'1': 'DISCONNECTED', '2': 0},
    {'1': 'PROCESSING_CONNECTION', '2': 1},
    {'1': 'CLOSING_CONNECTION', '2': 2},
    {'1': 'CONNECTED', '2': 3},
  ],
};

const Payment$json = {
  '1': 'Payment',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.data.Payment.PaymentType',
      '10': 'type'
    },
    {'1': 'amount', '3': 3, '4': 1, '5': 3, '10': 'amount'},
    {
      '1': 'creationTimestamp',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'creationTimestamp'
    },
    {
      '1': 'invoiceMemo',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.data.InvoiceMemo',
      '10': 'invoiceMemo'
    },
    {'1': 'redeemTxID', '3': 7, '4': 1, '5': 9, '10': 'redeemTxID'},
    {'1': 'paymentHash', '3': 8, '4': 1, '5': 9, '10': 'paymentHash'},
    {'1': 'destination', '3': 9, '4': 1, '5': 9, '10': 'destination'},
    {
      '1': 'PendingExpirationHeight',
      '3': 10,
      '4': 1,
      '5': 13,
      '10': 'PendingExpirationHeight'
    },
    {
      '1': 'PendingExpirationTimestamp',
      '3': 11,
      '4': 1,
      '5': 3,
      '10': 'PendingExpirationTimestamp'
    },
    {'1': 'fee', '3': 12, '4': 1, '5': 3, '10': 'fee'},
    {'1': 'preimage', '3': 13, '4': 1, '5': 9, '10': 'preimage'},
    {
      '1': 'closedChannelPoint',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'closedChannelPoint'
    },
    {
      '1': 'isChannelPending',
      '3': 15,
      '4': 1,
      '5': 8,
      '10': 'isChannelPending'
    },
    {
      '1': 'isChannelCloseConfimed',
      '3': 16,
      '4': 1,
      '5': 8,
      '10': 'isChannelCloseConfimed'
    },
    {
      '1': 'closedChannelTxID',
      '3': 17,
      '4': 1,
      '5': 9,
      '10': 'closedChannelTxID'
    },
  ],
  '4': [Payment_PaymentType$json],
};

const Payment_PaymentType$json = {
  '1': 'PaymentType',
  '2': [
    {'1': 'DEPOSIT', '2': 0},
    {'1': 'WITHDRAWAL', '2': 1},
    {'1': 'SENT', '2': 2},
    {'1': 'RECEIVED', '2': 3},
    {'1': 'CLOSED_CHANNEL', '2': 4},
  ],
};

const PaymentsList$json = {
  '1': 'PaymentsList',
  '2': [
    {
      '1': 'paymentsList',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.data.Payment',
      '10': 'paymentsList'
    },
  ],
};

const PaymentResponse$json = {
  '1': 'PaymentResponse',
  '2': [
    {'1': 'paymentError', '3': 1, '4': 1, '5': 9, '10': 'paymentError'},
    {'1': 'traceReport', '3': 2, '4': 1, '5': 9, '10': 'traceReport'},
  ],
};

const SendWalletCoinsRequest$json = {
  '1': 'SendWalletCoinsRequest',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'satPerByteFee', '3': 2, '4': 1, '5': 3, '10': 'satPerByteFee'},
  ],
};

const PayInvoiceRequest$json = {
  '1': 'PayInvoiceRequest',
  '2': [
    {'1': 'amount', '3': 1, '4': 1, '5': 3, '10': 'amount'},
    {'1': 'paymentRequest', '3': 2, '4': 1, '5': 9, '10': 'paymentRequest'},
  ],
};

const InvoiceMemo$json = {
  '1': 'InvoiceMemo',
  '2': [
    {'1': 'description', '3': 1, '4': 1, '5': 9, '10': 'description'},
    {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
    {'1': 'payeeName', '3': 3, '4': 1, '5': 9, '10': 'payeeName'},
    {'1': 'payeeImageURL', '3': 4, '4': 1, '5': 9, '10': 'payeeImageURL'},
    {'1': 'payerName', '3': 5, '4': 1, '5': 9, '10': 'payerName'},
    {'1': 'payerImageURL', '3': 6, '4': 1, '5': 9, '10': 'payerImageURL'},
    {'1': 'transferRequest', '3': 7, '4': 1, '5': 8, '10': 'transferRequest'},
    {'1': 'expiry', '3': 8, '4': 1, '5': 3, '10': 'expiry'},
  ],
};

const Invoice$json = {
  '1': 'Invoice',
  '2': [
    {
      '1': 'memo',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.data.InvoiceMemo',
      '10': 'memo'
    },
    {'1': 'settled', '3': 2, '4': 1, '5': 8, '10': 'settled'},
    {'1': 'amtPaid', '3': 3, '4': 1, '5': 3, '10': 'amtPaid'},
  ],
};

const NotificationEvent$json = {
  '1': 'NotificationEvent',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.data.NotificationEvent.NotificationType',
      '10': 'type'
    },
    {'1': 'data', '3': 2, '4': 3, '5': 9, '10': 'data'},
  ],
  '4': [NotificationEvent_NotificationType$json],
};

const NotificationEvent_NotificationType$json = {
  '1': 'NotificationType',
  '2': [
    {'1': 'READY', '2': 0},
    {'1': 'INITIALIZATION_FAILED', '2': 1},
    {'1': 'ACCOUNT_CHANGED', '2': 2},
    {'1': 'PAYMENT_SENT', '2': 3},
    {'1': 'INVOICE_PAID', '2': 4},
    {'1': 'LIGHTNING_SERVICE_DOWN', '2': 5},
    {'1': 'FUND_ADDRESS_CREATED', '2': 6},
    {'1': 'FUND_ADDRESS_UNSPENT_CHANGED', '2': 7},
    {'1': 'BACKUP_SUCCESS', '2': 8},
    {'1': 'BACKUP_FAILED', '2': 9},
    {'1': 'BACKUP_AUTH_FAILED', '2': 10},
    {'1': 'BACKUP_NODE_CONFLICT', '2': 11},
    {'1': 'BACKUP_REQUEST', '2': 12},
  ],
};

const AddFundInitReply$json = {
  '1': 'AddFundInitReply',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {
      '1': 'maxAllowedDeposit',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'maxAllowedDeposit'
    },
    {'1': 'errorMessage', '3': 3, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'backupJson', '3': 4, '4': 1, '5': 9, '10': 'backupJson'},
    {'1': 'requiredReserve', '3': 5, '4': 1, '5': 3, '10': 'requiredReserve'},
  ],
};

const AddFundReply$json = {
  '1': 'AddFundReply',
  '2': [
    {'1': 'errorMessage', '3': 1, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

const RefundRequest$json = {
  '1': 'RefundRequest',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'refundAddress', '3': 2, '4': 1, '5': 9, '10': 'refundAddress'},
    {'1': 'target_conf', '3': 3, '4': 1, '5': 5, '10': 'targetConf'},
    {'1': 'sat_per_byte', '3': 4, '4': 1, '5': 3, '10': 'satPerByte'},
  ],
};

const AddFundError$json = {
  '1': 'AddFundError',
  '2': [
    {
      '1': 'swapAddressInfo',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.data.SwapAddressInfo',
      '10': 'swapAddressInfo'
    },
    {'1': 'hoursToUnlock', '3': 2, '4': 1, '5': 2, '10': 'hoursToUnlock'},
  ],
};

const FundStatusReply$json = {
  '1': 'FundStatusReply',
  '2': [
    {
      '1': 'unConfirmedAddresses',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.data.SwapAddressInfo',
      '10': 'unConfirmedAddresses'
    },
    {
      '1': 'confirmedAddresses',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.data.SwapAddressInfo',
      '10': 'confirmedAddresses'
    },
    {
      '1': 'refundableAddresses',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.data.SwapAddressInfo',
      '10': 'refundableAddresses'
    },
  ],
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
    {'1': 'txid', '3': 1, '4': 1, '5': 9, '10': 'txid'},
    {'1': 'errorMessage', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

const SwapAddressInfo$json = {
  '1': 'SwapAddressInfo',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'PaymentHash', '3': 2, '4': 1, '5': 9, '10': 'PaymentHash'},
    {'1': 'ConfirmedAmount', '3': 3, '4': 1, '5': 3, '10': 'ConfirmedAmount'},
    {
      '1': 'ConfirmedTransactionIds',
      '3': 4,
      '4': 3,
      '5': 9,
      '10': 'ConfirmedTransactionIds'
    },
    {'1': 'PaidAmount', '3': 5, '4': 1, '5': 3, '10': 'PaidAmount'},
    {'1': 'lockHeight', '3': 6, '4': 1, '5': 13, '10': 'lockHeight'},
    {'1': 'errorMessage', '3': 7, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'lastRefundTxID', '3': 8, '4': 1, '5': 9, '10': 'lastRefundTxID'},
    {
      '1': 'swapError',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.data.SwapError',
      '10': 'swapError'
    },
    {'1': 'FundingTxID', '3': 10, '4': 1, '5': 9, '10': 'FundingTxID'},
    {'1': 'hoursToUnlock', '3': 11, '4': 1, '5': 2, '10': 'hoursToUnlock'},
  ],
};

const SwapAddressList$json = {
  '1': 'SwapAddressList',
  '2': [
    {
      '1': 'addresses',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.data.SwapAddressInfo',
      '10': 'addresses'
    },
  ],
};

const CreateRatchetSessionRequest$json = {
  '1': 'CreateRatchetSessionRequest',
  '2': [
    {'1': 'secret', '3': 1, '4': 1, '5': 9, '10': 'secret'},
    {'1': 'remotePubKey', '3': 2, '4': 1, '5': 9, '10': 'remotePubKey'},
    {'1': 'sessionID', '3': 3, '4': 1, '5': 9, '10': 'sessionID'},
    {'1': 'expiry', '3': 4, '4': 1, '5': 4, '10': 'expiry'},
  ],
};

const CreateRatchetSessionReply$json = {
  '1': 'CreateRatchetSessionReply',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    {'1': 'secret', '3': 2, '4': 1, '5': 9, '10': 'secret'},
    {'1': 'pubKey', '3': 3, '4': 1, '5': 9, '10': 'pubKey'},
  ],
};

const RatchetSessionInfoReply$json = {
  '1': 'RatchetSessionInfoReply',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    {'1': 'initiated', '3': 2, '4': 1, '5': 8, '10': 'initiated'},
    {'1': 'userInfo', '3': 3, '4': 1, '5': 9, '10': 'userInfo'},
  ],
};

const RatchetSessionSetInfoRequest$json = {
  '1': 'RatchetSessionSetInfoRequest',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    {'1': 'userInfo', '3': 2, '4': 1, '5': 9, '10': 'userInfo'},
  ],
};

const RatchetEncryptRequest$json = {
  '1': 'RatchetEncryptRequest',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

const RatchetDecryptRequest$json = {
  '1': 'RatchetDecryptRequest',
  '2': [
    {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    {'1': 'encryptedMessage', '3': 2, '4': 1, '5': 9, '10': 'encryptedMessage'},
  ],
};

const BootstrapFilesRequest$json = {
  '1': 'BootstrapFilesRequest',
  '2': [
    {'1': 'WorkingDir', '3': 1, '4': 1, '5': 9, '10': 'WorkingDir'},
    {'1': 'FullPaths', '3': 2, '4': 3, '5': 9, '10': 'FullPaths'},
  ],
};

const Peers$json = {
  '1': 'Peers',
  '2': [
    {'1': 'isDefault', '3': 1, '4': 1, '5': 8, '10': 'isDefault'},
    {'1': 'peer', '3': 2, '4': 3, '5': 9, '10': 'peer'},
  ],
};

const TxSpentURL$json = {
  '1': 'TxSpentURL',
  '2': [
    {'1': 'URL', '3': 1, '4': 1, '5': 9, '10': 'URL'},
    {'1': 'isDefault', '3': 2, '4': 1, '5': 8, '10': 'isDefault'},
    {'1': 'disabled', '3': 3, '4': 1, '5': 8, '10': 'disabled'},
  ],
};

const rate$json = {
  '1': 'rate',
  '2': [
    {'1': 'coin', '3': 1, '4': 1, '5': 9, '10': 'coin'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
};

const Rates$json = {
  '1': 'Rates',
  '2': [
    {'1': 'rates', '3': 1, '4': 3, '5': 11, '6': '.data.rate', '10': 'rates'},
  ],
};

const LSPInformation$json = {
  '1': 'LSPInformation',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'widget_url', '3': 2, '4': 1, '5': 9, '10': 'widgetUrl'},
    {'1': 'pubkey', '3': 3, '4': 1, '5': 9, '10': 'pubkey'},
    {'1': 'host', '3': 4, '4': 1, '5': 9, '10': 'host'},
    {'1': 'channel_capacity', '3': 5, '4': 1, '5': 3, '10': 'channelCapacity'},
    {'1': 'target_conf', '3': 6, '4': 1, '5': 5, '10': 'targetConf'},
    {'1': 'base_fee_msat', '3': 7, '4': 1, '5': 3, '10': 'baseFeeMsat'},
    {'1': 'fee_rate', '3': 8, '4': 1, '5': 1, '10': 'feeRate'},
    {'1': 'time_lock_delta', '3': 9, '4': 1, '5': 13, '10': 'timeLockDelta'},
    {'1': 'min_htlc_msat', '3': 10, '4': 1, '5': 3, '10': 'minHtlcMsat'},
  ],
};

const LSPList$json = {
  '1': 'LSPList',
  '2': [
    {
      '1': 'lsps',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.data.LSPList.LspsEntry',
      '10': 'lsps'
    },
  ],
  '3': [LSPList_LspsEntry$json],
};

const LSPList_LspsEntry$json = {
  '1': 'LspsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.data.LSPInformation',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

const LNUrlResponse$json = {
  '1': 'LNUrlResponse',
  '2': [
    {
      '1': 'withdraw',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.data.LNUrlWithdraw',
      '9': 0,
      '10': 'withdraw'
    },
  ],
  '8': [
    {'1': 'action'},
  ],
};

const LNUrlWithdraw$json = {
  '1': 'LNUrlWithdraw',
  '2': [
    {'1': 'min_amount', '3': 1, '4': 1, '5': 3, '10': 'minAmount'},
    {'1': 'max_amount', '3': 2, '4': 1, '5': 3, '10': 'maxAmount'},
    {
      '1': 'default_description',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'defaultDescription'
    },
  ],
};
