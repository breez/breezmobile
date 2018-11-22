
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:flutter/material.dart';

class CTPJoinSessionHandler {
  CTPJoinSessionHandler(ConnectPayBloc ctpBloc, BuildContext context, Function(RemoteSession session) onValidSession, Function(Object error) onError){
    ctpBloc.sessionInvites.listen((sessionLink) async {
      if (ctpBloc.currentSession?.sessionID != sessionLink.sessionID) {
        await ctpBloc.terminateCurrentSession();   
        try {
          var currentSession = await ctpBloc.joinSessionByLink(sessionLink);
          onValidSession(currentSession);          
        } catch (e) {
          onError(e);
        }        
      }
    });
  }
}