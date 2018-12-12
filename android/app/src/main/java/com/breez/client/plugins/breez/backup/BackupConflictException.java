package com.breez.client.plugins.breez.backup;

public class BackupConflictException extends  Exception {
    public BackupConflictException() {
        super("Backup conflict detected");
    }
}
