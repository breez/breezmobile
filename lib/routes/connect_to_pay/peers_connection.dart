import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/connect_pay/connect_pay_model.dart';
import 'package:breez/widgets/layouts.dart';
import 'package:flutter/material.dart';
import 'package:breez_translations/breez_translations_locales.dart';

import 'connected_peer.dart';
import 'connection_status.dart';
import 'connection_status.dart' as sessionConnection;

class PeersConnection extends StatelessWidget {
  final PaymentSessionState _sessionState;
  final Function() _onShareInvite;

  const PeersConnection(
    this._sessionState, {
    Function() onShareInvite,
  }) : _onShareInvite = onShareInvite;

  bool _isPayerWaiting() {
    final payerData = _sessionState.payerData;
    final payeeData = _sessionState.payeeData;
    return _sessionState.payer &&
        payerData.amount != null &&
        payeeData.paymentRequest == null;
  }

  bool _isPayeeWaiting() {
    final payerData = _sessionState.payerData;
    final payeeData = _sessionState.payeeData;
    return !_sessionState.payer &&
        (payerData.amount == null ||
            payeeData.paymentRequest != null &&
                !_sessionState.paymentFulfilled);
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final payerData = _sessionState.payerData;
    final payeeData = _sessionState.payeeData;

    var connectionState = sessionConnection.ConnectionState.IDLE;

    if (!payeeData.status.online && !payerData.status.online) {
      connectionState = sessionConnection.ConnectionState.IDLE;
    } else if (!payeeData.status.online || !payerData.status.online) {
      connectionState = sessionConnection.ConnectionState.WAITING_PEER_CONNECT;
    } else if (_isPayerWaiting() || _isPayeeWaiting()) {
      connectionState = sessionConnection.ConnectionState.WAITING_ACTION;
    } else if (payerData.status.online && payeeData.status.online) {
      connectionState = sessionConnection.ConnectionState.CONNECTED;
    } else if (_sessionState.invitationSent) {
      connectionState = sessionConnection.ConnectionState.WAITING_PEER_CONNECT;
    }

    double peerContainerSize = 110.0;
    double nameContainerSize = 20.0;
    double peerAvatarWidth = 60.0;
    double connectionLineMargin =
        (peerContainerSize - peerAvatarWidth) / 2 + peerAvatarWidth;
    double nameMargin =
        (peerContainerSize - peerAvatarWidth) / 2 + peerAvatarWidth + 8.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.expand(
            height: peerContainerSize + nameContainerSize,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: connectionLineMargin,
                right: connectionLineMargin,
                top: peerContainerSize / 2,
                child: ConnectionStatus(
                  connectionState,
                  PaymentSessionState.connectionEmulationDuration,
                ),
              ),
              Positioned(
                right: 0.0,
                top: 0.0,
                child: AlignMiddle(
                  height: peerContainerSize,
                  width: peerContainerSize,
                  child: ConnectedPeer(
                    false,
                    _sessionState,
                    _onShareInvite,
                  ),
                ),
              ),
              Positioned(
                left: 0.0,
                top: 0.0,
                child: AlignMiddle(
                  height: peerContainerSize,
                  width: peerContainerSize,
                  child: ConnectedPeer(
                    true,
                    _sessionState,
                    _onShareInvite,
                  ),
                ),
              ),
              Positioned(
                top: nameMargin,
                child: AlignMiddle(
                  width: peerContainerSize,
                  child: _UserNameWidget(
                    payerData.userName ?? texts.connect_to_pay_peer_unknown,
                  ),
                ),
              ),
              Positioned(
                top: nameMargin,
                right: 0.0,
                child: AlignMiddle(
                  width: peerContainerSize,
                  child: buildPayeeWidget(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPayeeWidget(BuildContext context) {
    final texts = context.texts();
    final userName = _sessionState.payeeData.userName;

    if (userName != null) {
      return _UserNameWidget(userName);
    }

    if (!_sessionState.invitationSent) {
      return const SizedBox();
    }
    return _UserNameWidget(texts.connect_to_pay_peer_unknown);
  }
}

class _UserNameWidget extends StatelessWidget {
  final String userName;

  const _UserNameWidget(
    this.userName,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(width: 60.0),
        AutoSizeText(
          userName,
          maxLines: 1,
        )
      ],
    );
  }
}
