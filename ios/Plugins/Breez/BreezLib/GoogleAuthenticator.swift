//
//  GoogleAuthenticator.swift
//  Runner
//
//  Created by Roei Erez on 4/11/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import GoogleSignIn
import Bindings;

class GoogleAuthenticator : NSObject, BackupAuthenticatorProtocol {
    private var queue : DispatchQueue = DispatchQueue(label: "com.breez.client.gdrive.oauth")
    private var inProgressOperation : SignInOperation?
    
    
    func startSignInOperation(silentOnly: Bool) -> SignInOperation {
        return queue.sync{
            if (inProgressOperation == nil) {
                inProgressOperation = SignInOperation(silentOnly: silentOnly);
                DispatchQueue.main.async{
                    self.inProgressOperation!.start();
                }
            }
            
            return inProgressOperation!;
        };
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut();
    }
    
    func getAccessToken(silentOnly: Bool) throws -> String{
        let signInOperation = startSignInOperation(silentOnly: silentOnly);
        signInOperation.waitUntilFinished();
        queue.sync{
            inProgressOperation = nil;
        }
        
        if (signInOperation.error != nil) {
            throw signInOperation.error!;
        }
        return signInOperation.accessToken!;
    }
    
    func backupProviderSignIn(silent: Bool, in err: NSErrorPointer) -> String {
        do {
            return try self.getAccessToken(silentOnly: silent);
        }
        catch {
            err?.pointee = NSError(domain: "AuthError " + error.localizedDescription, code: 0, userInfo: nil);
        }
        return "";
    }
    
}

class SignInOperation : Operation {
    
    private enum State {
        case ready
        case executing
        case finished
    }
    
    private var silentOnly = false;
    private var state = State.ready;
    private var silentSignInFailed = false;
    var accessToken : String?;
    var error : Error?;
    private var configuration: GIDConfiguration = GIDConfiguration(clientID: "")
    
    private var appDataScope = "https://www.googleapis.com/auth/drive.appdata";
    private var authScopes: [String] {
        [
            appDataScope,
        ]
    }
    
    init(silentOnly: Bool){
        super.init();
        self.silentOnly = silentOnly;
    }
    
    override var isAsynchronous: Bool {
        return true;
    }
    
    override var isReady : Bool {
        return state == .ready;
    }
    
    override var isExecuting: Bool {
        return state == .executing;
    }
    
    override var isFinished: Bool {
        return state == .finished;
    }
    
    override func start() {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            self.onFinish(withToken: nil, error: NSError(domain: "ConfigError", code: 0, userInfo: nil));
            return
        }
        guard let plist = NSMutableDictionary(contentsOfFile: path) else {
            self.onFinish(withToken: nil, error: NSError(domain: "ConfigError", code: 0, userInfo: nil));
            return
        }
        guard let presenting = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        let CLIENT_ID = plist["CLIENT_ID"] as! String;
        self.configuration = GIDConfiguration(clientID: CLIENT_ID)
        GIDSignIn.sharedInstance.addScopes(authScopes, presenting: presenting);
        state = .executing;
        
        if(GIDSignIn.sharedInstance.hasPreviousSignIn()){
            GIDSignIn.sharedInstance.restorePreviousSignIn { currentUser, error in
                if error == nil {
                    print("Managed to restore previous sign in!\nScopes: \(String(describing: currentUser?.grantedScopes))")
                    if !self.silentOnly {
                        self.handleSignIn(presenting: presenting);
                    } else {
                        self.requestScopes(user: currentUser!, presenting: presenting) { success in
                            if success == true {
                                self.onFinish(withToken: currentUser?.authentication.accessToken, error: error)
                            } else {
                                self.onFinish(withToken: nil, error: NSError(domain: "InsufficientScope", code: 0, userInfo: nil))
                            }
                        }
                    }
                } else {
                    print("No previous user!\nThis is the error: \(String(describing: error?.localizedDescription))")
                    self.handleSignIn(presenting: presenting)
                }
            }
        } else {
            self.handleSignIn(presenting: presenting)
        }
    }
    
    private func handleSignIn(presenting: UIViewController) {
        GIDSignIn.sharedInstance.signIn(with: self.configuration, presenting: presenting) { gUser, signInError in
            if signInError == nil {
                self.requestScopes(user: gUser!,presenting: presenting) { signInSuccess in
                    if signInSuccess == true {
                        self.onFinish(withToken: gUser?.authentication.accessToken, error: signInError)
                    } else {
                        self.onFinish(withToken: nil, error: NSError(domain: "InsufficientScope", code: 0, userInfo: nil))
                    }
                }
            } else {
                print("error with signing in: \(String(describing: signInError)) ")
                self.onFinish(withToken: nil, error: NSError(domain: "AuthError", code: 0, userInfo: nil))
            }
        }
    }
    
    private func requestScopes(user: GIDGoogleUser, presenting: UIViewController, completionHandler: @escaping (Bool) -> Void) {
        let grantedScopes = user.grantedScopes
        if grantedScopes == nil || !grantedScopes!.contains(appDataScope) {
            // Request additional Drive scope.
            GIDSignIn.sharedInstance.addScopes(authScopes, presenting: presenting) { user, scopeError in
                if scopeError == nil {
                    user?.authentication.do { authentication, err in
                        if err == nil {
                            completionHandler(true)
                        } else {
                            print("Error with auth: \(String(describing: err?.localizedDescription))")
                            completionHandler(false)
                        }
                    }
                    completionHandler(true);
                } else {
                    print("Error with adding scopes: \(String(describing: scopeError?.localizedDescription))")
                    completionHandler(false)
                }
            }
        } else {
            print("Already contains the scopes!")
            completionHandler(true)
        }
    }
    
    func onFinish(withToken : String?, error: Error?){
        self.error = error;
        self.accessToken = withToken;
        self.willChangeValue(forKey: "isFinished");
        self.state = .finished;
        self.didChangeValue(forKey: "isFinished");
    }
}
