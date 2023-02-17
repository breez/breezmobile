import 'package:breez/bloc/lsp/lsp_actions.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/route.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

import 'lsp_webview.dart';

class SelectLSPPage extends StatefulWidget {
  final LSPBloc lstBloc;

  const SelectLSPPage({
    Key key,
    this.lstBloc,
  }) : super(key: key);

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
        orElse: () => null,
      );
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
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(texts.account_page_activation_provider_label),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            // Color needs to be changed
            icon: Icon(
              Icons.close,
              color: themeData.appBarTheme.iconTheme.color,
            ),
          ),
        ],
      ),
      body: StreamBuilder<LSPStatus>(
        stream: widget.lstBloc.lspStatusStream,
        builder: (ctx, snapshot) {
          if (_error != null) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    texts.account_page_activation_error,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data.availableLSPs.isEmpty) {
            return const Center(child: Loader());
          }

          final lsps = snapshot.data.availableLSPs ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Text(
                    texts.account_page_activation_provider_hint,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: ListView.builder(
                      shrinkWrap: false,
                      itemCount: lsps.length,
                      itemBuilder: (BuildContext context, int index) {
                        var selected = _selectedLSP?.lspID == lsps[index].lspID;
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                          selected: selected,
                          trailing: selected ? const Icon(Icons.check) : null,
                          title: Text(lsps[index].name),
                          onTap: () => setState(() {
                            _selectedLSP = lsps[index];
                          }),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    final texts = context.texts();

    if (_error != null) {
      return SingleButtonBottomBar(
        text: texts.account_page_activation_action_retry,
        onPressed: () {
          setState(() {
            _error = null;
            _fetchLSPS();
          });
        },
      );
    }
    if (_selectedLSP != null) {
      final url = _selectedLSP.widgetURL;
      return SingleButtonBottomBar(
        text: texts.account_page_activation_action_select,
        onPressed: () async {
          ConnectLSP connectAction;
          if (url?.isNotEmpty == true) {
            final lnurl = await Navigator.of(context).push<String>(
              FadeInRoute(
                builder: (_) => LSPWebViewPage(
                  url,
                  _selectedLSP.name,
                ),
              ),
            );
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
        },
      );
    }
    return null;
  }
}
