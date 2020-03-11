import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  final IconData iconData;
  final int number;
  final Function() onPress;

  const BadgeIcon({Key key, this.iconData, this.number, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
      position: BadgePosition.topRight(top: 0, right: 3),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: Text(
        number.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(
          icon: Icon(this.iconData),
          color: Theme.of(context).textTheme.button.color,
          onPressed: onPress),
    );
  }
}
