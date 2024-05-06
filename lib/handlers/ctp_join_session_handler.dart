import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/admin_login_dialog.dart';
import 'package:breez/widgets/loader.dart';
import 'package:flutter/material.dart';

class CTPJoinSessionHandler {
  CTPJoinSessionHandler(UserProfileBloc userProfileBloc, ConnectPayBloc ctpBloc, BuildContext context,
      Function(RemoteSession session) onValidSession, Function(Object error) onError) {
    ctpBloc.sessionInvites.listen(
      (sessionLink) async {
        if (ctpBloc.currentSession?.sessionID != sessionLink.sessionID) {
          final navigator = Navigator.of(context);
          var loaderRoute = createLoaderRoute(context);
          try {
            navigator.push(loaderRoute);
            await userProfileBloc.userStream.firstWhere((u) => u != null).then(
                  (user) => protectAdminAction(
                    context,
                    user,
                    () async {
                      var currentSession = await ctpBloc.joinSessionByLink(
                        sessionLink,
                      );
                      navigator.removeRoute(loaderRoute);
                      onValidSession(currentSession);
                    },
                  ),
                );
          } catch (e) {
            onError(e);
          } finally {
            if (loaderRoute.isActive) {
              navigator.removeRoute(loaderRoute);
            }
          }
        }
      },
    );
  }
}
