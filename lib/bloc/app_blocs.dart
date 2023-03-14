import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/tor/bloc.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'package:breez/bloc/fastbitcoins/fastbitcoins_bloc.dart';
import 'package:breez/bloc/lnurl/lnurl_bloc.dart';
import 'package:breez/bloc/marketplace/marketplace_bloc.dart';
import 'package:breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:breez/bloc/podcast_clip/podcast_clip_bloc.dart';
import 'package:breez/bloc/podcast_history/podcast_history_bloc.dart';
import 'package:breez/bloc/pos_catalog/bloc.dart';
import 'package:breez/bloc/pos_catalog/sqlite/repository.dart';
import 'package:breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';

import 'invoice/invoice_bloc.dart';
import 'lsp/lsp_bloc.dart';

/*
Bloc stands for Business Logic Component.
*/
class AppBlocs {
  final UserProfileBloc userProfileBloc;
  final AccountBloc accountBloc;
  final TorBloc torBloc;
  final InvoiceBloc invoicesBloc;
  final ConnectPayBloc connectPayBloc;
  final BackupBloc backupBloc;
  final MarketplaceBloc marketplaceBloc;
  final FastbitcoinsBloc fastbitcoinsBloc;
  final LSPBloc lspBloc;
  final LNUrlBloc lnurlBloc;
  final PosCatalogBloc posCatalogBloc;
  final PaymentOptionsBloc paymentOptionsBloc;
  final ReverseSwapBloc reverseSwapBloc;

  final Map<Type, Object> _blocsByType;
  final PodcastHistoryBloc podCastHistoryBloc;
  final PodcastClipBloc podCastClipBloc;

  static T _registerBloc<T>(T bloc, Map<Type, Object> blocs) {
    blocs[bloc.runtimeType] = bloc;
    return bloc;
  }

  T getBloc<T>() {
    return _blocsByType[T];
  }

  factory AppBlocs(Stream<bool> backupAnytimeDBStream) {
    var blocsByType = <Type, Object>{};
    final sqliteRepository = SqliteRepository();
    UserProfileBloc userProfileBloc =
        _registerBloc(UserProfileBloc(), blocsByType);
    BackupBloc backupBloc = _registerBloc(
        BackupBloc(userProfileBloc.userStream, backupAnytimeDBStream),
        blocsByType);
    PaymentOptionsBloc paymentOptionsBloc = _registerBloc(
      PaymentOptionsBloc(backupBloc.restoreLightningFeesStream),
      blocsByType,
    );
    AccountBloc accountBloc = _registerBloc(
        AccountBloc(
          userProfileBloc.userStream,
          sqliteRepository,
          paymentOptionsBloc,
        ),
        blocsByType);
    TorBloc torBloc = _registerBloc(accountBloc.torBloc, blocsByType);
    InvoiceBloc invoicesBloc = _registerBloc(InvoiceBloc(), blocsByType);
    ConnectPayBloc connectPayBloc = _registerBloc(
        ConnectPayBloc(userProfileBloc.userStream, accountBloc.accountStream,
            accountBloc.userActionsSink),
        blocsByType);
    MarketplaceBloc marketplaceBloc =
        _registerBloc(MarketplaceBloc(), blocsByType);
    LSPBloc lspBloc =
        _registerBloc(LSPBloc(accountBloc.accountStream), blocsByType);
    LNUrlBloc lnurlBloc = _registerBloc(LNUrlBloc(), blocsByType);
    ReverseSwapBloc reverseSwapBloc = _registerBloc(
        ReverseSwapBloc(
          accountBloc.paymentsStream,
          userProfileBloc.userStream,
          paymentOptionsBloc,
        ),
        blocsByType);
    PosCatalogBloc posCatalogBloc = _registerBloc(
        PosCatalogBloc(
          accountBloc.accountStream,
          userProfileBloc.userStream,
          backupBloc.backupAppDataSink,
          sqliteRepository,
        ),
        blocsByType);
    FastbitcoinsBloc fastbitcoinsBloc =
        _registerBloc(FastbitcoinsBloc(), blocsByType);
    PodcastHistoryBloc podCastHistoryBloc = _registerBloc(
      PodcastHistoryBloc(),
      blocsByType,
    );
    PodcastClipBloc podCastClipBloc = _registerBloc(
      PodcastClipBloc(),
      blocsByType,
    );

    return AppBlocs._(
        userProfileBloc,
        accountBloc,
        torBloc,
        invoicesBloc,
        connectPayBloc,
        backupBloc,
        marketplaceBloc,
        fastbitcoinsBloc,
        lspBloc,
        reverseSwapBloc,
        lnurlBloc,
        posCatalogBloc,
        paymentOptionsBloc,
        blocsByType,
        podCastHistoryBloc,
        podCastClipBloc);
  }

  AppBlocs._(
      this.userProfileBloc,
      this.accountBloc,
      this.torBloc,
      this.invoicesBloc,
      this.connectPayBloc,
      this.backupBloc,
      this.marketplaceBloc,
      this.fastbitcoinsBloc,
      this.lspBloc,
      this.reverseSwapBloc,
      this.lnurlBloc,
      this.posCatalogBloc,
      this.paymentOptionsBloc,
      this._blocsByType,
      this.podCastHistoryBloc,
      this.podCastClipBloc);
}
