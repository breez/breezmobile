import 'package:breez/bloc/backup/backup_model.dart';

enum DiscoverResult { SUCCESS, INVALID_URL, INVALID_AUTH, METHOD_NOT_FOUND, BACKUP_NOT_FOUND }

class DiscoveryResult {
  final RemoteServerAuthData authData;
  final DiscoverResult authError;

  const DiscoveryResult(
    this.authData,
    this.authError,
  );
}
