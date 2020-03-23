import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class ItemAvatar extends StatelessWidget {
  final String avatarURL;
  final double radius;
  final String itemName;
  final bool useDecoration;

  ItemAvatar(this.avatarURL,
      {Key key, this.radius = 20.0, this.itemName, this.useDecoration = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (avatarURL != null && avatarURL.isNotEmpty) {
      if (Uri.tryParse(avatarURL)?.scheme?.startsWith("http") ?? false) {
        return _NetworkImageAvatar(radius, avatarURL);
      }
      if (avatarURL.startsWith("#")) {
        return _ColorAvatar(radius, avatarURL);
      }
      if (avatarURL.startsWith("icon:")) {
        return _IconAvatar(radius, avatarURL, useDecoration);
      }

      return _FileImageAvatar(radius, avatarURL);
    }

    return _UnknownAvatar(radius, itemName, useDecoration);
  }
}

class _NetworkImageAvatar extends StatelessWidget {
  final double radius;
  final String avatarURL;

  _NetworkImageAvatar(this.radius, this.avatarURL);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: AdvancedNetworkImage(avatarURL, useDiskCache: true),
    );
  }
}

class _ColorAvatar extends StatelessWidget {
  final double radius;
  final String color;

  _ColorAvatar(this.radius, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: fromHex(color),
        shape: BoxShape.circle,
      ),
    );
  }
}

Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

class _IconAvatar extends StatelessWidget {
  final double radius;
  final String iconName;
  final bool useDecoration;

  _IconAvatar(this.radius, this.iconName, this.useDecoration);

  @override
  Widget build(BuildContext context) {
    // TODO: Map Material Icons library
    Map<String, IconData> iconMapping = {
      'account_balance': Icons.account_balance,
      'map': Icons.map,
      'airline_seat_individual_suite': Icons.airline_seat_individual_suite,
      'attach_money': Icons.attach_money,
      'beach_access': Icons.beach_access,
      'brush': Icons.brush
    };
    String iconName = this.iconName.substring(5);
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: useDecoration
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white, width: 1.0, style: BorderStyle.solid),
              image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).primaryColorLight, BlendMode.srcATop),
                  image: AssetImage("src/images/avatarbg.png"),
                  fit: BoxFit.cover))
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            iconMapping[iconName],
            size: useDecoration ? radius : radius * 1.5,
          ),
        ],
      ),
    );
  }
}

class _FileImageAvatar extends StatelessWidget {
  final double radius;
  final String filePath;

  _FileImageAvatar(this.radius, this.filePath);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius * 2,
      width: radius * 2,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: FileImage(
            File(filePath),
          ),
        ),
      ),
    );
  }
}

class _UnknownAvatar extends StatelessWidget {
  final double radius;
  final String itemName;
  final bool useDecoration;

  _UnknownAvatar(this.radius, this.itemName, this.useDecoration);

  @override
  Widget build(BuildContext context) {
    if (itemName != null && itemName.isNotEmpty) {
      return Container(
        width: radius * 2,
        height: radius * 2,
        decoration: useDecoration
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white, width: 1.0, style: BorderStyle.solid),
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).primaryColorLight, BlendMode.srcATop),
                    image: AssetImage("src/images/avatarbg.png"),
                    fit: BoxFit.cover))
            : null,
        child: Center(
          child: Text(
            _getFirstTwoLetters(),
            style: TextStyle(
                fontSize: useDecoration ? 48 : radius,
                color: Color.fromRGBO(255, 255, 255, 0.88),
                decoration: TextDecoration.underline,
                letterSpacing: 0.0,
                fontFamily: "IBMPlexSans"),
          ),
        ),
      );
    } else {
      return Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.white, width: 1.0, style: BorderStyle.solid),
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColorLight, BlendMode.srcATop),
                image: AssetImage("src/images/avatarbg.png"),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.edit, size: 24),
            Text(
              "Select Image",
              style: TextStyle(
                  fontSize: 12.3,
                  color: Color.fromRGBO(255, 255, 255, 0.88),
                  letterSpacing: 0.0,
                  fontFamily: "IBMPlexSans"),
            ),
          ],
        ),
      );
    }
  }

  String _getFirstTwoLetters() {
    var whitespaceRemovedName = itemName.replaceAll(RegExp(r"\s+\b|\b\s"), "");
    return whitespaceRemovedName
        .substring(
            0,
            whitespaceRemovedName.length >= 2
                ? 2
                : whitespaceRemovedName.length)
        .trim();
  }
}
