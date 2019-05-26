import 'package:breez/bloc/account/account_actions.dart';
import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/transparent_page_route.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;

class SyncUIHandler {  
  final AccountBloc _accountBloc;
  final BuildContext _context;
  ModalRoute _syncUIRoute;      

  SyncUIHandler (this._accountBloc, this._context){
     _accountBloc.accountStream.listen((acc){
       showSyncUI(acc);
     });
  }

  void showSyncUI(AccountModel acc){
    if (acc.syncUIState == SyncUIState.BLOCKING) {
      if (_syncUIRoute == null) { 
        
        _syncUIRoute = _createSyncRoute(_accountBloc);
        Navigator.of(_context).push(_syncUIRoute);
      }
    } else {
      if (_syncUIRoute != null) {        
        Navigator.of(this._context).pop();
        _syncUIRoute = null;
      }
    }
  }
}

ModalRoute _createSyncRoute(AccountBloc accBloc){
  return SyncUIRoute((context){
    return StreamBuilder<AccountModel>(
        stream: accBloc.accountStream,
        builder: (ctx, snapshot){
          var account = snapshot.data;
          double progress = account?.syncProgress;
          return TransparentRouteLoader(
            message: "Synchronizing Blockchain...", 
            value: progress, 
            onClose: () => accBloc.userActionsSink.add(ChangeSyncUIState(SyncUIState.COLLAPSED)),
          );
        },
      );
  });
}

class SyncUIRoute extends TransparentPageRoute {

  SyncUIRoute(Widget Function(BuildContext context) builder) : super(builder);
  
  @override Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {    
    
    var curv = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    return ScaleTransition(scale: curv, child: child, alignment: Alignment.topRight);    
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}

class TransparentRouteLoader extends StatefulWidget {
  final String message;
  final double opacity;
  final double value;
  final Function onClose;

  const TransparentRouteLoader({Key key, this.message, this.opacity = 0.5, this.value, this.onClose})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {    
    return TransparentRouteLoaderState();
  }
}

class TransparentRouteLoaderState extends State<TransparentRouteLoader> {

  @override void didUpdateWidget(TransparentRouteLoader oldWidget) {    
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != this.widget.message || oldWidget.opacity != this.widget.opacity || oldWidget.value != this.widget.value) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullScreenLoader(
      message: "Synchronizing ${( (widget.value ?? 0) * 100).round().toString()}%", 
      value: widget.value, 
      bgColor: theme.BreezColors.blue[500],
      opacity: 0.8,
      progressColor: theme.whiteColor,
      onClose: this.widget.onClose,
    );    
  }
}