// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fastbitcoins_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidateRequestModel _$ValidateRequestModelFromJson(Map<String, dynamic> json) {
  return ValidateRequestModel(
      json['email_address'] as String,
      json['code'] as String,
      (json['value'] as num)?.toDouble(),
      json['currency'] as String);
}

Map<String, dynamic> _$ValidateRequestModelToJson(
        ValidateRequestModel instance) =>
    <String, dynamic>{
      'email_address': instance.emailAddress,
      'code': instance.code,
      'value': instance.value,
      'currency': instance.currency
    };

ValidateResponseModel _$ValidateResponseModelFromJson(
    Map<String, dynamic> json) {
  return ValidateResponseModel(
      json['error'] as int,
      json['error_message'] as String,
      json['kyc_required'] as int,
      json['quotation_id'] as int,
      json['quotation_secret'] as String,
      json['quotation_expiry'] as int,
      (json['value'] as num)?.toDouble(),
      (json['exchange_rate'] as num)?.toDouble(),
      (json['commission_total'] as num)?.toDouble(),
      (json['bitcoin_amount'] as num)?.toDouble(),
      json['satoshi_amount'] as int);
}

Map<String, dynamic> _$ValidateResponseModelToJson(
        ValidateResponseModel instance) =>
    <String, dynamic>{
      'error': instance.error,
      'error_message': instance.errorMessage,
      'kyc_required': instance.kycRequired,
      'quotation_id': instance.quotationId,
      'quotation_secret': instance.quotationSecret,
      'quotation_expiry': instance.quotationExpiry,
      'value': instance.value,
      'exchange_rate': instance.exchangeRate,
      'commission_total': instance.commissionTotal,
      'bitcoin_amount': instance.bitcoinAmount,
      'satoshi_amount': instance.satoshiAmount
    };

RedeemRequestModel _$RedeemRequestModelFromJson(Map<String, dynamic> json) {
  return RedeemRequestModel(
      json['email_address'] as String,
      json['code'] as String,
      (json['value'] as num)?.toDouble(),
      json['currency'] as String,
      json['quotation_id'] as int,
      json['quotation_secret'] as String)
    ..lightningInvoice = json['lightning_invoice'] as String;
}

Map<String, dynamic> _$RedeemRequestModelToJson(RedeemRequestModel instance) =>
    <String, dynamic>{
      'email_address': instance.emailAddress,
      'code': instance.code,
      'value': instance.value,
      'currency': instance.currency,
      'quotation_id': instance.quotationId,
      'quotation_secret': instance.quotationSecret,
      'lightning_invoice': instance.lightningInvoice
    };

RedeemResponseModel _$RedeemResponseModelFromJson(Map<String, dynamic> json) {
  return RedeemResponseModel(
      json['error'] as int, json['error_message'] as String);
}

Map<String, dynamic> _$RedeemResponseModelToJson(
        RedeemResponseModel instance) =>
    <String, dynamic>{
      'error': instance.error,
      'error_message': instance.errorMessage
    };
