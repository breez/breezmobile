import 'dart:math';

import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:fixnum/fixnum.dart';

enum BugReportBehavior {
  PROMPT,
  SEND_REPORT,
  IGNORE
}

enum SyncUIState {
  BLOCKING,
  COLLAPSED,
  NONE
}

class AccountSettings {
  final bool ignoreWalletBalance;
  final bool showConnectProgress;
  final BugReportBehavior failePaymentBehavior;

  AccountSettings(
      this.ignoreWalletBalance,
      {this.showConnectProgress = false,
      this.failePaymentBehavior = BugReportBehavior.PROMPT});
  AccountSettings.start() : this(false);

  AccountSettings copyWith(
      {bool ignoreWalletBalance,
      bool showConnectProgress,
      BugReportBehavior failePaymentBehavior}) {
    return AccountSettings(ignoreWalletBalance ?? this.ignoreWalletBalance,
        failePaymentBehavior:
            failePaymentBehavior ?? this.failePaymentBehavior,
        showConnectProgress: showConnectProgress ?? this.showConnectProgress);
  }

  AccountSettings.fromJson(Map<String, dynamic> json)
      : this(json["ignoreWalletBalance"] ?? false,
            failePaymentBehavior: BugReportBehavior.values[json["failePaymentBehavior"] ?? 0],
            showConnectProgress: json["showConnectProgress"] ?? false);

  Map<String, dynamic> toJson() {
    return {
      "ignoreWalletBalance": ignoreWalletBalance,
      "failePaymentBehavior": failePaymentBehavior.index,
      "showConnectProgress": showConnectProgress ?? false
    };
  }
}

class SwapFundStatus {
  final FundStatusReply _addedFundsReply;

  SwapFundStatus(this._addedFundsReply);

  String get unconfirmedTxID {
      if (_addedFundsReply == null || _addedFundsReply.unConfirmedAddresses.length == 0) {
        return null;
      }
      return _addedFundsReply.unConfirmedAddresses[0].fundingTxID;
  }

  bool get depositConfirmed {
      var waitingPaymentAddresses = _addedFundsReply?.confirmedAddresses?.where((a) => a.errorMessage.isEmpty);
      return waitingPaymentAddresses != null && waitingPaymentAddresses.length > 0;
  }

  // in case of status is error, these fields will be populated.
  String get error {
    var refundAddresses = refundableAddresses;
    if (refundAddresses.isNotEmpty) {
      return refundAddresses[0].refundableError;
    }

    var errorAddresses = _addedFundsReply?.confirmedAddresses?.where((a) => a.errorMessage.isNotEmpty);    
    if (errorAddresses == null || errorAddresses.isEmpty) {
      return null;
    }

    return errorAddresses.first.errorMessage;
  }

  List<RefundableAddress> get refundableAddresses {
    var refundableAddresses = _addedFundsReply?.refundableAddresses ?? List<RefundableAddress>();
    return refundableAddresses.map((a) => RefundableAddress(a)).toList();
  }

  List<RefundableAddress> get maturedRefundableAddresses {
    return refundableAddresses.where((a) => a.hoursToUnlock <= 0).toList();
  }
}

class RefundableAddress {
  final SwapAddressInfo _refundableInfo;

  RefundableAddress(this._refundableInfo);

  String get address => _refundableInfo.address;
  String get lastRefundTxID => _refundableInfo.lastRefundTxID;
  Int64 get confirmedAmount => _refundableInfo.confirmedAmount;
  int get lockHeight => _refundableInfo.lockHeight;
  double get hoursToUnlock => _refundableInfo.hoursToUnlock;
  String get refundableError {
    switch(_refundableInfo.swapError) {
      case SwapError.FUNDS_EXCEED_LIMIT:
        return "the executed transaction was above the specified limit.";
      case SwapError.INVOICE_AMOUNT_MISMATCH:
        return "the requested amount doesn't match the original transaction.";
      case SwapError.SWAP_EXPIRED:
        return " the transaction had expired.";
      case SwapError.TX_TOO_SMALL:
        return "the transaction size was too small to process.";
      default:
        return null;
    }
  }
}

class AccountModel {
  final Account _accountResponse;
  final Currency _currency;
  final String _fiatShortName;
  final FiatConversion _fiatCurrency;
  final List<FiatConversion> _fiatConversionList;
  final FundStatusReply addedFundsReply;
  final String paymentRequestInProgress;
  final bool connected;
  final Int64 onChainFeeRate;
  final bool initial;
  final bool bootstraping;
  final double bootstrapProgress;
  final bool enableInProgress;
  final double syncProgress;
  final SyncUIState syncUIState;

  AccountModel(this._accountResponse, this._currency, this._fiatShortName, this._fiatCurrency, this._fiatConversionList,
      {this.initial = true,
      this.addedFundsReply,
      this.paymentRequestInProgress,
      this.connected = false,
      this.onChainFeeRate,
      this.bootstraping = false,
      this.enableInProgress = false,
      this.bootstrapProgress = 0,
      this.syncProgress = 0,
      this.syncUIState = SyncUIState.NONE});

  AccountModel.initial()
      : this(
            Account()
              ..balance = Int64(0)
              ..walletBalance = Int64(0)
              ..status = Account_AccountStatus.WAITING_DEPOSIT
              ..maxAllowedToReceive = Int64(0)
              ..maxPaymentAmount = Int64(0)
              ..enabled = true,
            Currency.SAT,
            "USD",
            null,
            List(),
            initial: true,
            bootstraping: true);
  AccountModel copyWith(
      {Account accountResponse,
      Currency currency,
      String fiatShortName,
      FiatConversion fiatCurrency,
      List<FiatConversion> fiatConversionList,
      FundStatusReply addedFundsReply,
      String paymentRequestInProgress,
      bool connected,
      Int64 onChainFeeRate,
      bool bootstraping,
      bool enableInProgress,
      double bootstrapProgress,
      double syncProgress,
      bool initial,
      SyncUIState syncUIState}) {
    return AccountModel(
        accountResponse ?? this._accountResponse, currency ?? this.currency,
        fiatShortName ?? this._fiatShortName,
        fiatCurrency ?? this._fiatCurrency,
        fiatConversionList ?? this._fiatConversionList,
        addedFundsReply: addedFundsReply ?? this.addedFundsReply,
        connected: connected ?? this.connected,
        onChainFeeRate: onChainFeeRate ?? this.onChainFeeRate,
        bootstraping: bootstraping ?? this.bootstraping,
        bootstrapProgress: bootstrapProgress ?? this.bootstrapProgress,
        enableInProgress: enableInProgress ?? this.enableInProgress,
        paymentRequestInProgress:
            paymentRequestInProgress ?? this.paymentRequestInProgress,
        syncProgress: syncProgress ?? this.syncProgress,
        syncUIState: syncUIState ?? this.syncUIState,
        initial: initial ?? this.initial);
  }

  String get id => _accountResponse.id;
  SwapFundStatus get swapFundsStatus => SwapFundStatus(this.addedFundsReply);
  bool get processingBreezConnection =>
      _accountResponse.status ==
      Account_AccountStatus.PROCESSING_BREEZ_CONNECTION;
  bool get processingWithdrawal =>
      _accountResponse.status == Account_AccountStatus.PROCESSING_WITHDRAWAL;
  bool get active => _accountResponse.status == Account_AccountStatus.ACTIVE;
  bool get isInitialBootstrap =>
      (bootstraping ||
      (!active && !processingWithdrawal && !processingBreezConnection)) && !initial;
  Int64 get balance => _accountResponse.balance;
  String get formattedFiatBalance => fiatCurrency?.format(balance);
  Int64 get walletBalance => _accountResponse.walletBalance;
  String get statusLine => _accountResponse.status.toString();
  Currency get currency => _currency;
  FiatConversion get fiatCurrency => _fiatConversionList.firstWhere((f) => f.currencyData.shortName == _fiatShortName, orElse: () => null);
  List<FiatConversion> get fiatConversionList => _fiatConversionList;
  Int64 get maxAllowedToReceive => _accountResponse.maxAllowedToReceive;
  Int64 get maxAllowedToPay => Int64(min(
      _accountResponse.maxAllowedToPay.toInt(),
      _accountResponse.maxPaymentAmount.toInt()));
  Int64 get reserveAmount => balance - maxAllowedToPay;
  Int64 get warningMaxChanReserveAmount => _accountResponse.maxChanReserve;
  Int64 get maxPaymentAmount => _accountResponse.maxPaymentAmount;
  Int64 get routingNodeFee => _accountResponse.routingNodeFee;
  bool get enabled => _accountResponse.enabled;
  bool get synced => syncProgress == 1.0;

  String get statusMessage {

    if (this.isInitialBootstrap) {
      return "Please wait a minute while Breez is bootstrapping (keep the app open).";
    }

    if (this.processingBreezConnection) {
      return "Breez is opening a secure channel with our server. This might take a while, but don't worry, we'll notify when the app is ready to send and receive payments. Confirming the opening transaction on chain might take up to one hour.";
    }

    SwapFundStatus swapStatus = this.swapFundsStatus;

    if (swapStatus.unconfirmedTxID != null) {
      return "Breez is waiting for Bitcoin transfer to be confirmed. This might take a while";
    }

    if (this.transferringOnChainDeposit) {
      return "Transferring funds";
    }

    if (swapStatus.error?.isNotEmpty == true) {
      return "Failed to add funds: " + swapStatus.error;
    }

    return null;
  }

  bool get transferringOnChainDeposit => swapFundsStatus.depositConfirmed && this.active;  

  String validateOutgoingOnChainPayment(Int64 amount) {
    if (amount > walletBalance) {
      String message = "Not enough funds.";
      return message;
    }
    return null;
  }

  String validateOutgoingPayment(Int64 amount) {
    return validatePayment(amount, true);
  }

  String validateIncomingPayment(Int64 amount) {
    return validatePayment(amount, false);
  }

  String validatePayment(Int64 amount, bool outgoing) {
    Int64 maxAmount = outgoing ? balance : maxAllowedToReceive;
    if (maxPaymentAmount != null && amount > maxPaymentAmount) {
      return 'Payment exceeds the limit (${currency.format(maxPaymentAmount)})';
    }

    if (amount > maxAmount) {
      return "Not enough funds.";
    }

    if (outgoing && amount > maxAllowedToPay) {
      return "Breez requires you to keep ${currency.format(reserveAmount)} in your balance.";
    }

    return null;
  }
}

class PaymentsModel {
  final List<PaymentInfo> nonFilteredItems;
  final List<PaymentInfo> paymentsList;
  final PaymentFilterModel filter;
  final DateTime firstDate;

  PaymentsModel(this.nonFilteredItems, this.paymentsList, this.filter, [this.firstDate]);

  PaymentsModel.initial()
      : this(List<PaymentInfo>(), List<PaymentInfo>(), PaymentFilterModel.initial(),
            DateTime(DateTime.now().year));

  PaymentsModel copyWith(
      {List<PaymentInfo> nonFilteredItems,
      List<PaymentInfo> paymentsList,
      PaymentFilterModel filter,
      DateTime firstDate}) {
    return PaymentsModel(nonFilteredItems ?? this.nonFilteredItems, paymentsList ?? this.paymentsList,
        filter ?? this.filter, firstDate ?? this.firstDate);
  }
}

class PaymentFilterModel {
  final List<PaymentType> paymentType;
  final DateTime startDate;
  final DateTime endDate;
  final bool initial;

  PaymentFilterModel(this.paymentType, this.startDate, this.endDate,
      {this.initial = false});

  PaymentFilterModel.initial()
      : this([
          PaymentType.SENT,
          PaymentType.DEPOSIT,
          PaymentType.WITHDRAWAL,
          PaymentType.RECEIVED
        ], null, null, initial: true);

  PaymentFilterModel copyWith(
      {List<PaymentType> filter, DateTime startDate, DateTime endDate}) {
    return PaymentFilterModel(filter ?? this.paymentType,
        startDate ?? this.startDate, endDate ?? this.endDate);
  }
}

enum PaymentType { DEPOSIT, WITHDRAWAL, SENT, RECEIVED }

class PaymentInfo {
  final Payment _paymentResponse;
  final Currency _currency;

  Map _typeMap = {
    Payment_PaymentType.DEPOSIT: PaymentType.DEPOSIT,
    Payment_PaymentType.WITHDRAWAL: PaymentType.WITHDRAWAL,
    Payment_PaymentType.SENT: PaymentType.SENT,
    Payment_PaymentType.RECEIVED: PaymentType.RECEIVED,
  };

  PaymentType get type => _typeMap[_paymentResponse.type];
  Int64 get amount => _paymentResponse.amount;
  Int64 get fee => _paymentResponse.fee;
  Int64 get creationTimestamp => _paymentResponse.creationTimestamp;
  String get destination => _paymentResponse.destination;
  String get redeemTxID => _paymentResponse.redeemTxID;
  String get paymentHash => _paymentResponse.paymentHash;
  String get preimage => _paymentResponse.preimage;
  bool get pending => _paymentResponse.pendingExpirationHeight > 0;
  int get pendingExpirationHeight => _paymentResponse.pendingExpirationHeight;
  Int64 get pendingExpirationTimestamp =>
      _paymentResponse.pendingExpirationTimestamp;

  bool get containsPaymentInfo {
    String remoteName = (type == PaymentType.SENT
        ? _paymentResponse.invoiceMemo?.payeeName
        : _paymentResponse.invoiceMemo?.payerName);
    String description = _paymentResponse.invoiceMemo?.description;
    return remoteName?.isNotEmpty == true || description.isNotEmpty == true;
  }

  bool get isTransferRequest =>
      _paymentResponse?.invoiceMemo?.transferRequest == true;

  String get description =>
      _paymentResponse.invoiceMemo.description.startsWith("Bitrefill")
          ? _paymentResponse.invoiceMemo.description
              .substring(10, _paymentResponse.invoiceMemo.description.length)
          : type == PaymentType.DEPOSIT || type == PaymentType.WITHDRAWAL
              ? "Bitcoin Transfer"
              : _paymentResponse.invoiceMemo?.description;

  String get imageURL {
    if (_paymentResponse.invoiceMemo.description.startsWith("Bitrefill")) {
      return "src/icon/vendors/bitrefill_logo.png";
    }
    if (_paymentResponse.invoiceMemo.description.startsWith("Fastbitcoins")) {
      return "src/icon/vendors/fastbitcoins_logo.png";
    }
    if (_paymentResponse.invoiceMemo.description.startsWith("LN.pizza")) {
      return "src/icon/vendors/lnpizza_logo.png";
    }

    String url = (type == PaymentType.SENT
        ? _paymentResponse.invoiceMemo?.payeeImageURL
        : _paymentResponse.invoiceMemo?.payerImageURL);
    return (url == null || url.isEmpty) ? null : url;
  }

  String get title {
    if (_paymentResponse.invoiceMemo.description.startsWith("Bitrefill")) {
      return "Bitrefill";
    }
    if (_paymentResponse.invoiceMemo.description.startsWith("LN.pizza")) {
      return "ln.pizza";
    }

    if (type == PaymentType.DEPOSIT || type == PaymentType.WITHDRAWAL) {
      return "Bitcoin Transfer";
    }
    String result = (type == PaymentType.SENT
        ? _paymentResponse.invoiceMemo?.payeeName
        : _paymentResponse.invoiceMemo?.payerName);
    if (result == null || result.isEmpty) {
      result = _paymentResponse.invoiceMemo.description;
    }
    return (result == null || result.isEmpty) ? "Unknown" : result;
  }

  Currency get currency => _currency;

  PaymentInfo(this._paymentResponse, this._currency);

  PaymentInfo copyWith(Currency currency) {
    return PaymentInfo(this._paymentResponse, currency);
  }
}

class AddFundResponse {
  AddFundInitReply _addfundReply;
  AddFundResponse(this._addfundReply);

  String get errorMessage => _addfundReply.errorMessage;
  Int64 get maxAllowedDeposit => _addfundReply.maxAllowedDeposit;
  String get address => _addfundReply.address;
  String get backupJson => _addfundReply.backupJson;
  Int64 get requiredReserve => _addfundReply.requiredReserve;
}

class RemoveFundRequestModel {
  final Int64 amount;
  final String address;
  final bool fromWallet;
  final Int64 satPerByteFee;

  RemoveFundRequestModel(this.amount, this.address,
      {this.fromWallet = false, this.satPerByteFee});
}

class RemoveFundResponseModel {
  final String transactionID;
  final String errorMessage;

  RemoveFundResponseModel(this.transactionID, {this.errorMessage});
}

class RefundableDepositModel {
  final SwapAddressInfo _address;
  RefundableDepositModel(this._address);

  String get address => _address.address;
  Int64 get confirmedAmount => _address.confirmedAmount;
  bool get refundBroadcasted =>
      _address.lastRefundTxID != null && _address.lastRefundTxID.isNotEmpty;
}

class BroadcastRefundRequestModel {
  final String fromAddress;
  final String toAddress;

  BroadcastRefundRequestModel(this.fromAddress, this.toAddress);
}

class BroadcastRefundResponseModel {
  final BroadcastRefundRequestModel request;
  final String txID;

  BroadcastRefundResponseModel(this.request, this.txID);
}

class PayRequest {
  final String paymentRequest;
  final Int64 amount;

  PayRequest(this.paymentRequest, this.amount);
}

class CompletedPayment {
  final PayRequest paymentRequest;
  final bool cancelled;

  CompletedPayment(this.paymentRequest, {this.cancelled = false});
}

class PaymentError implements Exception {
  final PayRequest request;
  final Object error;
  final String traceReport;
  bool get validationError => error.toString().indexOf("rpc error") >= 0 || traceReport == null || traceReport.isEmpty;

  PaymentError(this.request, this.error, this.traceReport);

  String errMsg() => error?.toString();
  String toString() => errMsg();
}
