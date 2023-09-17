import 'package:flutter/material.dart';

class CommentUserImage extends StatefulWidget {
  final String userImage;
  CommentUserImage({Key key, this.userImage}) : super(key: key);

  @override
  State<CommentUserImage> createState() => _CommentUserImageState();
}

class _CommentUserImageState extends State<CommentUserImage> {
  bool _loadImageError = false;
  ImageProvider commentImageParser({String imageURLorPath}) {
    //check if imageURLorPath
    try {
      if (imageURLorPath is String) {
        if (imageURLorPath.startsWith('http')) {
          return NetworkImage(imageURLorPath);
        } else {
          return AssetImage(imageURLorPath);
        }
      } else {
        return imageURLorPath as ImageProvider;
      }
    } catch (e) {
      setState(() {
        _loadImageError = true;
      });
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return CircleAvatar(
      backgroundImage: widget.userImage != null
          ? commentImageParser(
              imageURLorPath: widget.userImage,
            )
          : null,
      child: widget.userImage == null || _loadImageError
          ? Icon(
              Icons.person,
              color: themeData.iconTheme.color,
            )
          : null,
    );
  }
}
