import 'package:breez/bloc/lsp/lsp_actions.dart';
import 'package:breez/bloc/lsp/lsp_bloc.dart';
import 'package:breez/bloc/lsp/lsp_model.dart';
import 'package:breez/widgets/loader.dart';
import 'package:breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:breez/theme_data.dart' as theme;
import 'package:breez/widgets/back_button.dart' as backBtn;

class SelectLSPPage extends StatefulWidget {
  @override
  SelectLSPPageState createState() {
    return new SelectLSPPageState();
  }
}

class SelectLSPPageState extends State<SelectLSPPage> {
  LSPBloc _bloc;
  String _selectedLSPId;
  dynamic _error;

  @override
  void initState() {
    super.initState();
    _bloc = new LSPBloc();
    var fetchAction = FetchLSPList();
    _bloc.actionsSink.add(fetchAction);
    fetchAction.future.catchError((err) {
      setState(() {
        _error = err;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        textTheme: Theme.of(context).appBarTheme.textTheme,
        backgroundColor: theme.BreezColors.blue[500],
        leading: backBtn.BackButton(),
        elevation: 0.0,
        title: new Text(
          "Lightning Service Provider",
          style: Theme.of(context).appBarTheme.textTheme.title,
        ),
      ),
      body: StreamBuilder<List<LSPInfo>>(
          stream: _bloc.lspsStream,
          builder: (ctx, snapshot) {
            if (_error != null) {
              return Text("Error: " + _error.toString());
            }

            if (!snapshot.hasData) {
              return Center(child: Loader());
            }

            var lsps = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                shrinkWrap: false,
                itemCount: lsps.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    selected: _selectedLSPId == lsps[index].lspID,
                    trailing: _selectedLSPId == lsps[index].lspID
                        ? Icon(Icons.check)
                        : null,
                    title: Text(
                      lsps[index].name,                    
                    ),
                    subtitle: Text(
                      lsps[index].lspID,                    
                    ),
                    onTap: () {
                      setState(() {
                        _selectedLSPId = lsps[index].lspID;
                      });
                    },
                  );
                },
              ),
            );
          }),
      bottomNavigationBar: _selectedLSPId != null
          ? SingleButtonBottomBar(
              text: "SELECT",
              onPressed: () {
                _bloc.actionsSink.add(ConnectLSP(_selectedLSPId));
                Navigator.of(context).pop();           
              })
          : null,
    );
  }
}
