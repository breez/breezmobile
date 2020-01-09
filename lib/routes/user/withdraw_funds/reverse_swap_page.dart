import 'dart:async';

import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_model.dart';
import 'package:breez/routes/user/withdraw_funds/reverse_swap_confirmation.dart';
import 'package:breez/routes/user/withdraw_funds/withdraw_funds_page.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;

class ReverseSwapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReverseSwapPageState();
  }
}

class ReverseSwapPageState extends State<ReverseSwapPage> {
  StreamController<ReverseSwapInfo> _reverseSwapsStream =
      new BehaviorSubject<ReverseSwapInfo>();
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ReverseSwapBloc reverseSwapBloc = AppBlocsProvider.of<ReverseSwapBloc>(context);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: new NeverScrollableScrollPhysics(),
        children: <Widget>[
          WithdrawFundsPage(onNext: (swap) {
            _reverseSwapsStream.add(swap);
            _pageController.nextPage(
                duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
          }),
          StreamBuilder<ReverseSwapInfo>(
            stream: _reverseSwapsStream.stream,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return SizedBox();
              }
              return ReverseSwapConfirmation(
                  swap: snapshot.data,
                  bloc: reverseSwapBloc,
                  onSuccess: () {
                    Navigator.of(context)
                        .pop("We wil notify you when the swap is confirmed.");
                  },
                  onPrevious: () {
                    _pageController
                        .previousPage(
                            duration: Duration(milliseconds: 250),
                            curve: Curves.easeInOut)
                        .then((_) {
                      _reverseSwapsStream.add(null);
                    });
                  });
            },
          ),
        ],
      ),
    );
  }
}
