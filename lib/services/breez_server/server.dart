import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:breez/services/breez_server/generated/breez.pb.dart';
import 'package:breez/services/breez_server/generated/breez.pbgrpc.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:fixnum/fixnum.dart';
import 'package:breez/logger.dart';
import "package:ini/ini.dart";

//proto command:
//protoc --dart_out=grpc:lib/services/breez_server/generated/ -Ilib/services/breez_server/protobuf/ lib/services/breez_server/protobuf/breez.prot
class BreezServer {
  static final defaultCallOptions =
      new CallOptions(timeout: Duration(seconds: 10));

  ClientChannel _channel;

  Future<String> registerDevice(String id) async {
    await _ensureValidChannel();
    var invoicerClient =
        new InvoicerClient(_channel, options: defaultCallOptions);
    var response = await invoicerClient
        .registerDevice(new RegisterRequest()..deviceID = id);
    log.info('registerDevice response: $response');
    return response.breezID;
  }

  Future<String> sendInvoice(
      String breezId, String bolt11, String payee, Int64 amount) async {
    await _ensureValidChannel();
    var invoicerClient =
        new InvoicerClient(_channel, options: defaultCallOptions);
    var response = await invoicerClient.sendInvoice(new PaymentRequest()
      ..breezID = breezId
      ..invoice = bolt11
      ..payee = payee
      ..amount = amount);
    log.info('sendInvoice response: $response');
    return response.toString();
  }

  Future<FundReply_ReturnCode> requestChannel(
      String lightningId, Int64 amount) async {
    await _ensureValidChannel();
    var posClient = new PosClient(_channel, options: defaultCallOptions);
    var response = await posClient.fundChannel(new FundRequest()
      ..lightningID = lightningId
      ..amount = amount);
    log.info(
        'fundChannel response: ' + response.returnCode.value.toRadixString(10));
    return response.returnCode;
  }

  Future<String> uploadLogo(List<int> logo) async {
    await _ensureValidChannel();
    var posClient = new PosClient(_channel,
        options: CallOptions(timeout: Duration(seconds: 30)));
    return posClient
        .uploadLogo(new UploadFileRequest()..content = logo)
        .then((reply) => reply.url);
  }

  Future<OrderReply> orderCard(String fullName, String email, String address,
      String city, String state, String zip, String country) async {
    await _ensureValidChannel();
    var cardOrderClient =
        new CardOrdererClient(_channel, options: defaultCallOptions);
    var response = await cardOrderClient.order(new OrderRequest()
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
    var ctpClient = new CTPClient(_channel, options: defaultCallOptions);
    return await ctpClient.joinCTPSession(new JoinCTPSessionRequest()
      ..partyType = payer
          ? JoinCTPSessionRequest_PartyType.PAYER
          : JoinCTPSessionRequest_PartyType.PAYEE
      ..partyName = userName
      ..notificationToken = notificationToken
      ..sessionID = sessionID ?? "");
  }

  Future<TerminateCTPSessionResponse> terminateSession(String sessionID) async {
    await _ensureValidChannel();
    var ctpClient = new CTPClient(_channel, options: defaultCallOptions);
    return await ctpClient.terminateCTPSession(
        TerminateCTPSessionRequest()..sessionID = sessionID);
  }

  Future _ensureValidChannel() async {
    if (_channel == null) {
      _channel = await _createChannel();
      return;
    }

    var infoClient = new InformationClient(_channel,
        options: CallOptions(timeout: Duration(seconds: 2)));
    try {
      await infoClient.ping(new PingRequest());
    } catch (e) {
      _channel.terminate();
      _createChannel();
    }
  }

  Future<ClientChannel> _createChannel() async {
    var cert = await rootBundle.load('cert/letsencrypt.cert');
    String configString = await rootBundle.loadString('conf/breez.conf');
    Config config = Config.fromString(configString);
    var hostdetails =
        config.get("Application Options", "breezserver").split(':');
    if (hostdetails.length < 2) {
      hostdetails.add("443");
    }
    return new ClientChannel(hostdetails[0],
        port: int.parse(hostdetails[1]),
        options: ChannelOptions(
            credentials: ChannelCredentials.secure(
                certificates: cert.buffer.asUint8List())));
  }
}
