package com.breez.client;

import android.content.Context;
import android.util.Log;

import com.breez.client.plugins.breez.breezlib.Breez;

import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.LogRecord;


public class BreezLogger {
    private static boolean sInit;

    public static synchronized  java.util.logging.Logger getLogger(Context ctx, String name){
        if (!sInit) {
            addBreezLogHandler(ctx);
            sInit = true;
        }

        return java.util.logging.Logger.getLogger(name);
    }

    private static void addBreezLogHandler(Context ctx){
        java.util.logging.Logger rootLogger = java.util.logging.Logger.getLogger("");
        try {
            bindings.Logger logger = Breez.getLogger(ctx);
            rootLogger.addHandler(new Handler() {
                @Override
                public void publish(LogRecord logRecord) {
                    if (logRecord.getLevel().intValue() <= Level.FINE.intValue()) {
                        logger.log(logRecord.getMessage(), "FINE");
                        return;
                    }
                    if (logRecord.getLevel().intValue() <= Level.INFO.intValue()) {
                        logger.log(logRecord.getMessage(), "INFO");
                        return;
                    }
                    if (logRecord.getLevel().intValue() <= Level.WARNING.intValue()) {
                        logger.log(logRecord.getMessage(), "WARNING");
                        return;
                    }
                    logger.log(logRecord.getMessage(), "SEVERE");
                }

                @Override
                public void flush() {
                }

                @Override
                public void close() throws SecurityException {
                }
            });
        } catch (Exception e) {

        }
    }
}
