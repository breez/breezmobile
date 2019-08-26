//
//  NativeMethods.swift
//  Runner
//
//  Created by Roei Erez on 4/11/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter
import Bindings

public class NativeMethods {
    static func getExecutor(forMethod: String) -> BindingExecutor? {
        return calls[forMethod];
    }
}


fileprivate let calls : Dictionary<String, BindingExecutor> = [
    "start": EmptyArgsBindingExecutor(f: BindingsStart),
    "stop": VoidBindingExecutor(f: BindingsStop),
    "restartDaemon": EmptyArgsBindingExecutor(f: BindingsRestartDaemon),
    
    "lastSyncedHeaderTimestamp": VoidBindingExecutor(f: BindingsLastSyncedHeaderTimestamp),
    "addFundsInit": SingleArgBindingExecutor(f: BindingsAddFundsInit),
    "addInvoice": SingleArgBindingExecutor(f: BindingsAddInvoice),
    "availableSnapshots": EmptyArgsBindingExecutor(f: BindingsAvailableSnapshots),
    "bootstrapFiles": SingleArgBindingExecutor(f: BindingsBootstrapFiles),
    "connectAccount": EmptyArgsBindingExecutor(f: BindingsConnectAccount),
    
    "decodePaymentRequest": SingleArgBindingExecutor(f: BindingsDecodePaymentRequest),
    "enableAccount": SingleArgBindingExecutor(f: BindingsEnableAccount),
    "getAccountInfo": EmptyArgsBindingExecutor(f: BindingsGetAccountInfo),
    
    "getFundStatus": SingleArgBindingExecutor(f: BindingsGetFundStatus),
    "getPayments": EmptyArgsBindingExecutor(f: BindingsGetPayments),    
    
    "getRelatedInvoice": SingleArgBindingExecutor(f: BindingsGetRelatedInvoice),
    "getLogger": SingleArgBindingExecutor(f: BindingsGetLogger),
    "setPeers": SingleArgBindingExecutor(f: BindingsSetPeers),
    "getPeers": EmptyArgsBindingExecutor(f: BindingsGetPeers),
    "createRatchetSession": SingleArgBindingExecutor(f: BindingsCreateRatchetSession),
    "ratchetDecrypt": SingleArgBindingExecutor(f: BindingsRatchetDecrypt),
    "ratchetEncrypt": SingleArgBindingExecutor(f: BindingsRatchetEncrypt),
    "ratchetSessionInfo": SingleArgBindingExecutor(f: BindingsRatchetSessionInfo),
    "ratchetSessionSetInfo": SingleArgBindingExecutor(f: BindingsRatchetSessionSetInfo),
    "refund": SingleArgBindingExecutor(f: BindingsRefund),
    "registerChannelOpenedNotification": SingleArgBindingExecutor(f: BindingsRegisterChannelOpenedNotification),
    "registerPeriodicSync": SingleArgBindingExecutor(f: BindingsRegisterPeriodicSync),
    "registerReceivePaymentReadyNotification": SingleArgBindingExecutor(f: BindingsRegisterReceivePaymentReadyNotification),    
    "sendCommand": SingleArgBindingExecutor(f: BindingsSendCommand),
    "sendPaymentFailureBugReport": SingleArgBindingExecutor(f: BindingsSendPaymentFailureBugReport),
    "sendPaymentForRequest": SingleArgBindingExecutor(f: BindingsSendPaymentForRequest),
    "sendWalletCoins": SingleArgBindingExecutor(f: BindingsSendWalletCoins),
    "validateAddress": SingleArgBindingExecutor(f: BindingsValidateAddress),
    "removeFund": SingleArgBindingExecutor(f: BindingsRemoveFund),
    
    "daemonReady": VoidBindingExecutor(f: BindingsDaemonReady),
    "getDefaultOnChainFeeRate": VoidBindingExecutor(f: BindingsGetDefaultOnChainFeeRate),
    "rate": EmptyArgsBindingExecutor(f: BindingsRate),
    "isConnectedToRoutingNode": VoidBindingExecutor(f: BindingsIsConnectedToRoutingNode),
    "onResume": VoidBindingExecutor(f: BindingsOnResume),
    "requestBackup": VoidBindingExecutor(f: BindingsRequestBackup),
    "setPinCode": SingleArgBindingExecutor(f: BindingsSetPinCode),
    "getLogPath": VoidBindingExecutor(f: BindingsGetLogPath),
    "needsBootstrap": VoidBindingExecutor(f: BindingsNeedsBootstrap),
    "bootstrapHeaders": SingleArgBindingExecutor(f: BindingsBootstrapHeaders)
    
    //jobs
    //    FOUNDATION_EXPORT id<BindingsJobController> BindingsNewClosedChannelsJob(NSString* workingDir, NSError** error);
    //    FOUNDATION_EXPORT id<BindingsJobController> BindingsNewSyncJob(NSString* workingDir, NSError** error);
    
];



protocol BindingExecutor {
    func execute(call : FlutterMethodCall, result : @escaping FlutterResult);
}

fileprivate extension BindingExecutor {    
    
    func unwrapInputType(arg: Any?) -> Any? {
        if let data = arg as? FlutterStandardTypedData {
            return data.data;
        }
        return arg;
    }
    
    func wrapOutputType(arg: Any?) -> Any? {
        if let data = arg as? Data {
            return FlutterStandardTypedData(bytes: data);
        }
        if let err = arg as? NSError {
            return FlutterError(code: "Method Error", message: err.localizedDescription, details: err.description);
        }
        if let _ = arg as? Void {
            return nil;
        }
        return arg;
    }
}

fileprivate class SingleArgBindingExecutor<T,O> : BindingExecutor {
    var bindingFunc : (T, NSErrorPointer) -> O;
    
    init(f: @escaping (T, NSErrorPointer) -> O) {
        self.bindingFunc = f;
    }
    
    func execute(call : FlutterMethodCall, result : @escaping FlutterResult){
        DispatchQueue.global().async {
            let args = call.arguments as! Dictionary<String,Any>
            let arg = self.unwrapInputType(arg: args["argument"]);
            var error : NSError?;
            let res = self.bindingFunc(arg as! T, &error);
            if let err = error {
                result(self.wrapOutputType(arg: err));
            } else {
                result(self.wrapOutputType(arg: res))
            }
        }
    }
}

fileprivate class EmptyArgsBindingExecutor<O> : BindingExecutor {
    var bindingFunc : (NSErrorPointer) -> O;
    
    init(f: @escaping (NSErrorPointer) -> O) {
        self.bindingFunc = f;
    }
    
    func execute(call : FlutterMethodCall, result : @escaping FlutterResult){
         DispatchQueue.global().async {
            var error : NSError?;
            let res = self.bindingFunc(&error);
            if let err = error {
                result(self.wrapOutputType(arg: err));
            } else {
                result(self.wrapOutputType(arg: res))
            }
        }
    }
}

fileprivate class VoidBindingExecutor<O> : BindingExecutor {
    var bindingFunc : () -> O;
    
    init(f: @escaping () -> O) {
        self.bindingFunc = f;
    }
    
    func execute(call : FlutterMethodCall, result : @escaping FlutterResult){
        DispatchQueue.global().async {
            result(self.wrapOutputType(arg: self.bindingFunc()));
        }
    }
}
