import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/account/account_model.dart';
import 'package:breez/bloc/account/add_funds_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/widgets/back_button.dart' as backBtn;
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';

import 'address_widget.dart';
import 'conditional_deposit.dart';

class DepositToBTCAddressPage extends StatefulWidget {
  final AccountBloc _accountBloc;

  const DepositToBTCAddressPage(this._accountBloc);

  @override
  State<StatefulWidget> createState() {
    return DepositToBTCAddressPageState();
  }
}

class DepositToBTCAddressPageState extends State<DepositToBTCAddressPage> {
  final String _title = "Receive via BTC Address";
  AddFundsBloc _addFundsBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_addFundsBloc == null) {
      _addFundsBloc = BlocProvider.of<AddFundsBloc>(context);
      _addFundsBloc.addFundRequestSink.add(false);
      _addFundsBloc.addFundRequestSink.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    AccountBloc accountBloc = AppBlocsProvider.of<AccountBloc>(context);
    var lspBloc = AppBlocsProvider.of<LSPBloc>(context);
    return ConditionalDeposit(
        title: _title,
        enabledChild: StreamBuilder<LSPStatus>(
            stream: lspBloc.lspStatusStream,
            builder:
                (BuildContext context, AsyncSnapshot<LSPStatus> lspSnapshot) {
              return StreamBuilder(
                  stream: accountBloc.accountStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<AccountModel> accSnapshot) {
                    return StreamBuilder(
                        stream: _addFundsBloc.addFundResponseStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<AddFundResponse> snapshot) {
                          return Material(
                            child: Scaffold(
                                appBar: AppBar(
                                  iconTheme:
                                      Theme.of(context).appBarTheme.iconTheme,
                                  textTheme:
                                      Theme.of(context).appBarTheme.textTheme,
                                  backgroundColor:
                                      Theme.of(context).canvasColor,
                                  leading: backBtn.BackButton(),
                                  title: Text(
                                    _title,
                                    style: Theme.of(context)
                                        .appBarTheme
                                        .textTheme
                                        .headline6,
                                  ),
                                  elevation: 0.0,
                                ),
                                body: getBody(
                                    context,
                                    accSnapshot.data,
                                    snapshot.data,
                                    lspSnapshot.data,
                                    snapshot.hasError
                                        ? "Failed to retrieve an address from Breez server\nPlease check your internet connection."
                                        : null),
                                bottomNavigationBar: _buildBottomBar(
                                    snapshot.data, accSnapshot.data,
                                    hasError: snapshot.hasError)),
                          );
                        });
                  });
            }));
  }

  Widget getBody(BuildContext context, AccountModel account,
      AddFundResponse response, LSPStatus lspStatus, String error) {
    String errorMessage;
    if (error != null) {
      errorMessage = error;
    } else if (response != null && response.errorMessage.isNotEmpty) {
      errorMessage = response.errorMessage;
    }
    if (errorMessage != null) {
      if (!errorMessage.endsWith('.')) {
        errorMessage += '.';
      }
      return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
            child: Text(errorMessage, textAlign: TextAlign.center),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AddressWidget(response?.address, response?.backupJson),
          response == null
              ? SizedBox()
              : WarningBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Send up to " +
                            account.currency.format(response.maxAllowedDeposit,
                                includeDisplayName: true) +
                            " to this address.",
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        formatFeeMessage(account, lspStatus.currentLSP),
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  String formatFeeMessage(AccountModel acc, LSPInfo lsp) {
    if (acc.connected) {
      var liquidity = acc.currency.format(acc.maxInboundLiquidity);
      return "A setup fee of ${lsp.channelFeePermyriad / 100}% will be applied for sending more than $liquidity.";
    }
    return "A setup fee of ${lsp.channelFeePermyriad / 100}% will be applied on the received amount.";
  }

  Widget _buildBottomBar(AddFundResponse response, AccountModel account,
      {hasError = false}) {
    if (hasError || response?.errorMessage?.isNotEmpty == true) {
      return SingleButtonBottomBar(
          text: hasError ? "RETRY" : "CLOSE",
          onPressed: () {
            if (hasError) {
              _addFundsBloc.addFundRequestSink.add(true);
            } else {
              Navigator.of(context).pop();
            }
          });
    }

    return SizedBox();
  }
}
