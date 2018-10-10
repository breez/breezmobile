import 'package:breez/bloc/pos_profile/pos_profile_bloc.dart';
import 'package:breez/bloc/pos_profile/pos_profile_model.dart';
import 'package:breez/services/injector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'bloc_tester.dart';
import 'mocks.dart';

void main() {
  group('breez_user_model_tests', () {
    InjectorMock _injector = new InjectorMock();   
    POSProfileBloc _posProfileBloc;

    setUp(() async {
      ServiceInjector.configure(_injector);
      _posProfileBloc = new POSProfileBloc();
    });

    test("should return empty POS when not registered", () async {
      new BlocTester<void, POSProfileModel>(_posProfileBloc.posProfileStream, (pos) => expect(pos.invoiceString, null));        
    });

    test("should return registered POS with correct invoice string", () async{
      _posProfileBloc.posProfileSink.add(POSProfileModel("testInvoiceString", null));
      var invoiceString = await _posProfileBloc.posProfileStream.firstWhere((profile) => profile != null && profile.invoiceString != null).then((p) => p.invoiceString);
      expect(invoiceString, "testInvoiceString");      
    });

    test("should return registered POS with correct base64 image", () async{
      _posProfileBloc.posProfileSink.add(POSProfileModel("testInvoiceString", "testInvoiceBase64Logo"));
      var logo = await _posProfileBloc.posProfileStream.firstWhere((profile) => profile != null && profile.logo != null).then((p) => p.logo);
      expect(logo, "testInvoiceBase64Logo");
    });
  });
}