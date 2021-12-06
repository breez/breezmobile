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
    "connectAccount": EmptyArgsBindingExecutor(f: BindingsConnectAccount),
    
    "decodePaymentRequest": SingleArgBindingExecutor(f: BindingsDecodePaymentRequest),
    "getPaymentRequestHash": SingleArgBindingExecutor(f: BindingsGetPaymentRequestHash),
    "getAccountInfo": EmptyArgsBindingExecutor(f: BindingsGetAccountInfo),
    "lspList": EmptyArgsBindingExecutor(f: BindingsLSPList),
    "connectToLSP": SingleArgBindingExecutor(f: BindingsConnectToLSP),
    "connectToLSPPeer": SingleArgBindingExecutor(f: BindingsConnectToLSPPeer),
    "connectToLnurl": SingleArgBindingExecutor(f: BindingsConnectToLnurl),
    "enableAccount": SingleArgBindingExecutor(f: BindingsEnableAccount),
    "downloadBackup": SingleArgBindingExecutor(f: BindingsDownloadBackup),
    
    "getFundStatus": SingleArgBindingExecutor(f: BindingsGetFundStatus),
    "getPayments": EmptyArgsBindingExecutor(f: BindingsGetPayments),    
    
    "getRelatedInvoice": SingleArgBindingExecutor(f: BindingsGetRelatedInvoice),
    "getLogger": SingleArgBindingExecutor(f: BindingsGetLogger),
    "setPeers": SingleArgBindingExecutor(f: BindingsSetPeers),
    "getPeers": EmptyArgsBindingExecutor(f: BindingsGetPeers),
    "testPeer": SingleArgBindingExecutor(f: BindingsTestPeer),
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
    "sendSpontaneousPayment": SingleArgBindingExecutor(f: BindingsSendSpontaneousPayment),
    "sendWalletCoins": SingleArgBindingExecutor(f: BindingsSendWalletCoins),
    "sweepAllCoinsTransactions": SingleArgBindingExecutor(f: BindingsSweepAllCoinsTransactions),
    "publishTransaction": SingleArgBindingExecutor(f: BindingsPublishTransaction),
    "validateAddress": SingleArgBindingExecutor(f: BindingsValidateAddress),
    "removeFund": SingleArgBindingExecutor(f: BindingsRemoveFund),
    "newReverseSwap": SingleArgBindingExecutor(f: BindingsNewReverseSwap),
    "payReverseSwap": SingleArgBindingExecutor(f: BindingsPayReverseSwap),
    "reverseSwapClaimFeeEstimates": SingleArgBindingExecutor(f: BindingsReverseSwapClaimFeeEstimates),
    "fetchReverseSwap": SingleArgBindingExecutor(f: BindingsFetchReverseSwap),
    "setReverseSwapClaimFee": SingleArgBindingExecutor(f: BindingsSetReverseSwapClaimFee),
    "unconfirmedReverseSwapClaimTransaction": EmptyArgsBindingExecutor(f: BindingsUnconfirmedReverseSwapClaimTransaction),
    "receiverNode": EmptyArgsBindingExecutor(f: BindingsReceiverNode),
    "reverseSwapPayments": EmptyArgsBindingExecutor(f: BindingsReverseSwapPayments),
    "maxReverseSwapAmount": MaxReverseSwapAmountExecutor(),
    "reverseSwapInfo": EmptyArgsBindingExecutor(f: BindingsReverseSwapInfo),
    "checkVersion": EmptyArgsBindingExecutor(f: BindingsCheckVersion),
    "daemonReady": VoidBindingExecutor(f: BindingsDaemonReady),
    "getDefaultOnChainFeeRate": DefaultOnChainFeeRateExecutor(),
    "rate": EmptyArgsBindingExecutor(f: BindingsRate),
    "onResume": VoidBindingExecutor(f: BindingsOnResume),
    "requestBackup": VoidBindingExecutor(f: BindingsRequestBackup),    
    "getLogPath": VoidBindingExecutor(f: BindingsGetLogPath),
    "withdrawLnurl": SingleArgBindingExecutor(f: BindingsWithdrawLnurl),
    "connectDirectToLnurl": SingleArgBindingExecutor(f: BindingsConnectDirectToLnurl),
    "fetchLnurl": SingleArgBindingExecutor(f: BindingsFetchLnurl),
    "finishLNURLAuth": SingleArgBindingExecutor(f: BindingsFinishLNURLAuth),
    "finishLNURLPay": SingleArgBindingExecutor(f: BindingsFinishLNURLPay),
    "syncGraphFromFile": SingleArgBindingExecutor(f: BindingsSyncGraphFromFile),
    "deleteGraph": EmptyArgsBindingExecutor(f: BindingsDeleteGraph),
    "graphURL": EmptyArgsBindingExecutor(f: BindingsGraphURL),
    "resetUnconfirmedReverseSwapClaimTransaction": EmptyArgsBindingExecutor(f: BindingsResetUnconfirmedReverseSwapClaimTransaction),
    "populateChannelPolicy": VoidBindingExecutor(f: BindingsPopulateChannelPolicy),
    "syncLSPChannels": SingleArgBindingExecutor(f: BindingsSyncLSPChannels),
    "checkLSPClosedChannelMismatch": SingleArgBindingExecutor(f: BindingsCheckLSPClosedChannelMismatch),
    "unconfirmedChannelsStatus": SingleArgBindingExecutor(f: BindingsUnconfirmedChannelsStatus),
    "resetClosedChannelChainInfo": SingleArgBindingExecutor(f: BindingsResetClosedChannelChainInfo),
    "setNonBlockingUnconfirmedSwaps": EmptyArgsBindingExecutor(f: BindingsSetNonBlockingUnconfirmedSwaps),
    
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

fileprivate class DefaultOnChainFeeRateExecutor : BindingExecutor {
    func execute(call : FlutterMethodCall, result : @escaping FlutterResult){
        DispatchQueue.global().async {
            var arg : Int64 = 0;
            var error : NSError?;
            BindingsGetDefaultOnChainFeeRate(&arg, &error);
            if let err = error {
                result(self.wrapOutputType(arg: err));
            } else {
                result(self.wrapOutputType(arg: arg))
            }
        }
    }
}

fileprivate class MaxReverseSwapAmountExecutor : BindingExecutor {
    func execute(call : FlutterMethodCall, result : @escaping FlutterResult){
        DispatchQueue.global().async {
            var arg : Int64 = 0;
            var error : NSError?;
            BindingsMaxReverseSwapAmount(&arg, &error);
            if let err = error {
                result(self.wrapOutputType(arg: err));
            } else {
                result(self.wrapOutputType(arg: arg))
            }
        }
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
