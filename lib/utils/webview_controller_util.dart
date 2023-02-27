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
        onNavigationRequest: (NavigationRequest request) =>
            onNavigationRequest(request) ??
            (NavigationRequest request) => request.url.startsWith('lightning:')
                ? NavigationDecision.prevent
                : NavigationDecision.navigate,
        onPageFinished: (String url) => onPageFinished(url),
      ),
    )
    ..addJavaScriptChannel(
      "BreezWebView",
      onMessageReceived: (JavaScriptMessage message) =>
          onMessageReceived(message),
    )
    ..loadRequest(Uri.parse(url));
}
