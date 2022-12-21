import 'package:clovrlabs_wallet/theme_data.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/clovr_user_model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/user_profile_bloc.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:flutter/material.dart';

Widget withClovrLabsWalletTheme(BuildContext context, Widget child) {
  UserProfileBloc userProfileBloc =
      AppBlocsProvider.of<UserProfileBloc>(context);
  return StreamBuilder<ClovrUserModel>(
    stream: userProfileBloc.userStream,
    builder: (context, snapshot) {
      var user = snapshot.data;
      if (user == null) {
        return SizedBox();
      }
      var currentTheme = theme.themeMap[user.themeId];
      return Theme(child: child, data: currentTheme);
    },
  );
}