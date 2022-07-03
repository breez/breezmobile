import 'dart:convert';
import 'dart:math';

import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:breez/bloc/pos_catalog/model.dart';
import 'package:breez/bloc/user_profile/currency.dart';
import 'package:breez/services/breezlib/data/rpc.pb.dart';
import 'package:breez/utils/date.dart';
import 'package:breez/utils/locale.dart';
import 'package:fixnum/fixnum.dart';

enum BugReportBehavior {
  PROMPT,
  SEND_REPORT,
  IGNORE,
}

enum SyncUIState {
  BLOCKING,
  COLLAPSED,
  NONE,
}

Map<String, String> paymentErrorsMapping() {
  final texts = getSystemAppLocalizations();
  return {
    "FAILURE_REASON_INSUFFICIENT_BALANCE":
        texts.payment_error_insufficient_balance,
    "FAILURE_REASON_INCORRECT_PAYMENT_DETAILS":
        texts.payment_error_incorrect_payment_details,
    "FAILURE_REASON_ERROR": texts.payment_error_unexpected_error,
    "FAILURE_REASON_NO_ROUTE": texts.payment_error_no_route,
    "FAILURE_REASON_TIMEOUT": texts.payment_error_payment_timeout_exceeded,
    "FAILURE_REASON_NONE": texts.payment_error_none,
  };
}

const initialInboundCapacity = 4000000;

class AccountSettings {
  final bool ignoreWalletBalance;
  final bool showConnectProgress;
  final BugReportBehavior failedPaymentBehavior;
  final bool isEscherEnabled;

  const AccountSettings(
    this.ignoreWalletBalance, {
    this.showConnectProgress = false,
    this.failedPaymentBehavior = BugReportBehavior.PROMPT,
    this.isEscherEnabled = false,
  });

  AccountSettings.start() : this(false);

  AccountSettings copyWith({
    bool ignoreWalletBalance,
    bool showConnectProgress,
    BugReportBehavior failedPaymentBehavior,
    bool isEscherEnabled,
  }) {
    return AccountSettings(
      ignoreWalletBalance ?? this.ignoreWalletBalance,
      showConnectProgress: showConnectProgress ?? this.showConnectProgress,
      failedPaymentBehavior:
          failedPaymentBehavior ?? this.failedPaymentBehavior,
      isEscherEnabled: isEscherEnabled ?? this.isEscherEnabled,
    );
  }

  // typo isn't fixed on json to prevent unexpected behavior
  AccountSettings.fromJson(Map<String, dynamic> json)
      : this(
          json["ignoreWalletBalance"] ?? false,
          showConnectProgress: json["showConnectProgress"] ?? false,
          failedPaymentBehavior:
              BugReportBehavior.values[json["failePaymentBehavior"] ?? 0],
          isEscherEnabled: json["isEscherEnabled"] ?? false,
        );

  Map<String, dynamic> toJson() {
    return {
      "ignoreWalletBalance": ignoreWalletBalance,
      "showConnectProgress": showConnectProgress,
      "failePaymentBehavior": failedPaymentBehavior.index,
      "isEscherEnabled": isEscherEnabled
    };
  }
}

class SwapFundStatus {
  final FundStatusReply _addedFundsReply;

  const SwapFundStatus(
    this._addedFundsReply,
  );

  String get unconfirmedTxID {
    if (_addedFundsReply == null) {
      return null;
    }
    var nonBlocking = _addedFundsReply.unConfirmedAddresses
        .where((a) => a.nonBlocking != true)
        .toList();
    if (nonBlocking.length == 0) {
      return null;
    }
    return nonBlocking[0].fundingTxID;
  }

  bool get depositConfirmed {
    var waitingPaymentAddresses = _addedFundsReply?.confirmedAddresses
        ?.where((a) => a.errorMessage.isEmpty);
    return waitingPaymentAddresses != null &&
        waitingPaymentAddresses.length > 0;
  }

  // in case of status is error, these fields will be populated.
  String get error {
    var refundAddresses = refundableAddresses;
    if (refundAddresses.isNotEmpty) {
      return refundAddresses[0].refundableError;
    }

    var errorAddresses = _addedFundsReply?.confirmedAddresses
        ?.where((a) => a.errorMessage.isNotEmpty);
    if (errorAddresses == null || errorAddresses.isEmpty) {
      return null;
    }

    return errorAddresses.first.errorMessage;
  }

  List<String> get unConfirmedAddresses {
    var unConfirmedAddresses =
        _addedFundsReply?.unConfirmedAddresses ?? <SwapAddressInfo>[];
    return unConfirmedAddresses
        .where((a) => a.nonBlocking != true)
        .map((a) => a.address)
        .toList();
  }

  List<String> get confirmedAddresses {
    var unConfirmedAddresses =
        _addedFundsReply?.confirmedAddresses ?? <SwapAddressInfo>[];
    return unConfirmedAddresses.map((a) => a.address).toList();
  }

  List<RefundableAddress> get refundableAddresses {
    var refundableAddresses =
        _addedFundsReply?.refundableAddresses ?? <SwapAddressInfo>[];
    return refundableAddresses.map((a) => RefundableAddress(a)).toList();
  }

  List<RefundableAddress> get maturedRefundableAddresses {
    return refundableAddresses.where((a) => a.hoursToUnlock <= 0).toList();
  }

  List<RefundableAddress> get waitingRefundAddresses {
    return refundableAddresses.where((r) => r.lastRefundTxID.isEmpty).toList();
  }
}

class RefundableAddress {
  final SwapAddressInfo _refundableInfo;

  RefundableAddress(this._refundableInfo);

  String get address => _refundableInfo.address;

  String get lastRefundTxID => _refundableInfo.lastRefundTxID;

  Int64 get confirmedAmount => _refundableInfo.confirmedAmount;

  List<String> get confirmedTransactionIds =>
      _refundableInfo.confirmedTransactionIds;

  int get lockHeight => _refundableInfo.lockHeight;

  double get hoursToUnlock => _refundableInfo.hoursToUnlock;

  String get refundableError {
    final texts = getSystemAppLocalizations();
    switch (_refundableInfo.swapError) {
      case SwapError.FUNDS_EXCEED_LIMIT:
        return texts.swap_error_funds_exceed_limit;
      case SwapError.INVOICE_AMOUNT_MISMATCH:
        return texts.swap_error_invoice_amount_mismatch;
      case SwapError.SWAP_EXPIRED:
        return texts.swap_error_swap_expired;
      case SwapError.TX_TOO_SMALL:
        return texts.swap_error_tx_too_small;
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
  final List<String> preferredCurrencies;
  final String _posCurrencyShortName;
  final FundStatusReply addedFundsReply;
  final Int64 onChainFeeRate;
  final bool initial;
  final bool enableInProgress;
  final double syncProgress;
  final bool syncedToChain;
  final bool serverReady;
  final SyncUIState syncUIState;

  AccountModel(
    this._accountResponse,
    this._currency,
    this._fiatShortName,
    this._fiatCurrency,
    this._fiatConversionList,
    this.preferredCurrencies,
    this._posCurrencyShortName, {
    this.initial = true,
    this.addedFundsReply,
    this.onChainFeeRate,
    this.enableInProgress = false,
    this.syncProgress = 0,
    this.syncedToChain = false,
    this.serverReady = false,
    this.syncUIState = SyncUIState.NONE,
  });

  AccountModel.initial()
      : this(
          Account()
            ..balance = Int64(0)
            ..walletBalance = Int64(0)
            ..status = Account_AccountStatus.DISCONNECTED
            ..maxAllowedToReceive = Int64(initialInboundCapacity)
            ..maxPaymentAmount = Int64(double.maxFinite ~/ 1000)
            ..enabled = true,
          Currency.SAT,
          "USD",
          null,
          [],
          [],
          "SAT",
          initial: true,
        );

  AccountModel copyWith({
    Account accountResponse,
    Currency currency,
    String fiatShortName,
    FiatConversion fiatCurrency,
    List<FiatConversion> fiatConversionList,
    List<String> preferredCurrencies,
    String posCurrencyShortName,
    FundStatusReply addedFundsReply,
    Int64 onChainFeeRate,
    bool enableInProgress,
    double syncProgress,
    bool syncedToChain,
    bool serverReady,
    bool initial,
    SyncUIState syncUIState,
  }) {
    return AccountModel(
      accountResponse ?? this._accountResponse,
      currency ?? this.currency,
      fiatShortName ?? this._fiatShortName,
      fiatCurrency ?? this._fiatCurrency,
      fiatConversionList ?? this._fiatConversionList,
      preferredCurrencies ?? this.preferredCurrencies,
      posCurrencyShortName ?? this._posCurrencyShortName,
      addedFundsReply: addedFundsReply ?? this.addedFundsReply,
      onChainFeeRate: onChainFeeRate ?? this.onChainFeeRate,
      enableInProgress: enableInProgress ?? this.enableInProgress,
      syncProgress: syncProgress ?? this.syncProgress,
      syncedToChain: syncedToChain ?? this.syncedToChain,
      serverReady: serverReady ?? this.serverReady,
      syncUIState: syncUIState ?? this.syncUIState,
      initial: initial ?? this.initial,
    );
  }

  String get id => _accountResponse.id;

  List<String> get unconfirmedChannels => _accountResponse.unconfirmedChannels;

  SwapFundStatus get swapFundsStatus => SwapFundStatus(this.addedFundsReply);

  bool get disconnected =>
      _accountResponse.status == Account_AccountStatus.DISCONNECTED;

  bool get processingConnection =>
      _accountResponse.status == Account_AccountStatus.PROCESSING_CONNECTION;

  bool get connected =>
      _accountResponse.status == Account_AccountStatus.CONNECTED;

  Int64 get tipHeight => _accountResponse.tipHeight;

  Int64 get balance => _accountResponse.balance;

  String get formattedFiatBalance => fiatCurrency?.format(balance);

  Int64 get walletBalance => _accountResponse.walletBalance;

  String get statusLine => _accountResponse.status.toString();

  Currency get currency => _currency;

  FiatConversion get fiatCurrency => _fiatConversionList.firstWhere(
      (f) => f.currencyData.shortName == _fiatShortName,
      orElse: () => null);

  List<FiatConversion> get fiatConversionList => _fiatConversionList;

  List<FiatConversion> get preferredFiatConversionList =>
      List.from(_fiatConversionList.where((fiatConversion) =>
          preferredCurrencies.contains(fiatConversion.currencyData.shortName)));

  String get posCurrencyShortName => _posCurrencyShortName;

  Int64 get maxAllowedToReceive => _accountResponse.maxAllowedToReceive;

  Int64 get maxAllowedToPay => Int64(min(
      _accountResponse.maxAllowedToPay.toInt(),
      _accountResponse.maxPaymentAmount.toInt()));

  Int64 get reserveAmount => balance - maxAllowedToPay;

  Int64 get warningMaxChanReserveAmount => _accountResponse.maxChanReserve;

  Int64 get maxPaymentAmount => _accountResponse.maxPaymentAmount;

  bool get enabled => _accountResponse.enabled;

  Int64 get routingNodeFee => _accountResponse.routingNodeFee;

  bool get readyForPayments => _accountResponse.readyForPayments;

  Int64 get maxInboundLiquidity => _accountResponse.maxInboundLiquidity;

  bool get synced => syncedToChain;

  String get channelFundingTxUrl {
    if (_accountResponse.channelPoint.isEmpty) {
      return null;
    }
    return "https://blockstream.info/tx/${_accountResponse.channelPoint.split(":")[0]}";
  }

  String get statusMessage {
    SwapFundStatus swapStatus = this.swapFundsStatus;
    final texts = getSystemAppLocalizations();

    if (swapStatus.unconfirmedTxID != null) {
      return texts.status_message_unconfirmed_tx_id;
    }

    if (this.transferringOnChainDeposit) {
      return texts.status_transferring_on_chain_deposit;
    }

    if (swapStatus.error?.isNotEmpty == true) {
      return texts.status_failed_to_add_funds(swapStatus.error);
    }

    return null;
  }

  bool get transferringOnChainDeposit =>
      swapFundsStatus.depositConfirmed && this.connected;

  FiatConversion getFiatCurrencyByShortName(String fiatShortName) {
    return _fiatConversionList.firstWhere(
        (f) => f.currencyData.shortName == fiatShortName,
        orElse: () => null);
  }

  String validateOutgoingOnChainPayment(Int64 amount) {
    if (amount > walletBalance) {
      final texts = getSystemAppLocalizations();
      return texts.on_chain_payment_error_not_enough_funds;
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
    final texts = getSystemAppLocalizations();
    if (maxPaymentAmount != null && amount > maxPaymentAmount) {
      return texts.valid_payment_error_exceeds_the_limit(
        currency.format(maxPaymentAmount),
      );
    }

    if (!outgoing && amount > maxAllowedToReceive) {
      return texts.valid_payment_error_exceeds_the_limit(
        currency.format(maxPaymentAmount),
      );
    }

    if (outgoing && amount > maxAllowedToPay) {
      if (reserveAmount > 0) {
        return texts.valid_payment_error_keep_balance(
          currency.format(reserveAmount),
        );
      }

      return texts.valid_payment_error_insufficient_balance;
    }

    return null;
  }
}

class PaymentsModel {
  final List<PaymentInfo> nonFilteredItems;
  final List<PaymentInfo> paymentsList;
  final PaymentFilterModel filter;
  final DateTime firstDate;

  const PaymentsModel(
    this.nonFilteredItems,
    this.paymentsList,
    this.filter, [
    this.firstDate,
  ]);

  PaymentsModel.initial()
      : this(
          <PaymentInfo>[],
          <PaymentInfo>[],
          PaymentFilterModel.initial(),
          DateTime(DateTime.now().year),
        );

  PaymentsModel copyWith({
    List<PaymentInfo> nonFilteredItems,
    List<PaymentInfo> paymentsList,
    PaymentFilterModel filter,
    DateTime firstDate,
  }) {
    return PaymentsModel(
      nonFilteredItems ?? this.nonFilteredItems,
      paymentsList ?? this.paymentsList,
      filter ?? this.filter,
      firstDate ?? this.firstDate,
    );
  }
}

class PaymentFilterModel {
  final List<PaymentType> paymentType;
  final DateTime startDate;
  final DateTime endDate;
  final bool initial;

  const PaymentFilterModel(
    this.paymentType,
    this.startDate,
    this.endDate, {
    this.initial = false,
  });

  PaymentFilterModel.initial()
      : this(
          [
            PaymentType.SENT,
            PaymentType.DEPOSIT,
            PaymentType.WITHDRAWAL,
            PaymentType.RECEIVED,
            PaymentType.CLOSED_CHANNEL,
          ],
          null,
          null,
          initial: true,
        );

  PaymentFilterModel copyWith({
    List<PaymentType> filter,
    DateTime startDate,
    DateTime endDate,
  }) {
    return PaymentFilterModel(
      filter ?? this.paymentType,
      startDate ?? this.startDate,
      endDate ?? this.endDate,
    );
  }
}

enum PaymentType {
  DEPOSIT,
  WITHDRAWAL,
  SENT,
  RECEIVED,
  CLOSED_CHANNEL,
}

enum PaymentVendor {
  BITREFILL,
  BREEZ_SALE,
  FAST_BITCOINS,
  LIGHTNING_GIFTS,
  LN_PIZZA,
  ZEBEDEE,
}

abstract class PaymentInfo {
  PaymentType get type;

  Int64 get amount;

  Int64 get fee;

  Int64 get creationTimestamp;

  String get description;

  bool get pending;

  bool get keySend;

  bool get isTransferRequest;

  String get imageURL;

  bool get containsPaymentInfo;

  Currency get currency;

  String get title;

  String get dialogTitle;

  Int64 get pendingExpirationTimestamp;

  String get redeemTxID;

  String get paymentHash;

  String get preimage;

  String get destination;

  bool get fullPending;

  String get paymentGroup;

  String get paymentGroupName;

  LNUrlPayInfo get lnurlPayInfo;

  PaymentVendor get vendor;

  bool get hasSale;

  List<LNUrlPayMetadata> get metadata;

  PaymentInfo copyWith(AccountModel account);
}

class StreamedPaymentInfo implements PaymentInfo {
  final AccountModel account;
  final List<PaymentInfo> singlePayments;

  const StreamedPaymentInfo(
    this.singlePayments,
    this.account,
  );

  PaymentType get type => PaymentType.SENT;

  Int64 get amount => singlePayments.fold(Int64(0), (sum, p) => sum + p.amount);

  Int64 get fee => singlePayments.fold(Int64(0), (sum, p) => sum + p.fee);

  Int64 get creationTimestamp => singlePayments.fold(
        Int64(0),
        (t, p) => Int64(max(t.toInt(), p.creationTimestamp.toInt())),
      );

  String get description {
    final group = singlePayments
        .firstWhere((p) => !p.pending, orElse: () => singlePayments[0])
        .paymentGroup;

    var desc = group;
    try {
      final decoded = json.decode(desc);
      if (decoded["title"] != null) {
        desc = decoded["title"];
      }
    } catch (e) {}
    return desc;
  }

  bool get pending => singlePayments.fold(false, (t, p) => t || p.pending);

  PaymentInfo copyWith(AccountModel account) {
    var payments = singlePayments.map((e) => e.copyWith(account)).toList();
    return StreamedPaymentInfo(payments, account);
  }

  Currency get currency => account.currency;

  bool get isTransferRequest => false;

  bool get keySend => true;

  String get imageURL => null;

  bool get containsPaymentInfo => false;

  String get dialogTitle => paymentGroupName;

  String get title => singlePayments
      .firstWhere((p) => !p.pending, orElse: () => singlePayments[0])
      .paymentGroupName;

  Int64 get pendingExpirationTimestamp {
    var pendingExpiration = 0;
    singlePayments.forEach((p) {
      if (p.pendingExpirationTimestamp.toInt() < pendingExpiration) {
        pendingExpiration = p.pendingExpirationTimestamp.toInt();
      }
    });
    return Int64(pendingExpiration);
  }

  bool get fullPending => singlePayments.any((p) => p.fullPending);

  String get paymentGroup => singlePayments[0].paymentGroup;

  String get paymentGroupName => singlePayments[0].paymentGroupName;

  String get redeemTxID => "";

  String get paymentHash => "";

  String get preimage => "";

  String get destination => "";

  LNUrlPayInfo get lnurlPayInfo => null;

  PaymentVendor get vendor => null;

  bool get hasSale => false;

  List<LNUrlPayMetadata> get metadata => null;
}

class SinglePaymentInfo implements PaymentInfo {
  final Payment _paymentResponse;
  final AccountModel _account;
  final SaleSummary saleSummary;

  Map _typeMap = {
    Payment_PaymentType.DEPOSIT: PaymentType.DEPOSIT,
    Payment_PaymentType.WITHDRAWAL: PaymentType.WITHDRAWAL,
    Payment_PaymentType.SENT: PaymentType.SENT,
    Payment_PaymentType.RECEIVED: PaymentType.RECEIVED,
    Payment_PaymentType.CLOSED_CHANNEL: PaymentType.CLOSED_CHANNEL,
  };

  PaymentType get type => _typeMap[_paymentResponse.type];

  Int64 get amount => _paymentResponse.amount;

  Int64 get fee => _paymentResponse.fee;

  Int64 get creationTimestamp => _paymentResponse.creationTimestamp;

  String get destination => _paymentResponse.destination;

  String get redeemTxID => _paymentResponse.redeemTxID;

  String get paymentHash => _paymentResponse.paymentHash;

  String get preimage => _paymentResponse.preimage;

  String get paymentGroup => _paymentResponse.groupKey?.isNotEmpty == true
      ? _paymentResponse.groupKey
      : paymentHash;

  String get paymentGroupName => _paymentResponse.groupName;

  bool get pending =>
      _paymentResponse.pendingExpirationHeight > 0 ||
      _paymentResponse.isChannelPending;

  bool get fullPending => pending && _paymentResponse.pendingFull == true;

  String get closedChannelPoint => _paymentResponse.closedChannelPoint;

  String get closeChannelTx {
    if (_paymentResponse.closedChannelSweepTxID?.isNotEmpty == true) {
      return _paymentResponse.closedChannelSweepTxID;
    }
    if (_paymentResponse.closedChannelTxID?.isNotEmpty == true) {
      return _paymentResponse.closedChannelTxID;
    }
    return "";
  }

  String get closeChannelTxUrl {
    if (closeChannelTx.isEmpty) {
      return null;
    }
    return "https://blockstream.info/tx/$closeChannelTx";
  }

  String get remoteCloseChannelTx {
    return _paymentResponse.closedChannelRemoteTxID;
  }

  String get localCloseChannelTx {
    return _paymentResponse.closedChannelTxID;
  }

  String get remoteCloseChannelTxUrl {
    if (remoteCloseChannelTx.isEmpty) {
      return null;
    }
    return "https://blockstream.info/tx/$remoteCloseChannelTx";
  }

  bool get keySend => _paymentResponse.isKeySend;

  int get pendingExpirationHeight => _paymentResponse.pendingExpirationHeight;

  double get hoursToExpire =>
      max(_paymentResponse.pendingExpirationHeight - _account.tipHeight.toInt(),
          0) *
      10 /
      60;

  Int64 get pendingExpirationTimestamp =>
      _paymentResponse.pendingExpirationTimestamp > 0
          ? _paymentResponse.pendingExpirationTimestamp
          : Int64(
              DateTime.now()
                  .add(Duration(hours: hoursToExpire.round()))
                  .millisecondsSinceEpoch,
            );

  bool get containsPaymentInfo {
    String remoteName = (type == PaymentType.SENT
        ? _paymentResponse.invoiceMemo?.payeeName
        : _paymentResponse.invoiceMemo?.payerName);
    String description = _paymentResponse.invoiceMemo?.description;
    return remoteName?.isNotEmpty == true || description.isNotEmpty == true;
  }

  bool get isTransferRequest =>
      _paymentResponse?.invoiceMemo?.transferRequest == true;

  String get description {
    final texts = getSystemAppLocalizations();
    if (type == PaymentType.WITHDRAWAL) {
      if (pending) {
        return texts.description_waiting_broadcast;
      } else {
        return texts.description_broadcast_done;
      }
    }

    final description = _paymentResponse.invoiceMemo.description;
    if (description.startsWith("Bitrefill")) {
      return description.substring(9, description.length).trimLeft();
    }

    if (type == PaymentType.DEPOSIT) {
      return texts.description_type_deposit;
    }

    return description;
  }

  String get imageURL {
    switch (vendor) {
      case PaymentVendor.BITREFILL:
        return "src/icon/vendors/bitrefill_logo.png";
      case PaymentVendor.BREEZ_SALE:
        return "breez://avatar/possale";
      case PaymentVendor.FAST_BITCOINS:
        return "src/icon/vendors/fastbitcoins_logo.png";
      case PaymentVendor.LIGHTNING_GIFTS:
        break;
      case PaymentVendor.LN_PIZZA:
        return "src/icon/vendors/ln.pizza_logo.png";
      case PaymentVendor.ZEBEDEE:
        break;
    }

    String url = type == PaymentType.SENT
        ? _paymentResponse.invoiceMemo?.payeeImageURL
        : _paymentResponse.invoiceMemo?.payerImageURL;
    return (url == null || url.isEmpty) ? null : url;
  }

  String get title {
    final texts = getSystemAppLocalizations();

    switch (vendor) {
      case PaymentVendor.BITREFILL:
        return texts.payment_info_title_bitrefill;
      case PaymentVendor.BREEZ_SALE:
        return texts.payment_info_title_breez_sale(
          BreezDateUtils.formatHourMinute(
            DateTime.fromMillisecondsSinceEpoch(
              creationTimestamp.toInt() * 1000,
            ),
          ),
        );
      case PaymentVendor.FAST_BITCOINS:
        break;
      case PaymentVendor.LIGHTNING_GIFTS:
        return texts.payment_info_title_lightning_gifts;
      case PaymentVendor.LN_PIZZA:
        return texts.payment_info_title_ln_pizza;
      case PaymentVendor.ZEBEDEE:
        return texts.payment_info_title_zebedee;
    }

    if (type == PaymentType.DEPOSIT) {
      return texts.payment_info_title_bitcoin_transfer;
    }

    if (type == PaymentType.WITHDRAWAL &&
        _paymentResponse.invoiceMemo.description.isEmpty) {
      return texts.payment_info_title_bitcoin_transfer;
    }

    if (type == PaymentType.CLOSED_CHANNEL) {
      return texts.payment_info_title_closed_channel;
    }
    if (keySend && description.isEmpty) {
      return texts.payment_info_title_send_to_node;
    }

    String result = (type == PaymentType.SENT
        ? _paymentResponse.invoiceMemo?.payeeName
        : _paymentResponse.invoiceMemo?.payerName);

    if (result == null || result.isEmpty) {
      if (_paymentResponse.lnurlPayInfo != null &&
          _paymentResponse.lnurlPayInfo.host != '') {
        result = _paymentResponse.lnurlPayInfo.host;
      } else {
        result = _paymentResponse.invoiceMemo.description;
      }
    }
    return (result == null || result.isEmpty)
        ? texts.payment_info_title_unknown
        : result;
  }

  String get dialogTitle {
    if (this.pending && this.type == PaymentType.CLOSED_CHANNEL) {
      final texts = getSystemAppLocalizations();
      return texts.payment_info_title_pending_closed_channel;
    }
    if (this.keySend && description.isNotEmpty) {
      return description;
    }

    if (_paymentResponse.hasLnurlPayInfo()) {
      final address = _paymentResponse.lnurlPayInfo.lightningAddress;
      if (address.isNotEmpty) {
        return address;
      }
    }

    return title;
  }

  Currency get currency => _account.currency;

  LNUrlPayInfo get lnurlPayInfo => _paymentResponse.lnurlPayInfo;

  PaymentVendor get vendor {
    final memo = _paymentResponse.invoiceMemo;
    final info = _paymentResponse.lnurlPayInfo;

    if (memo.description.startsWith("Bitrefill") ||
        info?.host == 'api-bitrefill.com') {
      return PaymentVendor.BITREFILL;
    }

    if (memo.description.startsWith("LN.pizza")) {
      return PaymentVendor.LN_PIZZA;
    }

    if (memo.description.startsWith('lightning.gifts') ||
        info?.host == 'api.lightning.gifts') {
      return PaymentVendor.LIGHTNING_GIFTS;
    }

    if (info?.host == 'api.zebedee.io') {
      return PaymentVendor.ZEBEDEE;
    }

    if (memo.description.startsWith("Fastbitcoins")) {
      return PaymentVendor.FAST_BITCOINS;
    }

    if (hasSale) {
      return PaymentVendor.BREEZ_SALE;
    }

    return null;
  }

  bool get hasSale => saleSummary != null;

  SinglePaymentInfo(
    this._paymentResponse,
    this._account,
    this.saleSummary,
  );

  SinglePaymentInfo copyWith(AccountModel account) {
    return SinglePaymentInfo(this._paymentResponse, account, this.saleSummary);
  }

  List<LNUrlPayMetadata> get metadata => _paymentResponse.lnurlPayInfo.metadata;
}

class AddFundResponse {
  AddFundInitReply _addfundReply;

  AddFundResponse(this._addfundReply);

  String get errorMessage => _addfundReply.errorMessage;

  Int64 get maxAllowedDeposit => _addfundReply.maxAllowedDeposit;

  String get address => _addfundReply.address;

  String get backupJson => _addfundReply.backupJson;

  Int64 get requiredReserve => _addfundReply.requiredReserve;

  Int64 get minAllowedDeposit => _addfundReply.minAllowedDeposit;
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
  final Int64 feeRate;

  const BroadcastRefundRequestModel(
    this.fromAddress,
    this.toAddress,
    this.feeRate,
  );
}

class BroadcastRefundResponseModel {
  final BroadcastRefundRequestModel request;
  final String txID;

  const BroadcastRefundResponseModel(
    this.request,
    this.txID,
  );
}

class PayRequest {
  final String paymentRequest;
  final Int64 amount;

  const PayRequest(
    this.paymentRequest,
    this.amount,
  );
}

class CompletedPayment {
  final PayRequest paymentRequest;
  final String paymentHash;
  final bool cancelled;
  final bool ignoreGlobalFeedback;
  final PaymentInfo paymentItem;

  const CompletedPayment(
    this.paymentRequest,
    this.paymentHash,
    this.paymentItem, {
    this.cancelled = false,
    this.ignoreGlobalFeedback = false,
  });
}

class PaymentError implements Exception {
  final PayRequest request;
  final Object error;
  final String traceReport;
  final bool ignoreGlobalFeedback;

  bool get validationError =>
      error.toString().indexOf("rpc error") >= 0 ||
      traceReport == null ||
      traceReport.isEmpty;

  PaymentError(
    this.request,
    this.error,
    this.traceReport, {
    this.ignoreGlobalFeedback = false,
  });

  String errMsg() => error?.toString();

  String toString() => errMsg();

  String toDisplayMessage(Currency currency) {
    final texts = getSystemAppLocalizations();
    final str = toString();
    if (str.isNotEmpty) {
      var displayError = paymentErrorsMapping()[str];
      if (displayError != null) {
        return displayError;
      }
      var parts = str.split(":");
      if (parts.length == 2) {
        switch (parts[0]) {
          case 'insufficient balance':
            try {
              final amount = Int64.parseInt(parts[1]);
              return texts.payment_error_insufficient_balance_amount(
                currency.format(amount),
              );
            } catch (err) {}
        }
      }
    }
    return texts.payment_error_to_send(str.split("\n").first);
  }
}

class TxDetail {
  final TransactionDetails _tx;

  TxDetail(this._tx);

  List<int> get txBytes => _tx.tx;

  String get txHash => _tx.txHash;

  Int64 get fees => _tx.fees;
}

class SweepAllCoinsTxs {
  final SweepAllCoinsTransactions _sweepTxs;

  SweepAllCoinsTxs(this._sweepTxs);

  Int64 get amount => _sweepTxs.amt;

  Map<int, TxDetail> get transactions {
    return _sweepTxs.transactions
        .map((key, value) => MapEntry(key, TxDetail(value)));
  }
}
