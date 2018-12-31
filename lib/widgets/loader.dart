import 'package:breez/widgets/transparent_page_route.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: FractionalOffset.center, children: <Widget>[
      new CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(51, 255, 255, 0.7),),
        backgroundColor: Colors.red,
      ),
    ]);
  }
}

TransparentPageRoute createLoaderRoute(BuildContext context, {String message, double opacity = 0.3}){    
    return TransparentPageRoute((context){
        return Material(       
          type: MaterialType.transparency, 
          child: Container(
            color: Colors.black.withOpacity(opacity),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Loader(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: message != null ? Text(message,textAlign: TextAlign.center) : SizedBox(),
                )
              ],                    
            )
          ),
        );
      });
  }
