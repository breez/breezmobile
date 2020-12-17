package com.breez.client;

import android.content.Intent;
import android.content.IntentFilter;
import android.nfc.NdefMessage;
import android.nfc.NfcAdapter;
import android.os.Parcelable;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.UnsupportedEncodingException;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class NfcHandler implements MethodChannel.MethodCallHandler, FlutterPlugin, ActivityAware {
    private static final String NFC_CHANNEL = "com.breez.client/nfc";

    private NfcAdapter m_adapter;

    private MethodChannel m_methodChannel;

    private static final String TAG = "Breez-NFC";

    private ActivityPluginBinding binding;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        this.flutterPluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(final ActivityPluginBinding binding) {
        this.binding = binding;
        m_adapter = NfcAdapter.getDefaultAdapter(binding.getActivity());
        BinaryMessenger messenger = flutterPluginBinding.getBinaryMessenger();
        m_methodChannel = new MethodChannel(messenger, NFC_CHANNEL);
        m_methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        this.onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(final ActivityPluginBinding binding) {
        this.onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        m_methodChannel.setMethodCallHandler(null);
        m_methodChannel = null;
        m_adapter = null;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("checkIfStartedWithNfc")) {
            Log.d(TAG, "Called: checkIfStartedWithNfc");
            try {
                String nfcStartedWith = getNfcStartedWith(binding.getActivity().getIntent());
                result.success(nfcStartedWith);
            } catch (Exception e) {
              System.out.println(e.getMessage());
                e.printStackTrace();
                result.success("false");
            }
        }
    }

    protected String getNfcStartedWith(Intent intent) {
        /* Handle these cases individually:
         * NfcAdapter.ACTION_TECH_DISCOVERED
         * NfcAdapter.ACTION_TAG_DISCOVERED
         * NfcAdapter.ACTION_NDEF_DISCOVERED
         */
        Log.d(TAG, "Discovered an NDEF tag...");
        Parcelable[] rawMessages = intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES);
        if (rawMessages != null) {
            Log.d(TAG, "Discovered raw messages...");
            NdefMessage[] messages = new NdefMessage[rawMessages.length];
            for (int i = 0; i < rawMessages.length; i++) {
                messages[i] = (NdefMessage) rawMessages[i];
            }
            try {
                byte[] payload = messages[0].getRecords()[0].getPayload();
                //Get the Text Encoding
                String textEncoding = ((payload[0] & 0200) == 0) ? "UTF-8" : "UTF-16";
                //Get the Language Code
                int languageCodeLength = payload[0] & 0077;
                String languageCode = new String(payload, 1, languageCodeLength, "US-ASCII");
                //Get the Text
                String lnLink = new String(payload, languageCodeLength + 1, payload.length - languageCodeLength - 1, textEncoding);
                if (lnLink != null && lnLink.startsWith("lightning:")) {
                    Log.d(TAG, "Discovered Lightning Link...");
                    return lnLink;
                }
            } catch (UnsupportedEncodingException exc) {
                Log.e(TAG, "Error", exc);
                return "";
            }
        }

        return "";
    }
}
