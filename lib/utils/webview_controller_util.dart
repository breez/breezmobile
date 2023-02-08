import 'package:webview_flutter/webview_flutter.dart';

WebViewController setWebViewController({
  String url,
  Function(String url) onPageFinished,
  Function(JavaScriptMessage msg) onMessageReceived,
  Function(NavigationRequest request) onNavigationRequest,
}) {
  return WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: onNavigationRequest ??
            (NavigationRequest request) => request.url.startsWith('lightning:')
                ? NavigationDecision.prevent
                : NavigationDecision.navigate,
        onPageFinished: onPageFinished,
      ),
    )
    ..addJavaScriptChannel(
      "BreezWebView",
      onMessageReceived: onMessageReceived,
    )
    ..loadRequest(Uri.parse(url));
}
