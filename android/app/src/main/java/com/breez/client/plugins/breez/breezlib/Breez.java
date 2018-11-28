package com.breez.client.plugins.breez.breezlib;

import android.os.AsyncTask;
import android.util.Log;

import io.flutter.plugin.common.ActivityLifecycleListener;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import bindings.*;
import java.lang.reflect.*;
import java.util.*;
import androidx.work.*;
import java.util.concurrent.*;

public class Breez implements MethodChannel.MethodCallHandler, bindings.BreezNotifier, StreamHandler, ActivityLifecycleListener {

    public static final String BREEZ_CHANNEL_NAME = "com.breez.client/breez_lib";
    public static final String BREEZ_STREAM_NAME = "com.breez.client/breez_lib_notifications";

    private EventChannel.EventSink m_eventsListener;
    private Map<String, Method> _bindingMethods = new HashMap<String, Method>();

    public Breez(PluginRegistry.Registrar registrar) {
        registrar.view().addActivityLifecycleListener(this);
        new MethodChannel(registrar.messenger(), BREEZ_CHANNEL_NAME).setMethodCallHandler(this);
        new EventChannel(registrar.messenger(), BREEZ_STREAM_NAME).setStreamHandler(this);
        Method[] methods = Bindings.class.getDeclaredMethods();
        for (Method m : methods) {
            _bindingMethods.put(m.getName(), m);
        }
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("start")) {
            start(call, result);
        } else if (call.method.equals("log")) {
            log(call, result);
        } else {
            new BreezTask().execute(call, result);
        }
    }

    private void start(MethodCall call, MethodChannel.Result result){

        //First cancel current pending/running sync so we don't conflict.
        WorkManager.getInstance().cancelUniqueWork("chainSync");

        //Then wait for running job to shutdown gracefully
        ChainSync.waitShutdown();

        String workingDir = call.argument("workingDir").toString();
        String tempDir = call.argument("tempDir").toString();
        try {
            Bindings.start(workingDir, tempDir, this);
            result.success(true);
        } catch (Exception e) {
            result.error("ResultError", "Failed to Start breez library", e.getMessage());
        }

        PeriodicWorkRequest periodic =
                new PeriodicWorkRequest.Builder(ChainSync.class, 1, TimeUnit.HOURS)
                        .setConstraints(
                                new Constraints.Builder()                                       
                                        .setRequiresBatteryNotLow(true)
                                        .build())
                        .setInputData(
                                new Data.Builder()
                                        .putString("workingDir", workingDir)
                                        .build())
                        .build();
        WorkManager.getInstance().enqueueUniquePeriodicWork("chainSync", ExistingPeriodicWorkPolicy.REPLACE, periodic);
        return;
    }

    private void log(MethodCall call, MethodChannel.Result result){
        try {
            Bindings.log(call.argument("msg").toString(), call.argument("lvl").toString());
            result.success(true);
        }
        catch(Exception e) {
            result.error("ResultError", "Failed to call breez logger", e.getMessage());
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
            m_eventsListener.success(marshaledData);
        }
    }

    @Override
    public void onPostResume() {
        Bindings.onResume();
    }

    private class BreezTask extends AsyncTask<Object, Integer, Void> {
        private MethodChannel.Result result;
        protected Void doInBackground(Object... call) {
            //generic mechanism for calling
            result = (MethodChannel.Result)call[1];
            try {
                Method method = _bindingMethods.get(((MethodCall)call[0]).method);
                if (method == null) {
                    result.error("ResultError","Failed to invoke method " + ((MethodCall)call[0]).method, "Method does not exist");
                }
                Object arg = ((MethodCall)call[0]).argument("argument");
                if (method.getParameterTypes().length > 1) {
                    result.error("NotSupported", "Breez supports only methods with none or one arguments", "");
                }
                else if (method.getParameterTypes().length == 1) {
                    result.success(method.invoke(null, arg)); //static method with one arg
                }
                else {
                    result.success(method.invoke(null)); //static method with no args
                }
            }
            catch (Exception e) {
                Throwable breezError = e.getCause() != null ? e.getCause() : e;
                Log.e("BREEZUI", breezError.getMessage(), breezError);
                result.error("ResultError","Failed to invoke method " + ((MethodCall)call[0]).method, breezError.getMessage());
            }
            return null;
        }
    }
}

