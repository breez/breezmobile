import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A network image builder with shimmer as loader
class CustomImageBuilderWidget extends StatelessWidget {
  const CustomImageBuilderWidget({
    Key key,
    this.imageurl,
    this.height = 200,
    this.width,
    this.boxfit,
  }) : super(key: key);
  final String imageurl;
  final double height;
  final double width;
  final BoxFit boxfit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageurl,
      height: height,
      width: width,
      fit: boxfit ?? BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Shimmer.fromColors(
            child: Container(
              height: height,
              width: width,
              color: Color(0xffA5B2BE),
            ),
            baseColor: Color(0xffA5B2BE),
            highlightColor: Colors.white,
            period: const Duration(milliseconds: 1000));
      },
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.error,
          color: Color(0xffA5B2BE),
          size: 50,
        );
      },
    );
  }
}
