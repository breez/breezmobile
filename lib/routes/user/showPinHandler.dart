import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:flutter/material.dart';

class ShowPinHandler {
  ShowPinHandler(UserProfileBloc userProfileBloc, BuildContext context) {
    // wait for first time app is unlocked.
    userProfileBloc.userStream.firstWhere((u) => u.locked == false).then((_) {
      // listen to user stream and push pin whenever app is locked.
      userProfileBloc.userStream
          .map((u) => u.locked)
          .distinct()
          .where((locked) => locked == true)
          .listen((_) {
        Navigator.of(context).pushNamed("/lockscreen");
      });
    });
  }
}
