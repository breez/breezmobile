import 'package:breez/bloc/account/account_bloc.dart';
import 'package:breez/bloc/connect_pay/connect_pay_bloc.dart';
import 'invoice/invoice_bloc.dart';
import 'package:breez/bloc/pos_profile/pos_profile_bloc.dart';
import 'package:breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:breez/bloc/status_indicator/status_indicator_bloc.dart';

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

  factory AppBlocs() {
    StatusIndicatorBloc statusIndicatorBloc = new StatusIndicatorBloc();
    UserProfileBloc userProfileBloc = new UserProfileBloc();
    AccountBloc accountBloc = new AccountBloc(userProfileBloc.userStream);
    POSProfileBloc posProfileBloc = new POSProfileBloc();    
    InvoiceBloc invoicesBloc = new InvoiceBloc();
    ConnectPayBloc connectPayBloc = new ConnectPayBloc(userProfileBloc.userStream, accountBloc.accountStream);
    
    return AppBlocs._(      
      userProfileBloc,
      accountBloc,      
      posProfileBloc,       
      invoicesBloc,
      connectPayBloc,
      statusIndicatorBloc
    );
  }

  AppBlocs._(    
    this.userProfileBloc, 
    this.accountBloc,     
    this.posProfileBloc,         
    this.invoicesBloc,
    this.connectPayBloc,
    this.statusIndicatorBloc
  );
}