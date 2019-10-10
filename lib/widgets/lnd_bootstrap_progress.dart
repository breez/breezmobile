import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/blocs_provider.dart';
import 'package:breez/services/breezlib/progress_downloader.dart';
import 'package:breez/widgets/static_loader.dart';
import 'package:flutter/material.dart';

class LNDBootstrapProgress extends StatelessWidget {
  
  LNDBootstrapProgress();

  @override
  Widget build(BuildContext context) {
    AccountBloc accBloc = AppBlocsProvider.of<AccountBloc>(context);
    return StreamBuilder<Map<String, DownloadFileInfo>>(
        stream: accBloc.chainBootstrapProgress,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildDownloadProgress(snapshot.data);
          }

          return StaticLoader();
        });
  }

  Widget _buildDownloadProgress(
      Map<String, DownloadFileInfo> aggregatedDownloadsInfo) {
    return new Column(
        children: <Widget>[
      Padding(
          padding: aggregatedDownloadsInfo.isEmpty
              ? new EdgeInsets.all(0.0) : new EdgeInsets.all(20.0),
          child: aggregatedDownloadsInfo.isEmpty
              ? null
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[Text("Bootstrap status:")],
                ))
    ].toList().followedBy(aggregatedDownloadsInfo.keys.map<Widget>((url) {
      return _buildProgressStatusLine(aggregatedDownloadsInfo[url]);
    })).toList());
  }

  _buildProgressStatusLine(downloadInfo) {
    return Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new SizedBox(width: 200.0, child: Text('${downloadInfo.fileName}')),
            Expanded(
                child: LinearProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                    value: downloadInfo.bytesDownloaded /
                        downloadInfo.contentLength))
          ],
        ));
  }
}
