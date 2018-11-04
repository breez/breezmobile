import 'dart:async';
import 'package:grpc/grpc.dart';
import 'package:breez/services/breez_server/generated/breez.pb.dart';
import 'package:breez/services/breez_server/generated/breez.pbgrpc.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:fixnum/fixnum.dart';
import 'package:breez/logger.dart';
import "package:ini/ini.dart";


class BreezServer {
  ClientChannel _channel;
  InvoicerClient _invoicerClient;
  PosClient _posClient;
  CardOrdererClient _cardOrdererClient;

  initChannel() async {
    if (_channel == null) {
      var cert = await rootBundle.load('cert/letsencrypt.cert');
      String configString = await rootBundle.loadString('conf/breez.conf');
      Config config = await new Config.fromString(configString);
      var hostdetails = config.get("Application Options", "breezserver").split(':');
      if (hostdetails.length < 2) {
        hostdetails.add("443");
      }
      _channel = new ClientChannel(hostdetails[0],
          port: int.parse(hostdetails[1]),
          options: ChannelOptions(                 
              credentials: ChannelCredentials.secure(
                  certificates: cert.buffer.asUint8List())));

      var callOptions = new CallOptions(timeout: Duration(seconds: 30));
      _invoicerClient = new InvoicerClient(_channel, options: callOptions);
      _posClient = new PosClient(_channel, options: callOptions);
      _cardOrdererClient = new CardOrdererClient(_channel, options: callOptions);
    }
  }

  Future<String> registerDevice(String id) async {
    if (_channel == null) await initChannel();
    var response = await _invoicerClient
        .registerDevice(new RegisterRequest()..deviceID = id);
    log.info('registerDevice response: $response');
    return response.breezID;
  }

  Future<String> sendInvoice(String breezId, String bolt11, String payee, Int64 amount) async {
    if (_channel == null) await initChannel();
    var response = await _invoicerClient.sendInvoice(new PaymentRequest()
      ..breezID = breezId
      ..invoice = bolt11
      ..payee = payee
      ..amount = amount);
    log.info('sendInvoice response: $response');
    return response.toString();
  }

  Future<FundReply_ReturnCode> requestChannel(
      String lightningId, Int64 amount) async {
    if (_channel == null) await initChannel();
    var response = await _posClient.fundChannel(new FundRequest()
      ..lightningID = lightningId
      ..amount = amount);
    log.info('fundChannel response: ' + response.returnCode.value.toRadixString(10));
    return response.returnCode;
  }

  Future<String> uploadLogo(List<int> logo) async{      
    await initChannel();
    return _posClient.uploadLogo(new UploadFileRequest()..content = logo)
      .then((reply) => reply.url);
  }

  Future<OrderReply> orderCard(String fullName, String email, String address, String city, String state, String zip, String country) async {
    if (_channel == null) await initChannel();
    var response = await _cardOrdererClient.order(new OrderRequest()
        ..fullName = fullName
        ..email = email
        ..address = address
        ..city = city
        ..state = state
        ..zip = zip
        ..country = country);

    return response;
  }
}
