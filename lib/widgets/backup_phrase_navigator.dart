import 'package:bip39/bip39.dart' as bip39;
import 'package:breez/routes/shared/security_pin/backup_phrase/backup_phrase_confirmation_page.dart';
import 'package:breez/routes/shared/security_pin/backup_phrase/generate_backup_phrase_page.dart';
import 'package:breez/routes/shared/security_pin/backup_phrase/verify_backup_phrase_page.dart';
import 'package:breez/widgets/route.dart';
import 'package:flutter/material.dart';

class BackupPhraseNavigator extends StatelessWidget {
  final BuildContext securityContext;

  BackupPhraseNavigator(this.securityContext);

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
      initialRoute: BackupPhraseNavigatorRoutes.confirmation,
      onGenerateRoute: (routeSettings) {
        return FadeInRoute(builder: (context) => routeBuilders[routeSettings.name](context));
      },
    );
  }

  bool pop(BuildContext context, [bool result]) {
    return Navigator.of(context).pop(result);
  }

  Future pushNamed(BuildContext context, String routeName) async {
    return Navigator.of(context).pushNamed(routeName);
  }

  Future pushReplacementNamed(BuildContext context, String routeName) async {
    return Navigator.of(context).pushReplacementNamed(routeName);
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    String mnemonics = bip39.generateMnemonic(strength: 256);
    return {
      BackupPhraseNavigatorRoutes.confirmation: (context) => BackupPhraseGeneratorConfirmationPage(this.securityContext),
      BackupPhraseNavigatorRoutes.generate: (context) => GenerateBackupPhrasePage(mnemonics, this.securityContext),
      BackupPhraseNavigatorRoutes.verify: (context) => VerifyBackupPhrasePage(mnemonics, this.securityContext),
    };
  }
}

class BackupPhraseNavigatorRoutes {
  static const String confirmation = '/';
  static const String generate = '/generate';
  static const String verify = '/verify';
}
