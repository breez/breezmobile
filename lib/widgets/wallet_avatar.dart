import 'package:clovrlabs_wallet/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ClovrLabsAvatar extends StatelessWidget {
  final String avatarURL;
  final double radius;
  final Color backgroundColor;

  ClovrLabsAvatar(this.avatarURL, {this.radius = 20.0, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    Color avatarBgColor =
        this.backgroundColor ?? theme.sessionAvatarBackgroundColor;

    return Avatar(radius, avatarBgColor);
  }
}

class Avatar extends StatelessWidget {
  final double radius;
  final Color backgroundColor;

  Avatar(this.radius, this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: backgroundColor,
        radius: radius,
        child: Image.asset("src/images/unknown.png",
            width: 0.70 * radius * 2, height: 0.70 * radius * 2));
  }
}
