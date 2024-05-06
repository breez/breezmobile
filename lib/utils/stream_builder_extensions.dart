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

typedef AsyncWidgetBuilder3<A, B, C> = Widget Function(
  BuildContext context,
  AsyncSnapshot<A> snapshotA,
  AsyncSnapshot<B> snapshotB,
  AsyncSnapshot<C> snapshotC,
);

class StreamBuilder3<A, B, C> extends StatelessWidget {
  final Stream<A> streamA;
  final Stream<B> streamB;
  final Stream<C> streamC;
  final AsyncWidgetBuilder3<A, B, C> builder;

  const StreamBuilder3({
    Key key,
    @required this.streamA,
    @required this.streamB,
    @required this.streamC,
    @required this.builder,
  })  : assert(streamA != null),
        assert(streamB != null),
        assert(streamC != null),
        assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamA,
      builder: (context, snapshotA) => StreamBuilder(
        stream: streamB,
        builder: (context, snapshotB) => StreamBuilder(
          stream: streamC,
          builder: (context, snapshotC) => builder(context, snapshotA, snapshotB, snapshotC),
        ),
      ),
    );
  }
}

typedef AsyncWidgetBuilder4<A, B, C, D> = Widget Function(
  BuildContext context,
  AsyncSnapshot<A> snapshotA,
  AsyncSnapshot<B> snapshotB,
  AsyncSnapshot<C> snapshotC,
  AsyncSnapshot<D> snapshotD,
);

class StreamBuilder4<A, B, C, D> extends StatelessWidget {
  final Stream<A> streamA;
  final Stream<B> streamB;
  final Stream<C> streamC;
  final Stream<D> streamD;
  final AsyncWidgetBuilder4<A, B, C, D> builder;

  const StreamBuilder4({
    Key key,
    @required this.streamA,
    @required this.streamB,
    @required this.streamC,
    @required this.streamD,
    @required this.builder,
  })  : assert(streamA != null),
        assert(streamB != null),
        assert(streamC != null),
        assert(streamD != null),
        assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamA,
      builder: (context, snapshotA) => StreamBuilder(
        stream: streamB,
        builder: (context, snapshotB) => StreamBuilder(
          stream: streamC,
          builder: (context, snapshotC) => StreamBuilder(
            stream: streamD,
            builder: (context, snapshotD) => builder(context, snapshotA, snapshotB, snapshotC, snapshotD),
          ),
        ),
      ),
    );
  }
}

typedef AsyncWidgetBuilder5<A, B, C, D, E> = Widget Function(
  BuildContext context,
  AsyncSnapshot<A> snapshotA,
  AsyncSnapshot<B> snapshotB,
  AsyncSnapshot<C> snapshotC,
  AsyncSnapshot<D> snapshotD,
  AsyncSnapshot<E> snapshotE,
);

class StreamBuilder5<A, B, C, D, E> extends StatelessWidget {
  final Stream<A> streamA;
  final Stream<B> streamB;
  final Stream<C> streamC;
  final Stream<D> streamD;
  final Stream<E> streamE;
  final AsyncWidgetBuilder5<A, B, C, D, E> builder;

  const StreamBuilder5({
    Key key,
    @required this.streamA,
    @required this.streamB,
    @required this.streamC,
    @required this.streamD,
    @required this.streamE,
    @required this.builder,
  })  : assert(streamA != null),
        assert(streamB != null),
        assert(streamC != null),
        assert(streamD != null),
        assert(streamE != null),
        assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamA,
      builder: (context, snapshotA) => StreamBuilder(
        stream: streamB,
        builder: (context, snapshotB) => StreamBuilder(
          stream: streamC,
          builder: (context, snapshotC) => StreamBuilder(
            stream: streamD,
            builder: (context, snapshotD) => StreamBuilder(
              stream: streamE,
              builder: (context, snapshotE) => builder(
                context,
                snapshotA,
                snapshotB,
                snapshotC,
                snapshotD,
                snapshotE,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef AsyncWidgetBuilder6<A, B, C, D, E, F> = Widget Function(
  BuildContext context,
  AsyncSnapshot<A> snapshotA,
  AsyncSnapshot<B> snapshotB,
  AsyncSnapshot<C> snapshotC,
  AsyncSnapshot<D> snapshotD,
  AsyncSnapshot<E> snapshotE,
  AsyncSnapshot<F> snapshotF,
);

class StreamBuilder6<A, B, C, D, E, F> extends StatelessWidget {
  final Stream<A> streamA;
  final Stream<B> streamB;
  final Stream<C> streamC;
  final Stream<D> streamD;
  final Stream<E> streamE;
  final Stream<F> streamF;
  final AsyncWidgetBuilder6<A, B, C, D, E, F> builder;

  const StreamBuilder6({
    Key key,
    @required this.streamA,
    @required this.streamB,
    @required this.streamC,
    @required this.streamD,
    @required this.streamE,
    @required this.streamF,
    @required this.builder,
  })  : assert(streamA != null),
        assert(streamB != null),
        assert(streamC != null),
        assert(streamD != null),
        assert(streamE != null),
        assert(streamF != null),
        assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamA,
      builder: (context, snapshotA) => StreamBuilder(
        stream: streamB,
        builder: (context, snapshotB) => StreamBuilder(
          stream: streamC,
          builder: (context, snapshotC) => StreamBuilder(
            stream: streamD,
            builder: (context, snapshotD) => StreamBuilder(
              stream: streamE,
              builder: (context, snapshotE) => StreamBuilder(
                stream: streamF,
                builder: (context, snapshotF) => builder(
                  context,
                  snapshotA,
                  snapshotB,
                  snapshotC,
                  snapshotD,
                  snapshotE,
                  snapshotF,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
