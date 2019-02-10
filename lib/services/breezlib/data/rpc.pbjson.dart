///
//  Generated code. Do not modify.
//  source: rpc.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

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
  ],
  '4': const [Account_AccountStatus$json],
};

const Account_AccountStatus$json = const {
  '1': 'AccountStatus',
  '2': const [
    const {'1': 'WAITING_DEPOSIT', '2': 0},
    const {'1': 'WAITING_DEPOSIT_CONFIRMATION', '2': 1},
    const {'1': 'PROCESSING_BREEZ_CONNECTION', '2': 2},
    const {'1': 'PROCESSING_WITHDRAWAL', '2': 3},
    const {'1': 'ACTIVE', '2': 4},
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

const SendWalletCoinsRequest$json = const {
  '1': 'SendWalletCoinsRequest',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 3, '10': 'amount'},
    const {'1': 'satPerByteFee', '3': 3, '4': 1, '5': 3, '10': 'satPerByteFee'},
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
    const {'1': 'INVOICE_PAID', '2': 3},
    const {'1': 'ROUTING_NODE_CONNECTION_CHANGED', '2': 4},
    const {'1': 'LIGHTNING_SERVICE_DOWN', '2': 5},
    const {'1': 'FUND_ADDRESS_UNSPENT_CHANGED', '2': 6},
    const {'1': 'BACKUP_SUCCESS', '2': 7},
    const {'1': 'BACKUP_FAILED', '2': 8},
    const {'1': 'BACKUP_AUTH_FAILED', '2': 9},
  ],
};

const AddFundInitReply$json = const {
  '1': 'AddFundInitReply',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'maxAllowedDeposit', '3': 2, '4': 1, '5': 3, '10': 'maxAllowedDeposit'},
    const {'1': 'errorMessage', '3': 3, '4': 1, '5': 9, '10': 'errorMessage'},
    const {'1': 'backupJson', '3': 4, '4': 1, '5': 9, '10': 'backupJson'},
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
  ],
};

const FundStatusReply$json = const {
  '1': 'FundStatusReply',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.data.FundStatusReply.FundStatus', '10': 'status'},
  ],
  '4': const [FundStatusReply_FundStatus$json],
};

const FundStatusReply_FundStatus$json = const {
  '1': 'FundStatus',
  '2': const [
    const {'1': 'NO_FUND', '2': 0},
    const {'1': 'WAITING_CONFIRMATION', '2': 1},
    const {'1': 'CONFIRMED', '2': 2},
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

