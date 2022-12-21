import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clovrlabs_wallet/bloc/blocs_provider.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/clovr_user_model.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/user_actions.dart';
import 'package:clovrlabs_wallet/bloc/user_profile/user_profile_bloc.dart';
import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:clovrlabs_wallet/widgets/wallet_avatar.dart';
import 'package:clovrlabs_wallet/widgets/breez_drawer_header.dart';
import 'package:clovrlabs_wallet/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawerItemConfig {
  final GlobalKey key;
  final String name;
  final String title;
  final String icon;
  final bool disabled;
  final void Function(String name) onItemSelected;
  final Widget switchWidget;
  final bool isSelected;

  const DrawerItemConfig(
    this.name,
    this.title,
    this.icon, {
    this.key,
    this.onItemSelected,
    this.disabled = false,
    this.switchWidget,
    this.isSelected = false,
  });
}

class DrawerItemConfigGroup {
  final List<DrawerItemConfig> items;
  final String groupTitle;
  final String groupAssetImage;
  final bool withDivider;

  const DrawerItemConfigGroup(
    this.items, {
    this.groupTitle,
    this.groupAssetImage,
    this.withDivider = true,
  });
}

class NavigationDrawer extends StatelessWidget {
  final bool _avatar;
  final List<DrawerItemConfigGroup> _drawerGroupedItems;
  final void Function(String screenName) _onItemSelected;
  final _scrollController = ScrollController();

  NavigationDrawer(
    this._avatar,
    this._drawerGroupedItems,
    this._onItemSelected,
  );

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    List<Widget> children = [
      _walletDrawerHeader(userProfileBloc, _avatar),
      Padding(padding: EdgeInsets.only(top: 16)),
    ];
    _drawerGroupedItems.forEach((groupItems) {
      children.addAll(_createDrawerGroupWidgets(
        groupItems,
        context,
        _drawerGroupedItems.indexOf(groupItems),
        withDivider: children.length > 0 && groupItems.withDivider,
      ));
    });

    return Theme(
      data: themeData.copyWith(
        canvasColor: theme.customData[theme.themeId].navigationDrawerBgColor,
      ),
      child: Drawer(
        child: ListView(
          controller: _scrollController,
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.only(bottom: 20.0),
          children: children,
        ),
      ),
    );
  }

  List<Widget> _createDrawerGroupWidgets(
    DrawerItemConfigGroup group,
    BuildContext context,
    int index, {
    bool withDivider = false,
  }) {
    List<Widget> groupItems = group.items
        .map((action) => _actionTile(
              action,
              context,
              action.onItemSelected ?? _onItemSelected,
            ))
        .toList();
    if (group.groupTitle != null && groupItems.length > 0) {
      groupItems = group.items
          .map((action) => _actionTile(
                action,
                context,
                action.onItemSelected ?? _onItemSelected,
                subTile: true,
              ))
          .toList();
      groupItems = []..add(_ExpansionTile(
          items: groupItems,
          title: group.groupTitle,
          icon: AssetImage(group.groupAssetImage),
          controller: _scrollController,
        ));
    }

    if (groupItems.length > 0 && withDivider && index != 0) {
      groupItems.insert(0, _ListDivider());
    }
    return groupItems;
  }
}

class _ListDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Divider(),
    );
  }
}

Widget _walletDrawerHeader(UserProfileBloc user, bool drawAvatar) {
  return Container(
    color: theme.customData[theme.themeId].navigationDrawerHeaderBgColor,
    child: WalletDrawerHeader(
      child: _buildDrawerHeaderContent(user, drawAvatar),
    ),
  );
}

StreamBuilder<ClovrUserModel> _buildDrawerHeaderContent(
  UserProfileBloc user,
  bool drawAvatar,
) {
  return StreamBuilder<ClovrUserModel>(
    stream: user.userStream,
    builder: (context, snapshot) {
      return Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Image.asset(
              "src/images/text_logo.png",
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      );
    },
  );
}

GestureDetector _buildThemeSwitch(
  AsyncSnapshot<ClovrUserModel> snapshot,
  UserProfileBloc user,
  BuildContext context,
) {
  return GestureDetector(
    onTap: () => _changeTheme(
      snapshot.data.themeId == "WHITE" ? "DARK" : "WHITE",
      user,
      context,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 16.0,
          ),
          child: Container(
            width: 64,
            padding: EdgeInsets.all(4),
            decoration: ShapeDecoration(
              shape: StadiumBorder(),
              color: theme.marketplaceButtonColor,
            ),
            child: Row(
              children: [
                Image.asset(
                  "src/icon/ic_lightmode.png",
                  height: 24,
                  width: 24,
                  color: snapshot.data.themeId == "WHITE"
                      ? Colors.white
                      : Colors.white30,
                ),
                Container(
                  height: 20,
                  width: 8,
                  child: VerticalDivider(
                    color: Colors.white30,
                  ),
                ),
                ImageIcon(
                  AssetImage("src/icon/ic_darkmode.png"),
                  color: snapshot.data.themeId == "DARK"
                      ? Colors.white
                      : Colors.white30,
                  size: 24.0,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Future _changeTheme(
  String themeId,
  UserProfileBloc userProfileBloc,
  BuildContext context,
) async {
  final themeData = Theme.of(context);
  final texts = AppLocalizations.of(context);

  var action = ChangeTheme(themeId);
  userProfileBloc.userActionsSink.add(action);
  action.future.then((_) {}).catchError((err) {
    promptError(
      context,
      texts.home_drawer_error_internal,
      Text(
        err.toString(),
        style: themeData.dialogTheme.contentTextStyle,
      ),
    );
  });
}

Row _buildAvatarButton(AsyncSnapshot<ClovrUserModel> snapshot) {
  return Row(
    children: [
      ClovrLabsAvatar(snapshot.data.avatarURL, radius: 24.0),
    ],
  );
}

Row _buildBottomRow(
  AsyncSnapshot<ClovrUserModel> snapshot,
  BuildContext context,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildUsername(context, snapshot),
    ],
  );
}

Padding _buildUsername(
  BuildContext context,
  AsyncSnapshot<ClovrUserModel> snapshot,
) {
  final texts = AppLocalizations.of(context);

  return Padding(
    padding: EdgeInsets.only(top: 8.0),
    child: AutoSizeText(
      snapshot.data.name ?? texts.home_drawer_error_no_name,
      style: theme.navigationDrawerHandleStyle,
    ),
  );
}

Widget _actionTile(
  DrawerItemConfig action,
  BuildContext context,
  Function onItemSelected, {
  bool subTile,
}) {
  final themeData = Theme.of(context);
  TextStyle itemStyle = theme.drawerItemTextStyle;

  Color color;
  if (action.disabled) {
    color = themeData.disabledColor;
    itemStyle = itemStyle.copyWith(color: color);
  }
  return Padding(
    padding: EdgeInsets.only(
      left: 0.0,
      right: subTile != null ? 0.0 : 16.0,
    ),
    child: Ink(
      decoration: subTile != null
          ? null
          : BoxDecoration(
              color: action.isSelected
                  ? themeData.primaryColorLight
                  : Colors.transparent,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(32),
              ),
            ),
      child: ListTile(
        key: action.key,
        shape: subTile != null
            ? null
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(32),
                ),
              ),
        leading: Padding(
          padding: subTile != null
              ? EdgeInsets.only(left: 28.0)
              : const EdgeInsets.symmetric(horizontal: 8.0),
          child: ImageIcon(
            AssetImage(action.icon),
            size: 26.0,
            color: color,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            action.title,
            style: itemStyle,
          ),
        ),
        trailing: action.switchWidget,
        onTap: action.disabled
            ? null
            : () {
                Navigator.pop(context);
                onItemSelected(action.name);
              },
      ),
    ),
  );
}

class _ExpansionTile extends StatelessWidget {
  final List<Widget> items;
  final String title;
  final AssetImage icon;
  final ScrollController controller;

  const _ExpansionTile({
    Key key,
    this.items,
    this.title,
    this.icon,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final _expansionTileTheme = themeData.copyWith(
      dividerColor: themeData.canvasColor,
    );
    return Theme(
      data: _expansionTileTheme,
      child: ExpansionTile(
          iconColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: icon.assetName == ""
              ? null
              : Text(
                  title,
                  style: TextStyle(color: Colors.white),
                ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: icon.assetName == ""
              ? Text(
                  title,
                  style: theme.drawerItemTextStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : ImageIcon(
                  icon,
                  size: 26.0,
                  color: Colors.white,
                ),
        ),
        children: items
            .map((item) => Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: item,
                ))
            .toList(),
        initiallyExpanded: true,
        onExpansionChanged: (isExpanded) {
          if (isExpanded)
            Timer(
              Duration(milliseconds: 200),
              () => controller.animateTo(
                controller.position.maxScrollExtent + 28.0,
                duration: Duration(milliseconds: 400),
                curve: Curves.ease,
              ),
            );
          // 28 = bottom padding of list + intrinsic bottom padding
        },
      ),
    );
  }
}
