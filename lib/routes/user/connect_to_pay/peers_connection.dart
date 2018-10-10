import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/routes/user/connect_to_pay/connected_peer.dart';
import 'package:breez/routes/user/connect_to_pay/connection_status.dart';
import 'package:breez/widgets/delay_render.dart';
import 'package:breez/widgets/layouts.dart';
import 'package:flutter/material.dart';
import 'connection_status.dart' as sessionConnection;

class PeersConnection extends StatelessWidget {
  final PaymentSessionState _sessionState;
  final Function() _onShareInvite;

  PeersConnection(this._sessionState, {Function() onShareInvite}) : _onShareInvite = onShareInvite;

  bool _isPayerWaiting(){
    return _sessionState.payer && _sessionState.payerData.amount != null && _sessionState.payeeData.paymentRequest == null;
  }

  bool _isPayeeWaiting(){
    return !_sessionState.payer && (_sessionState.payerData.amount == null || _sessionState.payeeData.paymentRequest != null && !_sessionState.paymentFulfilled);
  }

  @override
  Widget build(BuildContext context) {
    sessionConnection.ConnectionState connectionState = sessionConnection.ConnectionState.IDLE;
    if (!_sessionState.payeeData.status.online && !_sessionState.payerData.status.online) {
      connectionState = sessionConnection.ConnectionState.IDLE;
    } else if (!_sessionState.payeeData.status.online || !_sessionState.payerData.status.online){
      connectionState = sessionConnection.ConnectionState.WAITING_PEER_CONNECT;
    }
    else if (_isPayerWaiting() || _isPayeeWaiting()) {
      connectionState = sessionConnection.ConnectionState.WAITING_ACTION;    
    } else if (_sessionState.payerData.status.online && _sessionState.payeeData.status.online) {
      connectionState = sessionConnection.ConnectionState.CONNECTED;
    } else if (_sessionState.invitationSent) {
      connectionState = sessionConnection.ConnectionState.WAITING_PEER_CONNECT;
    }    
    double peerContainerSize = 110.0;
    double nameContainerSize = 20.0;
    double peerAvatarWidth = 60.0;
    double connectionLineMargin = (peerContainerSize - peerAvatarWidth) / 2 + peerAvatarWidth;
    double nameMargin = (peerContainerSize - peerAvatarWidth) / 2 + peerAvatarWidth + 8.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      ConstrainedBox(
          constraints: BoxConstraints.expand(height: peerContainerSize + nameContainerSize),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[              
              Positioned(left: connectionLineMargin, right: connectionLineMargin, top: peerContainerSize / 2, child: ConnectionStatus(connectionState, PaymentSessionState.connectionEmulationDuration)),
              Positioned(
                  right: 0.0,
                  top: 0.0,
                  child: AlignMiddle(
                    height: peerContainerSize,
                    width: peerContainerSize,
                    child: ConnectedPeer(false, _sessionState, this._onShareInvite),
                  )),
              Positioned(
                  left: 0.0,
                  top: 0.0,
                  child: AlignMiddle(
                    height: peerContainerSize,
                    width: peerContainerSize,
                    child: ConnectedPeer(true, _sessionState, this._onShareInvite),
                  )),
              Positioned(
                top: nameMargin,
                child: AlignMiddle(width: peerContainerSize, child: _UserNameWidget(_sessionState.payerData.userName ?? "Unknown")),
              ),
              Positioned(
                top: nameMargin,
                right: 0.0,
                child: AlignMiddle(
                    width: peerContainerSize, child: buildPayeeWidget()),
              )
            ],
          ))
    ]);
  }

  Widget buildPayeeWidget(){
    if (_sessionState.payeeData.userName != null) {
      if (!_sessionState.payer) {
        return _UserNameWidget(_sessionState.payeeData.userName);
      }

      return DelayRender(
        duration: PaymentSessionState.connectionEmulationDuration,
        initialChild: _UserNameWidget("Unknown"),
        child: _UserNameWidget(_sessionState.payeeData.userName),
      );
    }

    if (!_sessionState.invitationSent) {
      return SizedBox();
    }
    return _UserNameWidget("Unknown");  
  }
}

class _UserNameWidget extends StatelessWidget {
  final String userName;

  _UserNameWidget(this.userName);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[Container(width: 60.0), Text(userName)],
    );
  }
}
