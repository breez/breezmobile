import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_actions.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/breez_avatar.dart';
import 'package:breez/widgets/breez_avatar_dialog.dart';
import 'package:breez/widgets/breez_drawer_header.dart';
import 'package:breez/widgets/error_dialog.dart';
import 'package:flutter/material.dart';

class DrawerItemConfig {
  final String name;
  final String title;
  final String icon;
  final bool disabled;
  final void Function(String name) onItemSelected;
  final void Function() onToggle;
  var toggleValue;

  DrawerItemConfig(this.name, this.title, this.icon,
      {this.onItemSelected,
      this.disabled = false,
      this.onToggle,
      this.toggleValue});
}

class DrawerItemConfigGroup {
  final List<DrawerItemConfig> items;
  final String groupTitle;
  final String groupAssetImage;
  final bool withDivider;

  DrawerItemConfigGroup(this.items,
      {this.groupTitle, this.groupAssetImage, this.withDivider = true});
}

class NavigationDrawer extends StatelessWidget {
  final bool _avatar;
  final List<DrawerItemConfigGroup> _drawerGroupedItems;
  final void Function(String screenName) _onItemSelected;

  NavigationDrawer(
      this._avatar, this._drawerGroupedItems, this._onItemSelected);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    UserProfileBloc userProfileBloc =
        AppBlocsProvider.of<UserProfileBloc>(context);

    List<Widget> children = List<Widget>();
    _drawerGroupedItems.forEach((gropuItems) {
      children.addAll(_createDrawerGroupWidgets(gropuItems, context,
          withDivider: children.length > 0 && gropuItems.withDivider));
    });

    children.insert(0, _breezDrawerHeader(userProfileBloc, _avatar));

    return Drawer(
        child: ListView(
            controller: _scrollController,
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.only(bottom: 20.0),
            children: children));
  }

  List<Widget> _createDrawerGroupWidgets(
      DrawerItemConfigGroup group, BuildContext context,
      {bool withDivider = false}) {
    List<Widget> groupItems = group.items
        .map((action) => _actionTile(
            action, context, action.onItemSelected ?? _onItemSelected))
        .toList();
    if (group.groupTitle != null && groupItems.length > 0) {
      groupItems = List<Widget>()
        ..add(_ExpansionTile(
            items: groupItems,
            title: group.groupTitle,
            icon: AssetImage(group.groupAssetImage),
            controller: _scrollController));
    }

    if (groupItems.length > 0 && withDivider) {
      groupItems.insert(0, _ListDivider());
    }
    return groupItems;
  }
}

class _ListDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0), child: Divider());
  }
}

Widget _breezDrawerHeader(UserProfileBloc user, bool drawAvatar) {
  return BreezDrawerHeader(
    padding: EdgeInsets.only(left: 16.0),
    child: _buildDrawerHeaderContent(user, drawAvatar),
    decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage("src/images/waves-drawer.png"),
          fit: BoxFit.scaleDown,
          alignment: Alignment(0, 0)),
    ),
  );
}

StreamBuilder<BreezUserModel> _buildDrawerHeaderContent(
    UserProfileBloc user, bool drawAvatar) {
  return StreamBuilder<BreezUserModel>(
      stream: user.userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          List<Widget> drawerHeaderContent = List<Widget>();
          drawerHeaderContent.add(_buildThemeSwitch(snapshot, user, context));
          if (drawAvatar) {
            drawerHeaderContent
              ..add(_buildAvatarButton(snapshot))
              ..add(_buildBottomRow(snapshot, context));
          }
          return GestureDetector(
            onTap: drawAvatar
                ? () {
                    showDialog<bool>(
                      useRootNavigator: false,
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => breezAvatarDialog(context, user),
                    );
                  }
                : null,
            child: Column(children: drawerHeaderContent),
          );
        }
      });
}

GestureDetector _buildThemeSwitch(AsyncSnapshot<BreezUserModel> snapshot,
    UserProfileBloc user, BuildContext context) {
  return GestureDetector(
    onTap: () => _changeTheme(
        snapshot.data.themeId == "BLUE" ? "DARK" : "BLUE", user, context),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 16.0,
          ),
          child: Container(
            width: 64,
            padding: EdgeInsets.all(4),
            decoration: ShapeDecoration(
                shape: StadiumBorder(), color: theme.marketplaceButtonColor),
            child: Row(
              children: <Widget>[
                Image.asset(
                  "src/icon/ic_lightmode.png",
                  height: 24,
                  width: 24,
                  color: snapshot.data.themeId == "BLUE"
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
                ImageIcon(AssetImage("src/icon/ic_darkmode.png"),
                    color: snapshot.data.themeId == "DARK"
                        ? Colors.white
                        : Colors.white30,
                    size: 24.0),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Future _changeTheme(String themeId, UserProfileBloc userProfileBloc,
    BuildContext context) async {
  var action = ChangeTheme(themeId);
  userProfileBloc.userActionsSink.add(action);
  action.future.then((_) {}).catchError((err) {
    promptError(
        context,
        "Internal Error",
        Text(
          err.toString(),
          style: Theme.of(context).dialogTheme.contentTextStyle,
        ));
  });
}

Row _buildAvatarButton(AsyncSnapshot<BreezUserModel> snapshot) {
  return Row(
    children: <Widget>[
      BreezAvatar(snapshot.data.avatarURL, radius: 24.0),
    ],
  );
}

Row _buildBottomRow(
    AsyncSnapshot<BreezUserModel> snapshot, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      _buildUsername(snapshot),
    ],
  );
}

Padding _buildUsername(AsyncSnapshot<BreezUserModel> snapshot) {
  return Padding(
    padding: EdgeInsets.only(top: 8.0),
    child: AutoSizeText(
      snapshot.data.name ?? "No Name",
      style: theme.navigationDrawerHandleStyle,
    ),
  );
}

Widget _actionTile(
    DrawerItemConfig action, BuildContext context, Function onItemSelected,
    [bool subTile]) {
  TextStyle itemStyle = theme.drawerItemTextStyle;
  Color color = DefaultTextStyle.of(context).style.color;
  if (action.disabled) {
    color = Theme.of(context).disabledColor;
    itemStyle = itemStyle.copyWith(color: color);
  }
  return Padding(
    padding: subTile != null
        ? EdgeInsets.only(left: 36.0, right: 8.0)
        : EdgeInsets.only(left: 8.0, right: 8.0),
    child: ListTile(
      leading: ImageIcon(
        AssetImage(action.icon),
        size: 26.0,
        color: color,
      ),
      title: Text(action.title, style: itemStyle),
      trailing: action.onToggle != null
          ? Switch(
              activeColor: Colors.white,
              value: action.toggleValue,
              onChanged: (_) {
                action.onToggle();
              })
          : null,
      onTap: action.disabled
          ? null
          : () {
              Navigator.pop(context);
              onItemSelected(action.name);
            },
    ),
  );
}

class _ExpansionTile extends StatelessWidget {
  final List<Widget> items;
  final String title;
  final AssetImage icon;
  final ScrollController controller;

  const _ExpansionTile(
      {Key key, this.items, this.title, this.icon, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _expansionTileTheme =
        Theme.of(context).copyWith(dividerColor: Theme.of(context).canvasColor);
    return Theme(
        data: _expansionTileTheme,
        child: ExpansionTile(
          title: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              title,
              style: theme.drawerItemTextStyle,
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: ImageIcon(
              icon,
              size: 26.0,
              color: Colors.white,
            ),
          ),
          children: items
              .map((item) =>
                  Padding(padding: EdgeInsets.only(left: 28.0), child: item))
              .toList(),
          onExpansionChanged: (isExpanded) {
            if (isExpanded)
              Timer(
                  Duration(milliseconds: 200),
                  () => controller.animateTo(
                      controller.position.maxScrollExtent + 28.0,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.ease));
            // 28 = bottom padding of list + intrinsic bottom padding
          },
        ));
  }
}
