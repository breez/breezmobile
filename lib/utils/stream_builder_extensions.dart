import 'package:flutter/material.dart';

typedef AsyncWidgetBuilder2<A, B> = Widget Function(
  BuildContext context,
  AsyncSnapshot<A> snapshotA,
  AsyncSnapshot<B> snapshotB,
);

class StreamBuilder2<A, B> extends StatelessWidget {
  final Stream<A> streamA;
  final Stream<B> streamB;
  final AsyncWidgetBuilder2<A, B> builder;

  const StreamBuilder2({
    Key key,
    @required this.streamA,
    @required this.streamB,
    @required this.builder,
  })  : assert(streamA != null),
        assert(streamB != null),
        assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamA,
      builder: (context, snapshotA) => StreamBuilder(
        stream: streamB,
        builder: (context, snapshotB) => builder(context, snapshotA, snapshotB),
      ),
    );
  }
}
