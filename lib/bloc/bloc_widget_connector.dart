import 'package:flutter/cupertino.dart';

/*
provider inherited data accessible along the widgets tree
*/
class BlocProvider<T> extends InheritedWidget {
  
  final T store;

  BlocProvider(this.store, Widget child) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}


typedef Widget StoreConsumerBuilde<T>(
  BuildContext context,
  T store
);

/*
Easy way to consume the store data when building widgets
*/
class BlocConnector<T> extends StatelessWidget {
  
  final StoreConsumerBuilde<T> builder;

  BlocConnector(this.builder);

  @override
  Widget build(BuildContext context) {
    BlocProvider<T> provider = context.inheritFromWidgetOfExactType(new BlocProvider<T>(null, null).runtimeType) as BlocProvider<T>;
    return builder(context, provider.store);
  }
}