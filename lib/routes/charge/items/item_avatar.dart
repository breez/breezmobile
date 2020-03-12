import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class ItemAvatar extends StatelessWidget {
  final String avatarURL;
  final double radius;

  ItemAvatar(this.avatarURL, {this.radius = 20.0});

  @override
  Widget build(BuildContext context) {
    if (avatarURL != null && avatarURL.isNotEmpty) {
      if (Uri.tryParse(avatarURL)?.scheme?.startsWith("http") ?? false) {
        return _NetworkImageAvatar(avatarURL, radius);
      }
      if (avatarURL.startsWith("#")) {
        return _ColorAvatar(radius, avatarURL);
      }
      return _FileImageAvatar(radius, avatarURL);
    }

    return _UnknownAvatar(radius);
  }
}

class _UnknownAvatar extends StatelessWidget {
  final double radius;

  _UnknownAvatar(this.radius);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      child: Center(
        child: Icon(Icons.airplanemode_active, size: radius * 1.5),
      ),
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

class _NetworkImageAvatar extends StatelessWidget {
  final double radius;
  final String avatarURL;

  _NetworkImageAvatar(this.avatarURL, this.radius);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: AdvancedNetworkImage(avatarURL, useDiskCache: true),
    );
  }
}
