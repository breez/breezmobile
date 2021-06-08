import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/fastbitcoins/fastbitcoins_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/marketplace/marketplace_bloc.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/bloc/sats_rooms/bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';

import 'invoice/invoice_bloc.dart';
import 'lsp/lsp_bloc.dart';

/*
Bloc stands for Business Logic Component.
*/
class AppBlocs {
  final UserProfileBloc userProfileBloc;
  final AccountBloc accountBloc;
  final InvoiceBloc invoicesBloc;
  final ConnectPayBloc connectPayBloc;
  final BackupBloc backupBloc;
  final MarketplaceBloc marketplaceBloc;
  final FastbitcoinsBloc fastbitcoinsBloc;
  final LSPBloc lspBloc;
  final LNUrlBloc lnurlBloc;
  final PosCatalogBloc posCatalogBloc;
  final ReverseSwapBloc reverseSwapBloc;
  final SatsRoomsBloc satsRoomsBloc;
  final Map<Type, Object> _blocsByType;

  static T _registerBloc<T>(T bloc, Map<Type, Object> blocs) {
    blocs[bloc.runtimeType] = bloc;
    return bloc;
  }

  T getBloc<T>() {
    return _blocsByType[T];
  }

  factory AppBlocs() {
    var blocsByType = Map<Type, Object>();
    UserProfileBloc userProfileBloc =
        _registerBloc(UserProfileBloc(), blocsByType);
    AccountBloc accountBloc =
        _registerBloc(AccountBloc(userProfileBloc.userStream), blocsByType);
    InvoiceBloc invoicesBloc = _registerBloc(InvoiceBloc(), blocsByType);
    ConnectPayBloc connectPayBloc = _registerBloc(
        ConnectPayBloc(userProfileBloc.userStream, accountBloc.accountStream,
            accountBloc.userActionsSink),
        blocsByType);
    BackupBloc backupBloc =
        _registerBloc(BackupBloc(userProfileBloc.userStream), blocsByType);
    MarketplaceBloc marketplaceBloc =
        _registerBloc(MarketplaceBloc(), blocsByType);
    LSPBloc lspBloc =
        _registerBloc(LSPBloc(accountBloc.accountStream), blocsByType);
    LNUrlBloc lnurlBloc = _registerBloc(LNUrlBloc(), blocsByType);
    ReverseSwapBloc reverseSwapBloc = _registerBloc(
        ReverseSwapBloc(accountBloc.paymentsStream, userProfileBloc.userStream),
        blocsByType);
    PosCatalogBloc posCatalogBloc =
        _registerBloc(PosCatalogBloc(accountBloc.accountStream), blocsByType);
    FastbitcoinsBloc fastbitcoinsBloc =
        _registerBloc(FastbitcoinsBloc(production: true), blocsByType);
    SatsRoomsBloc satsRoomsBloc = _registerBloc(SatsRoomsBloc(), blocsByType);

    return AppBlocs._(
        userProfileBloc,
        accountBloc,
        invoicesBloc,
        connectPayBloc,
        backupBloc,
        marketplaceBloc,
        fastbitcoinsBloc,
        lspBloc,
        reverseSwapBloc,
        lnurlBloc,
        posCatalogBloc,
        satsRoomsBloc,
        blocsByType);
  }

  AppBlocs._(
    this.userProfileBloc,
    this.accountBloc,
    this.invoicesBloc,
    this.connectPayBloc,
    this.backupBloc,
    this.marketplaceBloc,
    this.fastbitcoinsBloc,
    this.lspBloc,
    this.reverseSwapBloc,
    this.lnurlBloc,
    this.posCatalogBloc,
    this.satsRoomsBloc,
    this._blocsByType,
  );
}
