import 'package:anytime/ui/widgets/layout_selector.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/routes/account_required_actions.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  const HomeAppBar(
    this._scaffoldKey, {
    Key key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);
    final themeData = Theme.of(context);
    final appBar = themeData.appBarTheme;

    return StreamBuilder<BreezUserModel>(
      stream: userProfileBloc.userStream,
      builder: (context, userSnapshot) {
        final appMode = userSnapshot.data?.appMode;

        return AppBar(
          systemOverlayStyle: theme.themeId == "BLUE" ? SystemUiOverlayStyle.dark : appBar.systemOverlayStyle,
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 0, 133, 251),
          ),
          backgroundColor: appMode == AppMode.pos
              ? themeData.colorScheme.background
              : theme.customData[theme.themeId].dashboardBgColor,
          leading: IconButton(
            icon: Image.asset(
              _getAppModesAssetName(appMode),
              height: 24.0,
              width: 24.0,
              color: appBar.actionsIconTheme.color,
            ),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          centerTitle: false,
          title: IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              "src/images/logo-color.svg",
              height: 23.5,
              width: 62.7,
              colorFilter: ColorFilter.mode(
                appBar.actionsIconTheme.color,
                BlendMode.srcATop,
              ),
            ),
            iconSize: 64,
            onPressed: () async {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          actions: [
            Padding(
              padding: appMode == AppMode.podcasts
                  ? const EdgeInsets.all(14)
                  : const EdgeInsets.fromLTRB(14, 14, 0, 14),
              child: const AccountRequiredActionsIndicator(),
            ),
            if (appMode == AppMode.podcasts)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  iconSize: 24.0,
                  padding: EdgeInsets.zero,
                  icon: ImageIcon(
                    const AssetImage("assets/icons/layout.png"),
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                  // TODO extract layout to breez translations
                  tooltip: 'Layout',
                  onPressed: () async {
                    await showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                      ),
                      builder: (context) => LayoutSelectorWidget(),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  String _getAppModesAssetName(AppMode appMode) {
    switch (appMode) {
      case (AppMode.podcasts):
        return "src/icon/podcast.png";
      case (AppMode.pos):
        return "src/icon/pos.png";
      case (AppMode.apps):
        return "src/icon/apps.png";
      case (AppMode.balance):
        return "src/icon/balance.png";
      default:
        return "src/icon/hamburger.png";
    }
  }
}
