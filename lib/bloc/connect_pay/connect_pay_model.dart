/*
This model represents the state of the payment session for both sides.
*/
class PaymentSessionState {
  static const Duration connectionEmulationDuration = Duration(milliseconds:  1500);
  final bool payer;
  final String sessionSecret;
  final PayerSessionData payerData;
  final PayeeSessionData payeeData;
  final bool invitationReady;
  final bool invitationSent;
  final bool paymentFulfilled;
  final int settledAmount;   

  PaymentSessionState(this.payer, this.sessionSecret, this.payerData, this.payeeData, this.invitationReady, this.invitationSent, this.paymentFulfilled, this.settledAmount);

  PaymentSessionState copyWith({PayerSessionData payerData, PayeeSessionData payeeData, bool invitationReady, bool invitationSent, bool paymentFulfilled, int settledAmount}) {
    return new PaymentSessionState(this.payer, this.sessionSecret, payerData ?? this.payerData, payeeData ?? this.payeeData, invitationReady ?? this.invitationReady,
        invitationSent ?? this.invitationSent, paymentFulfilled ?? this.paymentFulfilled, settledAmount ?? this.settledAmount);
  }

  PaymentSessionState.payerStart(String sessionSecret, String userName, String imageURL)
      : this(true, sessionSecret, PayerSessionData(userName, imageURL, PeerStatus.start(), null), PayeeSessionData(null, null, PeerStatus.start(), null, null),false,  false,
            false, 0);
  PaymentSessionState.payeeStart(String sessionSecret, String userName, String imageURL)
      : this(false, sessionSecret, PayerSessionData(null, null, PeerStatus.start(), null), PayeeSessionData(userName, imageURL, PeerStatus.start(), null, null), true, true,
            false, 0);
}

class PayerSessionData {
  final String userName;
  final String imageURL;
  final PeerStatus status;
  final int amount;
  final String error;
  final bool paymentFulfilled;

  PayerSessionData(this.userName, this.imageURL, this.status, this.amount, {this.error, this.paymentFulfilled = false});
  PayerSessionData.fromJson(Map<dynamic, dynamic> json)
      : status = PeerStatus.fromJson(json['status'] ?? {}),
        amount = json['amount'],
        userName = json["userName"],
        imageURL = json["imageURL"],
        error = json["error"],
        paymentFulfilled = json["paymentFulfilled"] ?? false;

  PayerSessionData copyWith({String userName, String imageURL, PeerStatus status, int amount, String error, bool paymentFulfilled}) {
    return new PayerSessionData(userName ?? this.userName, imageURL ?? this.imageURL, status ?? this.status, 
        amount ?? this.amount, error: error ?? this.error, paymentFulfilled: paymentFulfilled ?? this.paymentFulfilled);
  }
}

class PayeeSessionData {
  final String userName;
  final String imageURL;
  final PeerStatus status;
  final String paymentRequest;
  final String error;
  bool get invitationAccepted => status.lastChanged != 0;

  PayeeSessionData(this.userName, this.imageURL, this.status, this.paymentRequest, this.error);

  PayeeSessionData.fromJson(Map<dynamic, dynamic> json)
      : status = PeerStatus.fromJson(json['status'] ?? {}),
        paymentRequest = json['paymentRequest'],
        userName = json["userName"],
        error = json["error"],
        imageURL = json['imageURL'];

  PayeeSessionData copyWith({String userName, String imageURL, PeerStatus status, String paymentRequest, String error}) {
    return new PayeeSessionData(userName ?? this.userName, imageURL ?? this.imageURL, status ?? this.status, paymentRequest ?? this.paymentRequest, error ?? this.error);
  }
}

class PeerStatus {
  final bool online;
  final int lastChanged;

  PeerStatus(this.online, this.lastChanged);
  PeerStatus.start()
      : online = false,
        lastChanged = 0;

  PeerStatus.fromJson(Map<dynamic, dynamic> json)
      : online = json['online'] ?? false,
        lastChanged = json['lastChanged'] ?? 0;
}


enum PaymentSessionErrorType {
  PAYER_CANCELLED,
  UNKNOWN
}

class PaymentSessionError {
  final PaymentSessionErrorType type;
  final String description;
  
  PaymentSessionError.unknown(this.description) : type = PaymentSessionErrorType.UNKNOWN;
  PaymentSessionError(this.type, this.description);
}