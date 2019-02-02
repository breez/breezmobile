import 'package:breez/bloc/blocs_provider.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/breez_avatar.dart';
import 'package:breez/bloc/user_profile/breez_user_model.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/widgets/breez_avatar_dialog.dart';
import 'package:breez/widgets/breez_drawer_header.dart';

class DrawerItemConfig {
  final String name;
  final String title;
  final String icon;
  final void Function(String name) onItemSelected;

  DrawerItemConfig(this.name, this.title, this.icon, {this.onItemSelected});
}

class DrawerItemConfigGroup {
  final List<DrawerItemConfig> items;
  final String groupTitle;
  final String groupAssetImage;

  DrawerItemConfigGroup(this.items, {this.groupTitle, this.groupAssetImage});
}

class NavigationDrawer extends StatelessWidget {
  final bool _avatar;
  final List<DrawerItemConfigGroup> _drawerGroupedItems;
  final void Function(String screenName) _onItemSelected;  

  NavigationDrawer(this._avatar, this._drawerGroupedItems,
      this._onItemSelected);

  @override
  Widget build(BuildContext context) {
    UserProfileBloc userProfileBloc = AppBlocsProvider.of<UserProfileBloc>(context);

    List<Widget> children = List<Widget>();
    _drawerGroupedItems.forEach((gropuItems) {
      children.addAll(_createDrawerGroupWidgets(gropuItems, context,
          withDivider: children.length > 0));
    });

    children.insert(0, _breezDrawerHeader(userProfileBloc, _avatar));

    return new Drawer(
        child: new ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.only(bottom: 20.0),
            children: children));
  }

  List<Widget> _createDrawerGroupWidgets(
      DrawerItemConfigGroup group, BuildContext context,
      {bool withDivider = false}) {
    List<Widget> groupItems = group.items
        .map((action) => _actionTile(action, context, action.onItemSelected ?? _onItemSelected))
        .toList();
    if (group.groupTitle != null && groupItems.length > 0) {
      groupItems = List<Widget>()
        ..add(_ExpansionTile(
            items: groupItems,
            title: group.groupTitle,
            icon: AssetImage(group.groupAssetImage)));
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
  return new BreezDrawerHeader(
    padding: EdgeInsets.only(top: 54.0, left: 16.0),
    child: !drawAvatar
        ? new Container()
        : new StreamBuilder<BreezUserModel>(
            stream: user.userStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return new Container();
              } else {
                return new GestureDetector(
                  onTap: () {
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => breezAvatarDialog(context, user),
                    );
                  },
                  child: new Column(children: <Widget>[
                    new Row(
                      children: <Widget>[
                        BreezAvatar(snapshot.data.avatarURL, radius: 24.0),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.only(top: 22.0), child:
                        new Text(
                          snapshot.data.name ?? "No Name",
                          style: theme.navigationDrawerHandleStyle,
                        ),),
                        new Padding(padding: EdgeInsets.only(top: 11.0,right: 8.0), child:
                        new RawMaterialButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed("/marketplace");
                          },
                          child: ImageIcon(
                              AssetImage("src/icon/ic_market.png"),
                              color: Colors.white, size: 24.0),
                          padding: const EdgeInsets.all(12.0),
                          fillColor: Color(0xFF0085fb),
                          shape: new CircleBorder(),
                          elevation: 0.0,
                        ),),
                      ],
                    ),
                  ]),
                );
              }
            }),
    decoration: new BoxDecoration(
      image: DecorationImage(image: AssetImage("src/images/waves-drawer.png")),
    ),
  );
}

Widget _actionTile(
    DrawerItemConfig action, BuildContext context, Function onItemSelected,
    [bool subTile]) {
  return new Padding(
    padding: subTile != null
        ? EdgeInsets.only(left: 36.0, right: 8.0)
        : EdgeInsets.only(left: 8.0, right: 8.0),
    child: new ListTile(
      leading: ImageIcon(
        AssetImage(action.icon),
        size: 24.0,
        color: Colors.white,
      ),
      title: new Text(action.title, style: theme.drawerItemTextStyle),
      onTap: () {
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

  const _ExpansionTile({Key key, this.items, this.title, this.icon})
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
              size: 24.0,
              color: Colors.white,
            ),
          ),
          children: items.map((item) => Padding(padding: EdgeInsets.only(left: 28.0), child: item)).toList(),
        ));
  }
}
