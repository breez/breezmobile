// Ref. https://github.com/iCepa/iCepa/blob/main/Shared/TorManager.swift 

import Foundation
import Flutter


class Tor : NSObject, FlutterPlugin {

    static let localhost = "127.0.0.1"
    
    static let torProxyPort: UInt16     = 39050
    static let controlPort: UInt16      = 39060
    static let dnsPort:UInt16           = 39053
    //static let HTTPTunnelPort:UInt16     = 38888
    
    private var torThread: TorThread?
    private var torController: TorController?
    private var torConf: TorConfiguration?
    
    
    private var torRunning: Bool {
        guard torThread?.isExecuting ?? false else {
            return false
        }
        if let lock = torConf?.dataDirectory?.appendingPathComponent("lock") {
            return FileManager.default.fileExists(atPath: lock.path)
        }
        return false
    }
    
    private var cookie: Data? {
        if let cookieUrl = torConf?.dataDirectory?.appendingPathComponent("control_auth_cookie") {
            return try? Data(contentsOf: cookieUrl)
            
        }
        return nil
        
    }
    


    public static func register(with registrar: FlutterPluginRegistrar) {

	let TOR_CHANNEL  = "com.breez.client/tor"
	    let instance = Tor()
	    let channel = FlutterMethodChannel(name: TOR_CHANNEL, binaryMessenger: registrar.messenger())
	    registrar.addMethodCallDelegate(instance, channel: channel)

    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

	print("Tor.swift: handle")

	    guard (call.method == "startTorService") else {
		result(FlutterMethodNotImplemented)
		return
	    }

	startTor(call: call, result: result)
    }


    func startTor(call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        
        guard !(torThread?.isExecuting ?? false) else { return };
        torConf = getTorConf(result: result)
        
        torThread = TorThread(configuration: torConf)
        
        torThread?.start()
        
        
        print("Tor.swift: startTor: starting tor thread.")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

            if self.torController == nil {
                self.torController = TorController(
                    socketHost: Tor.localhost,
                    port: Tor.controlPort
                )
            }
            
            if !(self.torController?.isConnected ?? false) {
                do {
                    // FIXME(nochiel) This fails on iOS with a "Foundation._GenericObjCError error 0".
                    // I'm not sure why but if we needed the controller it would have to
                    // be fixed here.
                    try self.torController?.connect()
                } catch let error {
                    result(FlutterError(code: "TorError", message: "Breez could not connect to the Tor controller: \(error.localizedDescription)", details: ""))
                }
            }

            
            guard let cookie = self.cookie else {
                result(FlutterError(code: "TorError",message: "Cookie error", details: ""))
                return
            }
                    
            
            
            self.torController?.authenticate(with: cookie, completion: { success, error in
                if let error = error {
                    result(FlutterError(code: "TorError", message: error.localizedDescription, details: ""))
                    return
                }
                
                var progressObs: Any?
                progressObs = self.torController?.addObserver(forStatusEvents: {
                    (type, severity, action, arguments) -> Bool in

                    if type == "STATUS_CLIENT" && action == "BOOTSTRAP" {
                        let progress = Int(arguments!["PROGRESS"]!)!
                        print("#startTunnel progress=\(progress)")

                        if progress >= 100 {
                            self.torController?.removeObserver(progressObs)
                        }

                        return true
                    }

                    return false
                })

                var observer: Any?
                observer = self.torController?.addObserver(forCircuitEstablished: { established in
                    guard established else {
                        return
                    }

                    self.torController?.removeObserver(observer)
                })

                    
            })
             
            let connected:Bool = ((self.torController?.isConnected) != nil)
            print("tor controller is connected?",connected)
           
            
            let config = [
                "SOCKS"	    : "\(Tor.localhost):\(Tor.torProxyPort)",
                "Control"   : "\(Tor.localhost):\(Tor.controlPort)",
                "HTTP"	    : "\(Tor.localhost):\(Tor.dnsPort)",
            ]
            result(config)
            return

        }
    }
    
    
    // Private methods
    
   
    
    private func getTorConf(result: @escaping FlutterResult) -> TorConfiguration {
        
        
        let conf = TorConfiguration()
        
        
        
        conf.options = [
            "AutomapHostsOnResolve": "1",
            "AvoidDiskWrites": "1",
            "ClientOnly": "1",
            
            
            /*"VirtualAddrNetworkIPv4": "10.192.0.0/10",
            "VirtualAddrNetworkIPv6": "[FC00::]/7",*/
            
            // Log
            "Log": "[~circ,~guard]info stdout",
            "LogMessageDomains": "1",
            "SafeLogging": "0",
            // FIXME(nochiel) Robustness: If we set these to auto, Tor will ensure it finds an open port.
            // We can then retrieve these open ports using TorController and pass them back to TorBloc as a result.
            // "SocksPort": "auto",
            // "ControlPort" : "auto",
            //"HTTPTunnelPort" : "\(Tor.localhost):\(Tor.HTTPTunnelPort)",
            // "DNSPort": "auto",
            
            "DNSPort": "\(Tor.localhost):\(Tor.dnsPort)",
            "SocksPort": "\(Tor.localhost):\(Tor.torProxyPort)",
            "ControlPort" : "\(Tor.localhost):\(Tor.controlPort)",
        ]
        
        if let dataDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("tor", isDirectory: true) {
            try? FileManager.default.removeItem(at: dataDirectory)
            try? FileManager.default.createDirectory(at: dataDirectory, withIntermediateDirectories: true)
            guard FileManager.default.fileExists(atPath: dataDirectory.path) else {
                result(FlutterError(code: "FAIL",
                                    message: "Breez could not create the Tor directory",
                                    details: nil))
                return conf
            }
            conf.dataDirectory = dataDirectory
            conf.controlSocket = dataDirectory.appendingPathComponent("control_port")
        }
        
        conf.cookieAuthentication =  true
        
        
        
        conf.arguments += [
            "--allow-missing-torrc",
            "--ignore-missing-torrc",
        ]
        
        
        print("Tor.swift: returning config.",conf)
        return conf
    }
    
    
    private func torReconnect(_ callback: ((_ success: Bool) -> Void)? = nil) {
            torController?.resetConnection(callback)
    }
    

    deinit {
        torController?.disconnect()
        torController = nil
        torThread?.cancel()
        torThread = nil
    }

}
