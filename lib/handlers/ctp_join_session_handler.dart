import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';

class CTPJoinSessionHandler {
  CTPJoinSessionHandler(
      ConnectPayBloc ctpBloc,
      BuildContext context,
      Function(RemoteSession session) onValidSession,
      Function(Object error) onError) {
    ctpBloc.sessionInvites.listen((sessionLink) async {
      if (ctpBloc.currentSession?.sessionID != sessionLink.sessionID) {
        try {
          Navigator.of(context).push(createLoaderRoute(context));
          var currentSession = await ctpBloc.joinSessionByLink(sessionLink);
          Navigator.of(context).pop();
          onValidSession(currentSession);
        } catch (e) {
          Navigator.of(context).pop();
          onError(e);
        }
      }
    });
  }
}
