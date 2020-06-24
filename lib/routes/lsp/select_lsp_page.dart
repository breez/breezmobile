import 'package:breez/bloc/lsp/lsp_actions.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'lsp_webview.dart';

class SelectLSPPage extends StatefulWidget {
  final LSPBloc lstBloc;

  const SelectLSPPage({Key key, this.lstBloc}) : super(key: key);

  @override
  SelectLSPPageState createState() {
    return SelectLSPPageState();
  }
}

class SelectLSPPageState extends State<SelectLSPPage> {
  LSPInfo _selectedLSP;
  dynamic _error;

  @override
  void initState() {
    super.initState();
    _fetchLSPS();
  }

  void _fetchLSPS() {
    var fetchAction = FetchLSPList();
    widget.lstBloc.actionsSink.add(fetchAction);
    fetchAction.future.then((result) {
      List<LSPInfo> lspList = result as List<LSPInfo>;
      var breezLSP = lspList.firstWhere(
          (l) => l.lspID == "62b09753-c742-4150-9656-5e5a55eefba0",
          orElse: () => null);
      if (breezLSP != null && _selectedLSP == null) {
        setState(() {
          _selectedLSP = breezLSP;
        });
      }
    }).catchError((err) {
      setState(() {
        _error = err;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          "Select a Lightning Provider",
          style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () => Navigator.pop(context),
              // Color needs to be changed
              icon: Icon(Icons.close,
                  color: Theme.of(context).appBarTheme.iconTheme.color))
        ],
      ),
      body: StreamBuilder<LSPStatus>(
          stream: widget.lstBloc.lspStatusStream,
          builder: (ctx, snapshot) {
            if (_error != null) {
              return Padding(
                padding: EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                        "There was an error fetching lightning providers. Please check your internet connection and try again.",
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data.availableLSPs.length == 0) {
              return Center(child: Loader());
            }

            var lsps = snapshot.data.availableLSPs ?? [];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Flexible(
                      child: Text(
                    "Please select one of the following providers in order to activate Breez and connect to the Lightning network.",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.left,
                  )),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: lsps.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 0.0),
                            selected: _selectedLSP?.lspID == lsps[index].lspID,
                            trailing: _selectedLSP?.lspID == lsps[index].lspID
                                ? Icon(Icons.check)
                                : null,
                            title: Text(
                              lsps[index].name,
                            ),
                            onTap: () {
                              setState(() {
                                _selectedLSP = lsps[index];
                              });
                            },
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildBottomButton() {
    if (_error != null) {
      return SingleButtonBottomBar(
        text: "RETRY",
        onPressed: () {
          setState(() {
            _error = null;
            _fetchLSPS();
          });
        },
      );
    }
    if (_selectedLSP != null) {
      return SingleButtonBottomBar(
          text: "SELECT",
          onPressed: () async {
            ConnectLSP connectAction;
            if (_selectedLSP.widgetURL?.isNotEmpty == true) {
              String lnurl = await Navigator.of(context).push<String>(
                  FadeInRoute(
                      builder: (_) => LSPWebViewPage(
                          null, _selectedLSP.widgetURL, _selectedLSP.name)));
              if (lnurl != null) {
                connectAction = ConnectLSP(_selectedLSP.lspID, lnurl);
              }
            } else {
              connectAction = ConnectLSP(_selectedLSP.lspID, null);
            }

            if (connectAction != null) {
              widget.lstBloc.actionsSink.add(connectAction);
              Navigator.of(context).pop();
            }
          });
    }
    return null;
  }
}
