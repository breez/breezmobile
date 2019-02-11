import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'invoice/invoice_bloc.dart';
import 'package:breez/bloc/pos_profile/pos_profile_bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/bloc/status_indicator/status_indicator_bloc.dart';
import 'package:breez/bloc/backup/backup_bloc.dart';
import 'package:breez/bloc/marketplace/marketplace_bloc.dart';

/*
Bloc stands for Business Logic Component.
*/
class AppBlocs {
  final UserProfileBloc userProfileBloc;
  final AccountBloc accountBloc;  
  final POSProfileBloc posProfileBloc;    
  final InvoiceBloc invoicesBloc;
  final ConnectPayBloc connectPayBloc;
  final StatusIndicatorBloc statusIndicatorBloc;
  final BackupBloc backupBloc;
  final MarketplaceBloc marketplaceBloc;
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
    StatusIndicatorBloc statusIndicatorBloc = _registerBloc(StatusIndicatorBloc(), blocsByType);
    UserProfileBloc userProfileBloc = _registerBloc(UserProfileBloc(), blocsByType);
    AccountBloc accountBloc = _registerBloc(AccountBloc(userProfileBloc.userStream), blocsByType);
    POSProfileBloc posProfileBloc = _registerBloc(POSProfileBloc(), blocsByType);    
    InvoiceBloc invoicesBloc = _registerBloc(InvoiceBloc(), blocsByType);
    ConnectPayBloc connectPayBloc = _registerBloc(ConnectPayBloc(userProfileBloc.userStream, accountBloc.accountStream), blocsByType);
    BackupBloc backupBloc = _registerBloc(BackupBloc(), blocsByType);
    MarketplaceBloc marketplaceBloc = _registerBloc(MarketplaceBloc(), blocsByType);

    return AppBlocs._(      
      userProfileBloc,
      accountBloc,      
      posProfileBloc,       
      invoicesBloc,
      connectPayBloc,
      statusIndicatorBloc,
      backupBloc,
      marketplaceBloc,
      blocsByType
    );
  }  

  AppBlocs._(    
    this.userProfileBloc, 
    this.accountBloc,     
    this.posProfileBloc,         
    this.invoicesBloc,
    this.connectPayBloc,
    this.statusIndicatorBloc,
    this.backupBloc,
    this.marketplaceBloc,
    this._blocsByType,
  );
}
