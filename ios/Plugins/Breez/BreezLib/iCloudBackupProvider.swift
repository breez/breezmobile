import Foundation
import CloudKit
import Bindings

class iCloudBackupProvider : NSObject, BindingsNativeBackupProviderProtocol {
    
    func availableSnapshots(_ fnError: NSErrorPointer) -> String {
        let accStatus = getAccountStatus();
        if (accStatus == .noAccount) {
            fnError?.pointee = NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "AuthError"]);
            return "";
        }
        
        var resultRecords = [CKRecord]()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let pred = NSPredicate(value: true);
        let query = CKQuery(recordType: "BackupSnapshot", predicate: pred)
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 100;
        operation.recordFetchedBlock = { record in
            resultRecords.append(record);
            print("recordFetchedBlock")
        }
        
        operation.queryCompletionBlock = { cursor, err in
            print("queryCompletionBlock")
            semaphore.signal()
        }
        
        CKContainer.default().privateCloudDatabase.add(operation)
        semaphore.wait()
        
        var recordsArray : [Dictionary<String,Any?>] = [];
        for r in resultRecords {
            recordsArray.append([
                "ModifiedTime": r.modificationDate?.description,
                "NodeID": r.recordID.recordName,
                "BackupID": r["backupID"],
                "Encrypted": r["backupEncryptionType"] != nil && r["backupEncryptionType"] != "",
                "EncryptionType": r["backupEncryptionType"],
                ]);
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: recordsArray, options: .prettyPrinted);
            return String(data: jsonData, encoding: String.Encoding.utf8)!;
        }  catch {
            fnError?.pointee = NSError(domain: error.localizedDescription, code: 0, userInfo: nil);
            return "";
        }
    }
    
    func downloadBackupFiles(_ nodeID: String?, backupID: String?, error: NSErrorPointer) -> String {
        var resultRecord : CKRecord?
        
        let semaphore = DispatchSemaphore(value: 0)
        CKContainer.default().privateCloudDatabase.fetch(withRecordID: CKRecord.ID(recordName: nodeID!), completionHandler: { (record, err) in
            if let wrappedError = err {
                error?.pointee = NSError(domain: wrappedError.localizedDescription, code: 0, userInfo: nil);
            }
            resultRecord = record;
            semaphore.signal()
        });
        semaphore.wait();
        guard let record = resultRecord else { return ""; }
        
        record["backupID"] = backupID!;
        if let err = updateRecord(record: record, savePolicy: .changedKeys) {
            error?.pointee = NSError(domain: err.localizedDescription, code: 0, userInfo: nil);
            return "";
        }
        
        guard let backupAsset = record["backup"] as? CKAsset else {
            return legacyDownloadBackupFiles(record, error: error)
        }
        
        let tempDir = FileManager.default.temporaryDirectory;
        let destBackupFile = tempDir.appendingPathComponent("backup.zip");
        var filesArray = [destBackupFile.path];
        do {
            
            if (FileManager.default.fileExists(atPath: destBackupFile.path)) {
                try FileManager.default.removeItem(at: destBackupFile);
            }
            try FileManager.default.copyItem(at: backupAsset.fileURL!, to: destBackupFile)

            if let appDatabackupAsset = record["app_data_backup"] as? CKAsset {
            let destAppDataBackupFile = tempDir.appendingPathComponent("app_data_backup.zip")
                try FileManager.default.copyItem(at: appDatabackupAsset.fileURL!, to: destAppDataBackupFile)
                filesArray.append(destAppDataBackupFile.path);
            }
        } catch let errorEx {
            error?.pointee = NSError(domain: errorEx.localizedDescription, code: 0, userInfo: nil);
            return ""
        }

        return filesArray.joined(separator: ",");
    }
    
    func legacyDownloadBackupFiles(_ record: CKRecord, error: NSErrorPointer) -> String {
        if let err = updateRecord(record: record, savePolicy: .changedKeys) {
            error?.pointee = NSError(domain: err.localizedDescription, code: 0, userInfo: nil);
            return "";
        }
        
        guard let walletdbAsset = record["walletdb"] as? CKAsset else {
            error?.pointee = NSError(domain: "walletdb was not found", code: 0, userInfo: nil);
            return ""
        }
        
        guard let channeldbAsset = record["channeldb"] as? CKAsset else {
            error?.pointee = NSError(domain: "channeldb was not found", code: 0, userInfo: nil);
            return ""
        }
        
        guard let breezdbAsset = record["breezdb"] as? CKAsset else {
            error?.pointee = NSError(domain: "breezdb was not found", code: 0, userInfo: nil);
            return ""
        }
        
        let tempDir = FileManager.default.temporaryDirectory;
        let destWalletdb = tempDir.appendingPathComponent("wallet.db");
        let destChanneldb = tempDir.appendingPathComponent("channel.db");
        let destBreezdb = tempDir.appendingPathComponent("breez.db");
        do {
            
            if (FileManager.default.fileExists(atPath: destWalletdb.path)) {
                try FileManager.default.removeItem(at: destWalletdb);
            }
            try FileManager.default.copyItem(at: walletdbAsset.fileURL!, to: destWalletdb)
            
            if (FileManager.default.fileExists(atPath: destChanneldb.path)) {
                try FileManager.default.removeItem(at: destChanneldb);
            }
            try FileManager.default.copyItem(at: channeldbAsset.fileURL!, to: destChanneldb)
            
            if (FileManager.default.fileExists(atPath: destBreezdb.path)) {
                try FileManager.default.removeItem(at: destBreezdb);
            }
            try FileManager.default.copyItem(at: breezdbAsset.fileURL!, to: destBreezdb)
        } catch let errorEx {
            error?.pointee = NSError(domain: errorEx.localizedDescription, code: 0, userInfo: nil);
            return ""
        }
        let filesArray = [destWalletdb.path,
                destChanneldb.path,
                destBreezdb.path];
        return filesArray.joined(separator: ",");
    }
    
    func uploadBackupFiles(_ file: String?, nodeID: String?, encryptionType: String?, error: NSErrorPointer) -> String {
        let accStatus = getAccountStatus();
        if (accStatus == .noAccount) {
            error?.pointee = NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "AuthError"]);
            return "";
        }
        
        let record = CKRecord(recordType: "BackupSnapshot", recordID: CKRecord.ID(recordName: nodeID!));
        record["backupEncryptionType"] = encryptionType;
        if (URL(fileURLWithPath: String(file!)).lastPathComponent == "app_data_backup.zip") {
            record["app_data_backup"] = CKAsset(fileURL: URL(fileURLWithPath: String(file!)));
        } else {
            record["backup"] = CKAsset(fileURL: URL(fileURLWithPath: String(file!)));
        }
        
        if let err = updateRecord(record: record, savePolicy: .allKeys) {
            error?.pointee = NSError(domain: err.localizedDescription, code: 0, userInfo: nil);
            return "";
        }
        
        return "";
    }
    
    func updateRecord(record : CKRecord, savePolicy: CKModifyRecordsOperation.RecordSavePolicy) -> Error? {
        var resultErr : Error?
        let semaphore = DispatchSemaphore(value: 0)
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil);
        modifyOperation.savePolicy = savePolicy
        modifyOperation.qualityOfService = .userInitiated;
        modifyOperation.isAtomic = true;
        modifyOperation.modifyRecordsCompletionBlock = { records, ids, err in
            resultErr = err;
            semaphore.signal()
        }
        CKContainer.default().privateCloudDatabase.add(modifyOperation);
        semaphore.wait();
        return resultErr;
    }
    
    func getAccountStatus() -> CKAccountStatus {
        let semaphore = DispatchSemaphore(value: 0)
        var accStatus : CKAccountStatus = .couldNotDetermine
        CKContainer.default().accountStatus(completionHandler: {status, err in
            accStatus = status;
            semaphore.signal();
        });
        semaphore.wait();
        return accStatus;
    }
    
    func fetchUserName() -> String? {
        let semaphore = DispatchSemaphore(value: 0)
        var userName : String?
        CKContainer.default().fetchUserRecordID(completionHandler: {rec, err in
            userName = rec?.recordName
            semaphore.signal();
        });
        semaphore.wait();
        return userName;
    }
}

class iCloudAuthenticator : BackupAuthenticatorProtocol {
    func backupProviderSignIn(silent: Bool, in err: NSErrorPointer) -> String {
         return "";
    }
    
    func signOut(){}
}
