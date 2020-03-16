import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/admin_login_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';

class CTPJoinSessionHandler {
  CTPJoinSessionHandler(
      UserProfileBloc userProfileBloc,
      ConnectPayBloc ctpBloc,
      BuildContext context,
      Function(RemoteSession session) onValidSession,
      Function(Object error) onError) {
    ctpBloc.sessionInvites.listen((sessionLink) async {
      if (ctpBloc.currentSession?.sessionID != sessionLink.sessionID) {
        var loaderRoute = createLoaderRoute(context);
        try {
          Navigator.of(context).push(loaderRoute);
          var user =
              await userProfileBloc.userStream.firstWhere((u) => u != null);
          await protectAdminAction(context, user, () async {
            var currentSession = await ctpBloc.joinSessionByLink(sessionLink);
            Navigator.of(context).removeRoute(loaderRoute);
            onValidSession(currentSession);
          });
        } catch (e) {
          onError(e);
        } finally {
          if (loaderRoute.isActive) {
            Navigator.of(context).removeRoute(loaderRoute);
          }
        }
      }
    });
  }
}
