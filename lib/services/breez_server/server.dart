import 'dart:async';

import 'package:breez/logger.dart';
import 'package:breez/services/breez_server/generated/breez.pb.dart';
import 'package:breez/services/breez_server/generated/breez.pbgrpc.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import "package:ini/ini.dart";

//proto command:
//protoc --dart_out=grpc:lib/services/breez_server/generated/ -Ilib/services/breez_server/protobuf/ lib/services/breez_server/protobuf/breez.proto
class BreezServer {
  static final defaultCallOptions = CallOptions(timeout: Duration(seconds: 10));

  ClientChannel _channel;

  Future<String> signUrl(String baseUrl, String queryString) async {
    var signerClient = SignerClient(_channel);
    var response = await signerClient.signUrl(SignUrlRequest()
      ..baseUrl = baseUrl
      ..queryString = queryString);
    log.info('signUrl response: $response');
    return response.fullUrl;
  }

  Future<String> registerDevice(String id, String nodeid) async {
    await _ensureValidChannel();
    var invoicerClient = InvoicerClient(_channel, options: defaultCallOptions);
    var response = await invoicerClient.registerDevice(RegisterRequest()
      ..deviceID = id
      ..lightningID = nodeid);
    log.info('registerDevice response: $response');
    return response.breezID;
  }

  Future<String> sendInvoice(
      String breezId, String bolt11, String payee, Int64 amount) async {
    await _ensureValidChannel();
    var invoicerClient = InvoicerClient(_channel, options: defaultCallOptions);
    var response = await invoicerClient.sendInvoice(PaymentRequest()
      ..breezID = breezId
      ..invoice = bolt11
      ..payee = payee
      ..amount = amount);
    log.info('sendInvoice response: $response');
    return response.toString();
  }

  Future<String> uploadLogo(List<int> logo) async {
    await _ensureValidChannel();
    var posClient = PosClient(_channel,
        options: CallOptions(timeout: Duration(seconds: 30)));
    return posClient
        .uploadLogo(UploadFileRequest()..content = logo)
        .then((reply) => reply.url);
  }

  Future<OrderReply> orderCard(String fullName, String email, String address,
      String city, String state, String zip, String country) async {
    await _ensureValidChannel();
    var cardOrderClient =
        CardOrdererClient(_channel, options: defaultCallOptions);
    var response = await cardOrderClient.order(OrderRequest()
      ..fullName = fullName
      ..email = email
      ..address = address
      ..city = city
      ..state = state
      ..zip = zip
      ..country = country);

    return response;
  }

  Future<JoinCTPSessionResponse> joinSession(
      bool payer, String userName, String notificationToken,
      {String sessionID}) async {
    await _ensureValidChannel();
    var ctpClient = CTPClient(_channel, options: defaultCallOptions);
    return await ctpClient.joinCTPSession(JoinCTPSessionRequest()
      ..partyType = payer
          ? JoinCTPSessionRequest_PartyType.PAYER
          : JoinCTPSessionRequest_PartyType.PAYEE
      ..partyName = userName
      ..notificationToken = notificationToken
      ..sessionID = sessionID ?? "");
  }

  Future<TerminateCTPSessionResponse> terminateSession(String sessionID) async {
    await _ensureValidChannel();
    var ctpClient = CTPClient(_channel, options: defaultCallOptions);
    return await ctpClient.terminateCTPSession(
        TerminateCTPSessionRequest()..sessionID = sessionID);
  }

  Future _ensureValidChannel() async {
    if (_channel == null) {
      _channel = await _createChannel();
      return;
    }

    var infoClient = InformationClient(_channel,
        options: CallOptions(timeout: Duration(seconds: 2)));
    try {
      await infoClient.ping(PingRequest());
    } catch (e) {
      _channel.shutdown();
      _channel = await _createChannel();
    }
  }

  Future<ClientChannel> _createChannel() async {
    String configString = await rootBundle.loadString('conf/breez.conf');
    Config config = Config.fromString(configString);
    var hostdetails =
        config.get("Application Options", "breezserver").split(':');
    if (hostdetails.length < 2) {
      hostdetails.add("443");
    }
    return ClientChannel(hostdetails[0],
        port: int.parse(hostdetails[1]),
        options: ChannelOptions(credentials: ChannelCredentials.secure()));
  }
}
