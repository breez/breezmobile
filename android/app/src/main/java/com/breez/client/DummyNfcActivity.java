package com.breez.client;

import android.app.Activity;
import android.content.Intent;
import android.nfc.NfcAdapter;
import android.util.Log;

public class DummyNfcActivity extends Activity {
    private static final String TAG = "breez-nfc";

    public DummyNfcActivity() {
    }

    @Override
    protected void onNewIntent(Intent intent) {
        Log.d(TAG, "Got an intent...");

        if (intent != null && intent.getAction().equals(NfcAdapter.ACTION_NDEF_DISCOVERED)) {
            // Do absolutely nothing
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        finish();
    }
}
