import 'package:flutter/material.dart';

/*
FixedSliverDelegate is a delegate that renders a sliver in a fixed height.
*/
class FixedSliverDelegate extends SliverPersistentHeaderDelegate {
  final double _height;
  final Widget child;
  final Function(
      BuildContext context, double shrinkOffset, bool overlapsContent) builder;

  FixedSliverDelegate(this._height, {this.child, this.builder});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    if (builder != null) {
      return builder(context, shrinkOffset, overlapsContent);
    }
    return child;
  }

  // TODO: implement maxExtent
  @override
  double get maxExtent => _height;

  // TODO: implement minExtent
  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
