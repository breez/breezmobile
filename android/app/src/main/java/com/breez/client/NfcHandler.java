package com.breez.client;

import android.content.Intent;
import android.content.IntentFilter;
import android.nfc.NdefMessage;
import android.nfc.NfcAdapter;
import android.os.Parcelable;
import android.util.Log;

import java.io.UnsupportedEncodingException;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class NfcHandler implements MethodChannel.MethodCallHandler {
    private static final String NFC_CHANNEL = "com.breez.client/nfc";
    private MainActivity m_mainActivity;

    private NfcAdapter m_adapter;

    private MethodChannel m_methodChannel;

    private static final String TAG = "Breez-NFC";

    public NfcHandler(MainActivity mainActivity) {
        m_adapter = NfcAdapter.getDefaultAdapter(mainActivity);

        IntentFilter ndef = new IntentFilter(NfcAdapter.ACTION_NDEF_DISCOVERED);

        try {
            ndef.addDataType("application/breez");
        } catch (IntentFilter.MalformedMimeTypeException e) {
            throw new RuntimeException("fail", e);
        }

        m_mainActivity = mainActivity;
        m_methodChannel = new MethodChannel(mainActivity.getFlutterView(), NFC_CHANNEL);
        m_methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("checkNFCSettings")) {
            try {
                boolean isNFCEnabledString = checkNFCSettings();
                result.success(isNFCEnabledString);
            } catch (Exception e) {
                result.success(false);
            }
        }
        if (call.method.equals("openNFCSettings")) {
            try {
                startNfcSettingsActivity();
            } catch (Exception e) {
                result.success(false);
            }
        }
        if (call.method.equals("checkIfStartedWithNfc")) {
            Log.d(TAG, "Called: checkIfStartedWithNfc");
            try {
                String nfcStartedWith = getNfcStartedWith(m_mainActivity.getIntent());
                result.success(nfcStartedWith);
            } catch (Exception e) {
                result.success("false");
            }
        }

    }

    private boolean checkNFCSettings() {
        boolean isNFCEnabledString = false;
        if (m_adapter != null && m_adapter.isEnabled()) {
            isNFCEnabledString = true;
        }
        return isNFCEnabledString;
    }

    protected void startNfcSettingsActivity() {
        if (android.os.Build.VERSION.SDK_INT >= 16) {
            m_mainActivity.startActivity(new Intent(android.provider.Settings.ACTION_NFC_SETTINGS));
        } else {
            m_mainActivity.startActivity(new Intent(android.provider.Settings.ACTION_WIRELESS_SETTINGS));
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
