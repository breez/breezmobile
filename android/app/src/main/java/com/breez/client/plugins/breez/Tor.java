package com.breez.client.plugins.breez;

import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.io.IOException;
import java.io.FileWriter;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.util.Log;
import java.util.concurrent.Executor;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import org.torproject.jni.TorService;
import net.freehaven.tor.control.ConfigEntry;
import net.freehaven.tor.control.TorControlConnection;

public class Tor implements FlutterPlugin, MethodCallHandler {

    private static final String TOR_CHANNEL = "com.breez.client/tor";
    private static final String TAG = "BREEZUI";
    private Executor uiThreadExecutor;  // FIXME(nochiel) We don't need to use this as this all runs in the UI thread.

    private static TorService torService;

    private Map<String, String> torConfig;
    private FlutterPluginBinding binding;
    private ServiceConnection connection;
    private BroadcastReceiver receiver;
    private MethodChannel methodChannel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        this.binding = binding;
        methodChannel = new MethodChannel(binding.getBinaryMessenger(),TOR_CHANNEL);
        methodChannel.setMethodCallHandler(this);
        uiThreadExecutor = ContextCompat.getMainExecutor(binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        // FIXME(nochiel) What else do we need to do here? to release all resources? 
        this.binding = null;
        uiThreadExecutor = null;
        methodChannel = null;
        connection = null;
        receiver = null;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {

        switch (call.method) {

            case "startTorService" : 
                startTorService(call, result);
                break;
                
            default:
                result.notImplemented();
                break;
        }

    }

    private void success(MethodChannel.Result res, Object result) {
        uiThreadExecutor.execute(() -> res.success(result));
    }

    private void fail(MethodChannel.Result res, String code, String message, Object err) {
        uiThreadExecutor.execute(() -> res.error(code, message, err));
    }

    private void startTorService(MethodCall call, MethodChannel.Result result) {

        Log.d(TAG, "Tor.java: startTorService.");    

        BroadcastReceiver receiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {

                if(!TorService.ACTION_STATUS.equals(intent.getAction())) {
                    Log.d(TAG, "TorService.ACTION_STATUS");
                    return;
                }

                String status = intent.getStringExtra(TorService.EXTRA_STATUS);
                Log.i(TAG, "Tor.java: receiver.onReceive: " + status + " " + intent);

                if(TorService.STATUS_ON.equals(status)) {

                    String controlAddress = "";
                    String socksAddress = "";
                    String httpAddress = "";

                    try {

                        TorControlConnection torControl = torService.getTorControlConnection();
                        String infoCmd = "net/listeners/control";
                        controlAddress = torControl.getInfo(infoCmd);
                        controlAddress = controlAddress.split(" ")[0];
                        assert(!controlAddress.isEmpty());
                        Log.i(TAG, "Tor.java: control" + " : " + controlAddress);

                        infoCmd = "net/listeners/socks";
                        socksAddress = torControl.getInfo(infoCmd);
                        socksAddress = socksAddress.split(" ")[0];
                        assert(!socksAddress.isEmpty());
                        Log.i(TAG, "Tor.java: socks" + " : " + socksAddress);

                        infoCmd = "net/listeners/httptunnel";
                        httpAddress = torControl.getInfo(infoCmd);
                        httpAddress = httpAddress.split(" ")[0];
                        assert(!httpAddress.isEmpty());
                        Log.i(TAG, "Tor.java: http" + " : " + httpAddress);

                        Log.i(TAG, "Tor.java: receiver.onReceive: Tor has started.");

                    } catch (IOException | NullPointerException e) {
                        Log.e(TAG, "Tor control was not found.", null);
                    }

                    torConfig = new HashMap<>();
                    torConfig.put("SOCKS", socksAddress);
                    torConfig.put("Control", controlAddress);
                    torConfig.put("HTTP", httpAddress);
                    success(result, torConfig);      

                }

            }
        };


        Context context = binding.getApplicationContext();
        context.registerReceiver(receiver, new IntentFilter(TorService.ACTION_STATUS));

        // Ref. https://developer.android.com/guide/components/services
        // Your service can work both ways—it can be started (to run indefinitely) and also allow binding. 
        //
        // TODO(nochiel) SECURITY: Declare this service as private in the manifest.
        // TODO(nochiel) handle when to call stopService.
        // The defaults that tor-android uses. 
        // torConfig.put("HTTP", "8118");
        // torConfig.put("SOCKS", "9050");
        try {
            FileWriter writer = new FileWriter(TorService.getTorrc(context));
            writer.write("ControlPort auto\n");
            writer.write("HTTPTunnelPort auto\n");
            // writer.write("ControlPort " + torConfig.get("Control") + "\n");
            // writer.write("SocksPort " + torConfig.get("SOCKS") + "\n");
            writer.flush();
            writer.close();
        } catch (IOException e) {
            fail(result, "ERROR", "Tor.java: startTorService: Error writing to torrc: " + e + ".", null);
        }

        Intent serviceIntent = new Intent(context, TorService.class);
        /*
         * ComponentName response = context.startService(serviceIntent);   
         if(response != null) { 
         Log.i(TAG, "Tor.java: startTor: tor service with ComponentName '" + response.toString() + "' already exists.");  
         }
         */
        connection = new ServiceConnection() {

            public void onServiceConnected(ComponentName className, IBinder service) {

                torService = ((TorService.LocalBinder) service).getService();
                assert(torService != null);
                Log.i(TAG, "Tor.java: onServiceConnected.");

            }

            public void onServiceDisconnected(ComponentName className) {
                torService = null;
                Log.i(TAG, "Tor.java: onServiceDisconnected.");
            }
        };

        if(!context.bindService(serviceIntent, connection, Context.BIND_AUTO_CREATE)) {
            fail(result, "FAIL", "Binding to TorService has failed.", null);
        }


        // Save the defaults that tor-android uses.
        /*
           torConfig.put("HTTP", "8118");
           torConfig.put("SOCKS", "9050");
           Log.i(TAG, "onMethodCall: calling result.success(torConfig)");
           success(result, torConfig);      // TODO(nochiel) Can This be used here?
           */

    }


}
