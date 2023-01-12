 
import Foundation
import Flutter

class Tor : NSObject, FlutterPlugin {
    
    enum Status: String, Codable {
        case stopped = "stopped"
        case starting = "starting"
        case started = "started"
    }
    
    enum Errors: Error, LocalizedError {
        case cookieUnreadable
        case noSocksAddr
        case noDnsAddr
        case smartConnectFailed

        var errorDescription: String? {
            switch self {

            case .cookieUnreadable:
                return "Tor cookie unreadable"

            case .noSocksAddr:
                return "No SOCKS port"

            case .noDnsAddr:
                return "No DNS port"

            case .smartConnectFailed:
                return "Smart Connect failed"
            }
        }
    }

    static let shared = Tor()
    
    static let localhost = "127.0.0.1"

    var status = Status.stopped
    
    private var torThread: TorThread?

    private var torController: TorController?

    private var torConf: TorConfiguration?

    private var torRunning: Bool {
        (torThread?.isExecuting ?? false) && (torConf?.isLocked ?? false)
        
    }

    private lazy var controllerQueue = DispatchQueue.global(qos: .userInitiated)

    private var progressObs: Any?
    private var establishedObs: Any?
    
    
    
    /*override private init() {
        super.init()
        self.torController?.resetConnection()
              
    }*/

    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let TOR_CHANNEL  = "com.breez.client/tor"
        
	    let channel = FlutterMethodChannel(name: TOR_CHANNEL, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(shared, channel: channel)

    }
    
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        
        print("Tor.swift: handle")
        guard (call.method == "startTorService") else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        if self.status == .stopped {
            startTor(call: call, result: result)
        }
        
        
        
        
    }
    
    func startTor(call: FlutterMethodCall, result: @escaping FlutterResult) {
        print(status)
        self.status = .starting
        
        if !torRunning && self.status != .stopped {
            self.torConf = getTorConf(result: result)
                    
            self.torThread = TorThread(configuration: torConf)
            
            self.torThread?.start()
        }
        
       
        
        controllerQueue.asyncAfter(deadline: .now() + 1) {
            if self.torController == nil, let url = self.torConf?.controlPortFile {
                self.torController = TorController(controlPortFile: url)
            }
            
            if !(self.torController?.isConnected ?? false) {
                do {
                    try self.torController?.connect()
                } catch let error {
                    self.status = .stopped
                    result(FlutterError(code: "TorError", message: "Breez could not connect to the Tor controller: \(error.localizedDescription)", details: ""))
                    return
                }
            }
            
            
            guard let cookie = self.torConf?.cookie else {
                result(FlutterError(code: "TorError",message: "Cookie error", details: ""))
                self.status = .stopped
                return
            }
                    
            
            
            self.torController?.authenticate(with: cookie) { success, error in
                if let error = error {
                    self.status = .stopped
                    result(FlutterError(code: "TorError", message: "Breez could not connect to the Tor controller: \(Errors.cookieUnreadable)", details: "\(error)"))
                    return
                    
                }
                
                
                self.progressObs = self.torController?.addObserver(forStatusEvents: {
                    [weak self] (type, severity, action, arguments) -> Bool in
                    if type == "STATUS_CLIENT" && action == "BOOTSTRAP" {
                        let progress: Int?
                        if let p = arguments?["PROGRESS"] {
                            progress = Int(p)
                        } else {
                            progress = nil
                        }
                        print("#startTunnel progress=\(progress?.description ?? "(nil)")")
                        
                        if progress ?? 0 >= 100 {
                            self?.torController?.removeObserver(self?.progressObs)
                        }
                        return true
                    }
                    return false
                })
                self.establishedObs = self.torController?.addObserver(forCircuitEstablished: { [weak self]
                    established in
                    guard established else {
                        return
                    }
                    self?.torController?.removeObserver(self?.establishedObs)
                    self?.torController?.removeObserver(self?.progressObs)
                    self?.torController?.getInfoForKeys(["net/listeners/socks", "net/listeners/control"]) { response in
                        guard let socksAddr = response.first, !socksAddr.isEmpty else {
                            print("error")
                            self?.status = .stopped
                            return // insert error here
                        }
                        guard let controlPort = response.last,!controlPort.isEmpty else {
                            self?.status = .stopped
                            return
                        }
                        self?.status = .started
                        print("Control",controlPort,"socks",socksAddr)
                        let config = [
                            "SOCKS"         : "127.0.0.1:\(socksAddr)",
                            "Control"       : "127.0.0.1:\(controlPort)",
                            "HTTP"          : "127.0.0.1:\(socksAddr)",
                        ]
                        result(config)
                    }
                })
            }
        }
    }
    
    func getCircuits(_ completion: @escaping ([TorCircuit]) -> Void) {
        if let torController = torController {
            torController.getCircuits(completion)
        }
        else {
            completion([])
        }
    }
    
    // MARK: Private methods
    
    private func getTorConf(result: @escaping FlutterResult) -> TorConfiguration {
        let conf = TorConfiguration()

        conf.ignoreMissingTorrc = true
        conf.cookieAuthentication = true
        conf.autoControlPort = true
        conf.clientOnly = true
        conf.avoidDiskWrites = true
        
        conf.dataDirectory = FileManager.default.torDir
        conf.clientAuthDirectory = FileManager.default.authDir

        // GeoIP files for circuit node country display.
        conf.geoipFile = Bundle.geoIp?.geoipFile
        conf.geoip6File = Bundle.geoIp?.geoip6File


        conf.options = [
            // DNS
            "DNSPort": "auto",
            "AutomapHostsOnResolve": "1",
            // By default, localhost resp. link-local addresses will be returned by Tor.
            // That seems to not get accepted by iOS. Use private network addresses instead.
            "VirtualAddrNetworkIPv4": "10.192.0.0/10",
            "VirtualAddrNetworkIPv6": "[FC00::]/7",

            // Log
            "LogMessageDomains": "1",
            "SafeLogging": "1",

            // SOCKS5
            "SocksPort": "auto",

            // Miscelaneous
            "MaxMemInQueues": "15MB"]

//            if Logger.ENABLE_LOGGING,
//               let logfile = FileManager.default.torLogFile?.truncate()
//            {
//                conf.options["Log"] = "notice file \(logfile.path)"
//            }

        return conf
    }
    
    
    private func torReconnect(_ callback: ((_ success: Bool) -> Void)? = nil) {
            torController?.resetConnection(callback)
    }
    

    deinit {
        status = .stopped
        torController?.removeObserver(self.establishedObs)
        torController?.removeObserver(self.progressObs)

        torController?.disconnect()
        torController = nil

        torThread?.cancel()
        torThread = nil

        torConf = nil
    }
}
