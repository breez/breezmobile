///
//  Generated code. Do not modify.
//  source: rpc.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const SwapError$json = const {
  '1': 'SwapError',
  '2': const [
    const {'1': 'NO_ERROR', '2': 0},
    const {'1': 'FUNDS_EXCEED_LIMIT', '2': 1},
    const {'1': 'TX_TOO_SMALL', '2': 2},
    const {'1': 'INVOICE_AMOUNT_MISMATCH', '2': 3},
    const {'1': 'SWAP_EXPIRED', '2': 4},
  ],
};

const ChainStatus$json = const {
  '1': 'ChainStatus',
  '2': const [
    const {'1': 'blockHeight', '3': 1, '4': 1, '5': 13, '10': 'blockHeight'},
    const {'1': 'syncedToChain', '3': 2, '4': 1, '5': 8, '10': 'syncedToChain'},
  ],
};

const Account$json = const {
  '1': 'Account',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'balance', '3': 2, '4': 1, '5': 3, '10': 'balance'},
    const {'1': 'walletBalance', '3': 3, '4': 1, '5': 3, '10': 'walletBalance'},
    const {'1': 'status', '3': 4, '4': 1, '5': 14, '6': '.data.Account.AccountStatus', '10': 'status'},
    const {'1': 'maxAllowedToReceive', '3': 5, '4': 1, '5': 3, '10': 'maxAllowedToReceive'},
    const {'1': 'maxAllowedToPay', '3': 6, '4': 1, '5': 3, '10': 'maxAllowedToPay'},
    const {'1': 'maxPaymentAmount', '3': 7, '4': 1, '5': 3, '10': 'maxPaymentAmount'},
    const {'1': 'routingNodeFee', '3': 8, '4': 1, '5': 3, '10': 'routingNodeFee'},
    const {'1': 'enabled', '3': 9, '4': 1, '5': 8, '10': 'enabled'},
    const {'1': 'maxChanReserve', '3': 10, '4': 1, '5': 3, '10': 'maxChanReserve'},
    const {'1': 'channelPoint', '3': 11, '4': 1, '5': 9, '10': 'channelPoint'},
    const {'1': 'readyForPayments', '3': 12, '4': 1, '5': 8, '10': 'readyForPayments'},
  ],
  '4': const [Account_AccountStatus$json],
};

const Account_AccountStatus$json = const {
  '1': 'AccountStatus',
  '2': const [
    const {'1': 'DISCONNECTED', '2': 0},
    const {'1': 'PROCESSING_CONNECTION', '2': 1},
    const {'1': 'CLOSING_CONNECTION', '2': 2},
    const {'1': 'CONNECTED', '2': 3},
  ],
};

const Payment$json = const {
  '1': 'Payment',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.data.Payment.PaymentType', '10': 'type'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 3, '10': 'amount'},
    const {'1': 'creationTimestamp', '3': 4, '4': 1, '5': 3, '10': 'creationTimestamp'},
    const {'1': 'invoiceMemo', '3': 6, '4': 1, '5': 11, '6': '.data.InvoiceMemo', '10': 'invoiceMemo'},
    const {'1': 'redeemTxID', '3': 7, '4': 1, '5': 9, '10': 'redeemTxID'},
    const {'1': 'paymentHash', '3': 8, '4': 1, '5': 9, '10': 'paymentHash'},
    const {'1': 'destination', '3': 9, '4': 1, '5': 9, '10': 'destination'},
    const {'1': 'PendingExpirationHeight', '3': 10, '4': 1, '5': 13, '10': 'PendingExpirationHeight'},
    const {'1': 'PendingExpirationTimestamp', '3': 11, '4': 1, '5': 3, '10': 'PendingExpirationTimestamp'},
    const {'1': 'fee', '3': 12, '4': 1, '5': 3, '10': 'fee'},
    const {'1': 'preimage', '3': 13, '4': 1, '5': 9, '10': 'preimage'},
  ],
  '4': const [Payment_PaymentType$json],
};

const Payment_PaymentType$json = const {
  '1': 'PaymentType',
  '2': const [
    const {'1': 'DEPOSIT', '2': 0},
    const {'1': 'WITHDRAWAL', '2': 1},
    const {'1': 'SENT', '2': 2},
    const {'1': 'RECEIVED', '2': 3},
  ],
};

const PaymentsList$json = const {
  '1': 'PaymentsList',
  '2': const [
    const {'1': 'paymentsList', '3': 1, '4': 3, '5': 11, '6': '.data.Payment', '10': 'paymentsList'},
  ],
};

const PaymentResponse$json = const {
  '1': 'PaymentResponse',
  '2': const [
    const {'1': 'paymentError', '3': 1, '4': 1, '5': 9, '10': 'paymentError'},
    const {'1': 'traceReport', '3': 2, '4': 1, '5': 9, '10': 'traceReport'},
  ],
};

const SendWalletCoinsRequest$json = const {
  '1': 'SendWalletCoinsRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'satPerByteFee', '3': 2, '4': 1, '5': 3, '10': 'satPerByteFee'},
  ],
};

const PayInvoiceRequest$json = const {
  '1': 'PayInvoiceRequest',
  '2': const [
    const {'1': 'amount', '3': 1, '4': 1, '5': 3, '10': 'amount'},
    const {'1': 'paymentRequest', '3': 2, '4': 1, '5': 9, '10': 'paymentRequest'},
  ],
};

const InvoiceMemo$json = const {
  '1': 'InvoiceMemo',
  '2': const [
    const {'1': 'description', '3': 1, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
    const {'1': 'payeeName', '3': 3, '4': 1, '5': 9, '10': 'payeeName'},
    const {'1': 'payeeImageURL', '3': 4, '4': 1, '5': 9, '10': 'payeeImageURL'},
    const {'1': 'payerName', '3': 5, '4': 1, '5': 9, '10': 'payerName'},
    const {'1': 'payerImageURL', '3': 6, '4': 1, '5': 9, '10': 'payerImageURL'},
    const {'1': 'transferRequest', '3': 7, '4': 1, '5': 8, '10': 'transferRequest'},
    const {'1': 'expiry', '3': 8, '4': 1, '5': 3, '10': 'expiry'},
  ],
};

const Invoice$json = const {
  '1': 'Invoice',
  '2': const [
    const {'1': 'memo', '3': 1, '4': 1, '5': 11, '6': '.data.InvoiceMemo', '10': 'memo'},
    const {'1': 'settled', '3': 2, '4': 1, '5': 8, '10': 'settled'},
    const {'1': 'amtPaid', '3': 3, '4': 1, '5': 3, '10': 'amtPaid'},
  ],
};

const NotificationEvent$json = const {
  '1': 'NotificationEvent',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.data.NotificationEvent.NotificationType', '10': 'type'},
    const {'1': 'data', '3': 2, '4': 3, '5': 9, '10': 'data'},
  ],
  '4': const [NotificationEvent_NotificationType$json],
};

const NotificationEvent_NotificationType$json = const {
  '1': 'NotificationType',
  '2': const [
    const {'1': 'READY', '2': 0},
    const {'1': 'INITIALIZATION_FAILED', '2': 1},
    const {'1': 'ACCOUNT_CHANGED', '2': 2},
    const {'1': 'PAYMENT_SENT', '2': 3},
    const {'1': 'INVOICE_PAID', '2': 4},
    const {'1': 'LIGHTNING_SERVICE_DOWN', '2': 5},
    const {'1': 'FUND_ADDRESS_CREATED', '2': 6},
    const {'1': 'FUND_ADDRESS_UNSPENT_CHANGED', '2': 7},
    const {'1': 'BACKUP_SUCCESS', '2': 8},
    const {'1': 'BACKUP_FAILED', '2': 9},
    const {'1': 'BACKUP_AUTH_FAILED', '2': 10},
    const {'1': 'BACKUP_NODE_CONFLICT', '2': 11},
    const {'1': 'BACKUP_REQUEST', '2': 12},
  ],
};

const AddFundInitReply$json = const {
  '1': 'AddFundInitReply',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'maxAllowedDeposit', '3': 2, '4': 1, '5': 3, '10': 'maxAllowedDeposit'},
    const {'1': 'errorMessage', '3': 3, '4': 1, '5': 9, '10': 'errorMessage'},
    const {'1': 'backupJson', '3': 4, '4': 1, '5': 9, '10': 'backupJson'},
    const {'1': 'requiredReserve', '3': 5, '4': 1, '5': 3, '10': 'requiredReserve'},
  ],
};

const AddFundReply$json = const {
  '1': 'AddFundReply',
  '2': const [
    const {'1': 'errorMessage', '3': 1, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

const RefundRequest$json = const {
  '1': 'RefundRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'refundAddress', '3': 2, '4': 1, '5': 9, '10': 'refundAddress'},
    const {'1': 'target_conf', '3': 3, '4': 1, '5': 5, '10': 'targetConf'},
    const {'1': 'sat_per_byte', '3': 4, '4': 1, '5': 3, '10': 'satPerByte'},
  ],
};

const AddFundError$json = const {
  '1': 'AddFundError',
  '2': const [
    const {'1': 'swapAddressInfo', '3': 1, '4': 1, '5': 11, '6': '.data.SwapAddressInfo', '10': 'swapAddressInfo'},
    const {'1': 'hoursToUnlock', '3': 2, '4': 1, '5': 2, '10': 'hoursToUnlock'},
  ],
};

const FundStatusReply$json = const {
  '1': 'FundStatusReply',
  '2': const [
    const {'1': 'unConfirmedAddresses', '3': 1, '4': 3, '5': 11, '6': '.data.SwapAddressInfo', '10': 'unConfirmedAddresses'},
    const {'1': 'confirmedAddresses', '3': 2, '4': 3, '5': 11, '6': '.data.SwapAddressInfo', '10': 'confirmedAddresses'},
    const {'1': 'refundableAddresses', '3': 3, '4': 3, '5': 11, '6': '.data.SwapAddressInfo', '10': 'refundableAddresses'},
  ],
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
    const {'1': 'txid', '3': 1, '4': 1, '5': 9, '10': 'txid'},
    const {'1': 'errorMessage', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

const SwapAddressInfo$json = const {
  '1': 'SwapAddressInfo',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'PaymentHash', '3': 2, '4': 1, '5': 9, '10': 'PaymentHash'},
    const {'1': 'ConfirmedAmount', '3': 3, '4': 1, '5': 3, '10': 'ConfirmedAmount'},
    const {'1': 'ConfirmedTransactionIds', '3': 4, '4': 3, '5': 9, '10': 'ConfirmedTransactionIds'},
    const {'1': 'PaidAmount', '3': 5, '4': 1, '5': 3, '10': 'PaidAmount'},
    const {'1': 'lockHeight', '3': 6, '4': 1, '5': 13, '10': 'lockHeight'},
    const {'1': 'errorMessage', '3': 7, '4': 1, '5': 9, '10': 'errorMessage'},
    const {'1': 'lastRefundTxID', '3': 8, '4': 1, '5': 9, '10': 'lastRefundTxID'},
    const {'1': 'swapError', '3': 9, '4': 1, '5': 14, '6': '.data.SwapError', '10': 'swapError'},
    const {'1': 'FundingTxID', '3': 10, '4': 1, '5': 9, '10': 'FundingTxID'},
    const {'1': 'hoursToUnlock', '3': 11, '4': 1, '5': 2, '10': 'hoursToUnlock'},
  ],
};

const SwapAddressList$json = const {
  '1': 'SwapAddressList',
  '2': const [
    const {'1': 'addresses', '3': 1, '4': 3, '5': 11, '6': '.data.SwapAddressInfo', '10': 'addresses'},
  ],
};

const CreateRatchetSessionRequest$json = const {
  '1': 'CreateRatchetSessionRequest',
  '2': const [
    const {'1': 'secret', '3': 1, '4': 1, '5': 9, '10': 'secret'},
    const {'1': 'remotePubKey', '3': 2, '4': 1, '5': 9, '10': 'remotePubKey'},
    const {'1': 'sessionID', '3': 3, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'expiry', '3': 4, '4': 1, '5': 4, '10': 'expiry'},
  ],
};

const CreateRatchetSessionReply$json = const {
  '1': 'CreateRatchetSessionReply',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'secret', '3': 2, '4': 1, '5': 9, '10': 'secret'},
    const {'1': 'pubKey', '3': 3, '4': 1, '5': 9, '10': 'pubKey'},
  ],
};

const RatchetSessionInfoReply$json = const {
  '1': 'RatchetSessionInfoReply',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'initiated', '3': 2, '4': 1, '5': 8, '10': 'initiated'},
    const {'1': 'userInfo', '3': 3, '4': 1, '5': 9, '10': 'userInfo'},
  ],
};

const RatchetSessionSetInfoRequest$json = const {
  '1': 'RatchetSessionSetInfoRequest',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'userInfo', '3': 2, '4': 1, '5': 9, '10': 'userInfo'},
  ],
};

const RatchetEncryptRequest$json = const {
  '1': 'RatchetEncryptRequest',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

const RatchetDecryptRequest$json = const {
  '1': 'RatchetDecryptRequest',
  '2': const [
    const {'1': 'sessionID', '3': 1, '4': 1, '5': 9, '10': 'sessionID'},
    const {'1': 'encryptedMessage', '3': 2, '4': 1, '5': 9, '10': 'encryptedMessage'},
  ],
};

const BootstrapFilesRequest$json = const {
  '1': 'BootstrapFilesRequest',
  '2': const [
    const {'1': 'WorkingDir', '3': 1, '4': 1, '5': 9, '10': 'WorkingDir'},
    const {'1': 'FullPaths', '3': 2, '4': 3, '5': 9, '10': 'FullPaths'},
  ],
};

const Peers$json = const {
  '1': 'Peers',
  '2': const [
    const {'1': 'isDefault', '3': 1, '4': 1, '5': 8, '10': 'isDefault'},
    const {'1': 'peer', '3': 2, '4': 3, '5': 9, '10': 'peer'},
  ],
};

const rate$json = const {
  '1': 'rate',
  '2': const [
    const {'1': 'coin', '3': 1, '4': 1, '5': 9, '10': 'coin'},
    const {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
};

const Rates$json = const {
  '1': 'Rates',
  '2': const [
    const {'1': 'rates', '3': 1, '4': 3, '5': 11, '6': '.data.rate', '10': 'rates'},
  ],
};

const LSPInformation$json = const {
  '1': 'LSPInformation',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'widget_url', '3': 2, '4': 1, '5': 9, '10': 'widgetUrl'},
    const {'1': 'pubkey', '3': 3, '4': 1, '5': 9, '10': 'pubkey'},
    const {'1': 'host', '3': 4, '4': 1, '5': 9, '10': 'host'},
    const {'1': 'channel_capacity', '3': 5, '4': 1, '5': 3, '10': 'channelCapacity'},
    const {'1': 'target_conf', '3': 6, '4': 1, '5': 5, '10': 'targetConf'},
    const {'1': 'base_fee_msat', '3': 7, '4': 1, '5': 3, '10': 'baseFeeMsat'},
    const {'1': 'fee_rate', '3': 8, '4': 1, '5': 1, '10': 'feeRate'},
    const {'1': 'time_lock_delta', '3': 9, '4': 1, '5': 13, '10': 'timeLockDelta'},
    const {'1': 'min_htlc_msat', '3': 10, '4': 1, '5': 3, '10': 'minHtlcMsat'},
  ],
};

const LSPList$json = const {
  '1': 'LSPList',
  '2': const [
    const {'1': 'lsps', '3': 1, '4': 3, '5': 11, '6': '.data.LSPList.LspsEntry', '10': 'lsps'},
  ],
  '3': const [LSPList_LspsEntry$json],
};

const LSPList_LspsEntry$json = const {
  '1': 'LspsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.data.LSPInformation', '10': 'value'},
  ],
  '7': const {'7': true},
};

const LNUrlResponse$json = const {
  '1': 'LNUrlResponse',
  '2': const [
    const {'1': 'withdraw', '3': 1, '4': 1, '5': 11, '6': '.data.LNUrlWithdraw', '9': 0, '10': 'withdraw'},
  ],
  '8': const [
    const {'1': 'action'},
  ],
};

const LNUrlWithdraw$json = const {
  '1': 'LNUrlWithdraw',
  '2': const [
    const {'1': 'min_amount', '3': 1, '4': 1, '5': 3, '10': 'minAmount'},
    const {'1': 'max_amount', '3': 2, '4': 1, '5': 3, '10': 'maxAmount'},
    const {'1': 'default_description', '3': 3, '4': 1, '5': 9, '10': 'defaultDescription'},
  ],
};

