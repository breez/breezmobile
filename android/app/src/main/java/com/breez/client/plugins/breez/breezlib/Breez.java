package com.breez.client.plugins.breez.breezlib;

import android.app.Activity;
import android.content.Context;
import android.os.AsyncTask;
import android.util.Log;

import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.tasks.Tasks;
import com.google.api.client.googleapis.extensions.android.gms.auth.GoogleAccountCredential;
import com.google.api.services.drive.DriveScopes;

import bindings.Logger;
import io.flutter.plugin.common.ActivityLifecycleListener;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import bindings.*;

import java.io.File;
import java.lang.reflect.*;
import java.util.*;
import androidx.work.*;
import java.util.concurrent.*;

import static com.breez.client.plugins.breez.breezlib.ChainSync.UNIQUE_WORK_NAME;

public class Breez implements MethodChannel.MethodCallHandler, StreamHandler, ActivityLifecycleListener, AppServices {

    public static final String BREEZ_CHANNEL_NAME = "com.breez.client/breez_lib";
    public static final String BREEZ_STREAM_NAME = "com.breez.client/breez_lib_notifications";
    private static final String TAG = "BREEZUI";

    private volatile boolean _started = false;
    private EventChannel.EventSink m_eventsListener;
    private Map<String, Method> _bindingMethods = new HashMap<String, Method>();
    private Executor _executor = Executors.newCachedThreadPool();
    private GoogleAuthenticator m_authenticator;
    private Activity m_activity;
    private static Logger _breezLogger;

    public Breez(PluginRegistry.Registrar registrar) {
        m_authenticator = new GoogleAuthenticator(registrar);
        m_activity = registrar.activity();
        registrar.view().addActivityLifecycleListener(this);
        new MethodChannel(registrar.messenger(), BREEZ_CHANNEL_NAME).setMethodCallHandler(this);
        new EventChannel(registrar.messenger(), BREEZ_STREAM_NAME).setStreamHandler(this);
        Method[] methods = Bindings.class.getDeclaredMethods();
        for (Method m : methods) {
            _bindingMethods.put(m.getName(), m);
        }
    }

    public static synchronized Logger getLogger(Context context) throws Exception {
        if (_breezLogger == null) {
            _breezLogger = Bindings.getLogger(getWorkingDir(context));
        }
        return _breezLogger;
    }

    @Override
    public String backupProviderName() {
        return "gdrive";
    }

    @Override
    public String backupProviderSignIn() throws Exception {
        return m_authenticator.getAccessToken();
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("init")) {
            _executor.execute(() -> {
                init(call, result);
            });
        }
        else if (call.method.equals("start")) {
            _executor.execute(() -> {
                start(call, result);
            });
        } else if (call.method.equals("stop")) {
            stop(call, result);
        } else if (call.method.equals("log")) {
            log(call, result);
        } else if (call.method.equals("signIn")) {
            _executor.execute(() -> {
                signIn(call, result);
            });
        } else if (call.method.equals("signOut")) {
            _executor.execute(() -> {
                signOut(call, result);
            });
        } else if (call.method.equals("restoreBackup")) {
            _executor.execute(() -> {
                restoreBackup(call, result);
            });
        } else {
            _executor.execute(new BreezTask(call, result));
        }
    }

    private static String getWorkingDir(Context context){
        return new File(context.getDataDir(), "app_flutter").getAbsolutePath();
    }

    private void start(MethodCall call, MethodChannel.Result result){
        try {
            Bindings.start();
            _started = true;
            success(result,true);
        } catch (Exception e) {
            fail(result, "ResultError", e.getMessage(), "Failed to Start breez library");
        }

        ChainSync.schedule();
    }

    private void init(MethodCall call, MethodChannel.Result result){
        String tempDir = call.argument("tempDir").toString();
        String workingDir = call.argument("workingDir").toString();
        Log.i(TAG, "workingDir = " + workingDir);
        try {
            Bindings.init(tempDir, workingDir, this);
            success(result,true);
        } catch (Exception e) {
            fail(result, "ResultError", e.getMessage(), "Failed to Init breez library");
        }
    }

    private void stop(MethodCall call, MethodChannel.Result result){
        Log.i(TAG, "Stop breez was called on plugin");
        Boolean permanent = call.argument("permanent");
        if (permanent != null && permanent.booleanValue()) {
            Log.i(TAG, "Stop breez was called with permanent flag, cancelling job");
            WorkManager.getInstance().cancelUniqueWork(UNIQUE_WORK_NAME);
        }
        Bindings.stop();
    }

    private void log(MethodCall call, MethodChannel.Result result){
        try {
            Bindings.log(call.argument("msg").toString(), call.argument("lvl").toString());
            success(result,true);
        }
        catch(Exception e) {
            fail(result,"ResultError", e.getMessage(), "Failed to call breez logger");
        }
    }

    private void signIn(MethodCall call, MethodChannel.Result result){
        try {
            Boolean force = call.argument("force");
            if (force != null && force.booleanValue()) {
                m_authenticator.signOut();
            }
            m_authenticator.ensureSignedIn(false);
            success(result,true);
        } catch (Exception e) {
            fail(result,"AuthError", e.getMessage(), "Failed to signIn breez library");
        }
    }

    private void signOut(MethodCall call, MethodChannel.Result result){
        try {
            m_authenticator.signOut();
            success(result,true);
        } catch (Exception e) {
            fail(result,"ResultError", e.getMessage(), "Failed to sign out breez library");
        }
    }

    private void restoreBackup(MethodCall call, MethodChannel.Result result){
        try {
            String nodeID = call.argument("nodeID");
            String restorePIN = call.argument("restorePIN");
            Bindings.restoreBackup(nodeID, restorePIN);
            success(result,true);
        } catch (Exception e) {
            fail(result,"ResultError", e.getMessage(), e.getMessage());
        }
    }


    @Override
    public void onListen(Object args, final EventChannel.EventSink events){
        m_eventsListener = events;
    }

    @Override
    public void onCancel(Object args) {
        m_eventsListener = null;
    }

    @Override
    public void notify(byte[] bytes) {
        //JNI pass here null in the case of empty byte array
        byte[] marshaledData = bytes == null ? new byte[0] : bytes;
        if (m_eventsListener != null) {
            m_activity.runOnUiThread(() -> {
                m_eventsListener.success(marshaledData);
            });
        }
    }


    @Override
    public void onPostResume() {
       _executor.execute(() -> {
           try {
               Thread.sleep(1000);
           } catch (InterruptedException e) {}
           if (_started) {
               Bindings.onResume();
           }
       });
    }

    private void success(MethodChannel.Result res, Object result) {
        this.m_activity.runOnUiThread(() -> res.success(result));
    }

    private void fail(MethodChannel.Result res, String code, String message, Object err) {
        this.m_activity.runOnUiThread(() -> res.error(code, message, err));
    }

    private class BreezTask implements  Runnable {
        private MethodChannel.Result m_result;
        private MethodCall m_call;

        public BreezTask(MethodCall call, MethodChannel.Result result) {
            m_call = call;
            m_result = result;
        }
        public void run() {
            //generic mechanism for calling
            try {
                Method method = _bindingMethods.get(m_call.method);
                if (method == null) {
                    Breez.this.fail(m_result, "Failed to invoke method " + m_call.method, "Method does not exist", "ResultError");
                    return;
                }
                Object arg = m_call.argument("argument");
                if (method.getParameterTypes().length > 1) {
                    Breez.this.fail(m_result, "NotSupported", "Breez supports only methods with none or one arguments", "ResultError");
                    return;
                }
                Object bindingResult;
                if (method.getParameterTypes().length == 1) {
                    bindingResult = method.invoke(null, arg);
                }
                else {
                    bindingResult = method.invoke(null);
                }
                Breez.this.success(m_result, bindingResult); //static method with one arg
            }
            catch (Exception e) {
                Throwable breezError = e.getCause() != null ? e.getCause() : e;
                Log.e(TAG, "Error in method " + m_call.method + ": " + breezError.getMessage(), breezError);
                Breez.this.fail(m_result, breezError.getMessage(), breezError.getMessage(),"Failed to invoke method " + m_call.method);
            }
        }
    }
}

