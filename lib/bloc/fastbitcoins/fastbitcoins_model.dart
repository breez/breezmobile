import 'package:json_annotation/json_annotation.dart';
part 'fastbitcoins_model.g.dart';

@JsonSerializable()
class ValidateRequestModel {
  @JsonKey(name: 'email_address')
  final String emailAddress;
  final String code;
  final double value;
  final String currency;

  ValidateRequestModel(this.emailAddress, this.code, this.value, this.currency);

  factory ValidateRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ValidateRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$ValidateRequestModelToJson(this);
}

@JsonSerializable()
class ValidateResponseModel {
  final int error;
  @JsonKey(name: 'error_message')
  final String errorMessage;
  @JsonKey(name: 'kyc_required')
  final int kycRequired;
  @JsonKey(name: 'quotation_id')
  final int quotationId;
  @JsonKey(name: 'quotation_secret')
  final String quotationSecret;
  @JsonKey(name: 'quotation_expiry')
  final int quotationExpiry;
  final double value;
  @JsonKey(name: 'exchange_rate')
  final double exchangeRate;
  @JsonKey(name: 'commission_total')
  final double commissionTotal;
  @JsonKey(name: 'bitcoin_amount')
  final double bitcoinAmount;
  @JsonKey(name: 'satoshi_amount')
  final int satoshiAmount;

  ValidateResponseModel(
      this.error,
      this.errorMessage,
      this.kycRequired,
      this.quotationId,
      this.quotationSecret,
      this.quotationExpiry,
      this.value,
      this.exchangeRate,
      this.commissionTotal,
      this.bitcoinAmount,
      this.satoshiAmount);
  factory ValidateResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ValidateResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ValidateResponseModelToJson(this);
}

@JsonSerializable()
class RedeemRequestModel {
  @JsonKey(ignore: true)
  ValidateResponseModel validateResponse;
  @JsonKey(name: 'email_address')
  final String emailAddress;
  final String code;
  final double value;
  final String currency;
  @JsonKey(name: 'quotation_id')
  final int quotationId;
  @JsonKey(name: 'quotation_secret')
  final String quotationSecret;

  @JsonKey(name: 'lightning_invoice')
  String lightningInvoice;

  RedeemRequestModel(this.emailAddress, this.code, this.value, this.currency,
      this.quotationId, this.quotationSecret);

  factory RedeemRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RedeemRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$RedeemRequestModelToJson(this);
}

@JsonSerializable()
class RedeemResponseModel {
  final int error;

  @JsonKey(name: 'error_message')
  final String errorMessage;

  RedeemResponseModel(this.error, this.errorMessage);

  factory RedeemResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RedeemResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$RedeemResponseModelToJson(this);
}
