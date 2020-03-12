import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  final Widget icon;
  final int number;
  final Color badgeBGColor;
  final Color textColor;
  final Function() onPress;

  const BadgeIcon(
      {Key key,
      this.icon,
      this.number,
      this.onPress,
      this.badgeBGColor,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
      position: BadgePosition.topRight(top: -5, right: -5),
      animationType: BadgeAnimationType.scale,
      badgeColor: badgeBGColor,
      badgeContent: Text(
        number.toString(),
        style: TextStyle(color: textColor),
      ),
      child: icon,
    );
  }
}
