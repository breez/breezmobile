import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> launchLinkOnExternalBrowser(String linkAddress) async {
  if (await canLaunchUrlString(linkAddress)) {
    await FlutterWebBrowser.openWebPage(
      url: linkAddress,
      customTabsOptions: CustomTabsOptions(
        shareState: CustomTabsShareState.on,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: SafariViewControllerOptions(
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }
}
