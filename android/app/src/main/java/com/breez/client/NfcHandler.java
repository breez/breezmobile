package com.breez.client;

import android.app.PendingIntent;
import android.content.Intent;
import android.content.IntentFilter;
import android.nfc.NdefMessage;
import android.nfc.NfcAdapter;
import android.nfc.Tag;
import android.nfc.tech.Ndef;
import android.nfc.tech.IsoDep;
import android.nfc.NdefRecord;
import android.os.Parcelable;
import android.util.Log;

import bindings.Bindings;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.nio.ByteBuffer;
import java.util.Arrays;
import java.io.UnsupportedEncodingException;

import android.nfc.FormatException;
import android.nfc.TagLostException;

import java.io.IOException;


public class NfcHandler implements MethodChannel.MethodCallHandler, NfcAdapter.ReaderCallback {
    private static final String NFC_CHANNEL = "com.breez.client/nfc";
    private MainActivity m_mainActivity;

    private byte[] m_bolt11Bytes;
    private boolean m_requestingP2P;

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
        if (call.method.equals("startBolt11Beam")) {
            startBolt11Beam(call.argument("bolt11").toString());
            result.success(true);
        }
        if (call.method.equals("startP2PBeam")) {
            startP2PBeam();
            result.success(true);
        }
        if (call.method.equals("stopBeam")) {
            stopBeam();
            result.success(true);
        }
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

    }

    private void startBolt11Beam(String bolt11) {
        m_requestingP2P = false;
        //TODO Decode bech32 strings to byte[].
        // Use src/main/java/com/samourai/wallet/segwit/Bech32Util.java from https://github.com/SamouraiDev/bech32/
        m_bolt11Bytes = bolt11.getBytes();
        m_adapter.enableReaderMode(m_mainActivity, this, NfcAdapter.FLAG_READER_NFC_A, null);
    }

    private void startP2PBeam() {
        m_requestingP2P = true;
        m_adapter.enableReaderMode(m_mainActivity, this, NfcAdapter.FLAG_READER_NFC_A, null);
    }

    private void stopBeam() {
        m_requestingP2P = false;
        m_adapter.disableReaderMode(m_mainActivity);
    }

    private void readBreezCard(Tag tag) {
        Ndef ndefTag = Ndef.get(tag);
        try {
            ndefTag.connect();
        }
        catch (java.io.IOException ioe) {
            Log.d(TAG, "IOException when connecting to NDEF tag");
        }

        NdefMessage msg = ndefTag.getCachedNdefMessage();
        if (msg.getRecords()[0].toMimeType().equals("application/breez")) {
            if (m_mainActivity.isPos) { // We are a POS getting a Breez ID from the card
                Log.d(TAG, "Discovered a Breez card...");

                try {
                    String breezId = new String(msg.getRecords()[0].getPayload(), "UTF-8");
                    Log.d(TAG, "Breez card ID: " + breezId);
                    m_methodChannel.invokeMethod("receivedBreezId", breezId);
                } catch (UnsupportedEncodingException exc) {
                    Log.e(TAG, "UnsupportedEncodingException while reading Breez card", exc);
                }
            }
        }
    }

    public void handleIntent(Intent intent) {
        if (intent.getAction().equals(BreezApduService.ACTION_BOLT11_RECEIVED)) {
            String bolt11 = intent.getStringExtra("bolt11");
            if (bolt11 != null) {
                m_methodChannel.invokeMethod("receivedBolt11", bolt11);
            }
        }

        if (intent.getAction().equals(NfcAdapter.ACTION_NDEF_DISCOVERED)) {
            Log.d(TAG, "Discovered an NDEF tag...");
            Parcelable[] rawMessages = intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES);
            if (rawMessages != null) {
                Log.d(TAG, "Discovered raw messages...");
                NdefMessage[] messages = new NdefMessage[rawMessages.length];
                for (int i = 0; i < rawMessages.length; i++) {
                    messages[i] = (NdefMessage) rawMessages[i];
                }
                Log.d(TAG, "message type = " + messages[0].getRecords()[0].toMimeType());
                if (messages[0].getRecords()[0].toMimeType() != null && messages[0].getRecords()[0].toMimeType().equals("application/breez")) {
                    if (m_mainActivity.isPos) { // We are a POS getting a Breez ID from the card
                        Log.d(TAG, "Discovered a Breez card...");
                        try {
                            String breezId = new String(messages[0].getRecords()[0].getPayload(), "UTF-8");
                            Log.d(TAG, "Breez card ID: " + breezId);
                            m_methodChannel.invokeMethod("receivedBreezId", breezId);
                        } catch (UnsupportedEncodingException exc) {
                            Log.e(TAG, "UnsupportedEncodingException while reading Breez card", exc);
                        }
                    }
                } else {
                    try {
                        byte[] payload = messages[0].getRecords()[0].getPayload();
                        //Get the Text Encoding
                        String textEncoding = ((payload[0] & 0200) == 0) ? "UTF-8" : "UTF-16";
                        //Get the Language Code
                        int languageCodeLength = payload[0] & 0077;
                        String languageCode = new String(payload, 1, languageCodeLength, "US-ASCII");
                        //Get the Text
                        String lnURL = new String(payload, languageCodeLength + 1, payload.length - languageCodeLength - 1, textEncoding);

                        if (lnURL != null && lnURL.startsWith("lightning:lnurl")) {
                            Log.d(TAG, "Discovered LNURL...");
                            m_methodChannel.invokeMethod("receivedLNURL", lnURL);
                        }
                        Log.d(TAG, "LNURL: " + lnURL);

                    } catch (UnsupportedEncodingException exc) {
                        Log.e(TAG, "Error", exc);
                    }
                }
            }
        }
    }

    @Override
    public void onTagDiscovered(Tag tag) {
        for (String tech : tag.getTechList()) {
            if (tech.equals("android.nfc.tech.Ndef")) {
                readBreezCard(tag);
                return;
            }
        }

        IsoDep isoDep = IsoDep.get(tag);
        try {
            isoDep.connect();
        } catch (java.io.IOException ioe) {
            Log.d(TAG, "IOException when connecting to IsoDep");
        }

        if (m_requestingP2P) {
            checkIfP2P(isoDep);
        }
        else {
            checkIfPos(isoDep);
        }
    }

    private void checkIfP2P(IsoDep isoDep) {
        byte[] reply = null;
        try {
            reply = isoDep.transceive(BreezApduService.SELECT_AID_COMMAND_P2P);
        } catch (java.io.IOException ioe) {
            Log.d(TAG, "IOException when transmitting to IsoDep");
        }

        if (reply != null && reply[0] == BreezApduService.BLANK_INVOICE_COMMAND[0]) {
            try {
                // If there is only one packet
                //int totalPackets = reply[1];
                int totalPackets = reply[2];
                String blankInvoice = new String(Arrays.copyOfRange(reply, 3, reply.length), "UTF-8");

                if (totalPackets == 1) {
                    m_methodChannel.invokeMethod("receivedBlankInvoice", blankInvoice);
                    return;
                }

                // Otherwise transceive and put together
                int currentPacket = 0;

                while (currentPacket < totalPackets) {
                    try {
                        reply = isoDep.transceive(BreezApduService.DATA_RESPONSE_OK);
                    } catch (java.io.IOException ioe) {
                        Log.d(TAG, "IOException when transmitting to IsoDep");
                    }
                    blankInvoice = blankInvoice + new String(Arrays.copyOfRange(reply, 3, reply.length), "UTF-8");
                    currentPacket++;
                }

                m_methodChannel.invokeMethod("receivedBlankInvoice", blankInvoice);
                return;

            } catch (UnsupportedEncodingException exc) {
                Log.e(TAG, "UnsupportedEncodingException while reading APDU user ID", exc);
            }
        }

        if (reply != null && reply[0] == BreezApduService.BLANK_INVOICE_NOT_AVAILABLE[0]) {
            m_methodChannel.invokeMethod("receivedBlankInvoice", "NOT_AVAILABLE");
        }
    }

    private void checkIfPos(IsoDep isoDep) {
        byte[] reply = null;
        try {
            reply = isoDep.transceive(BreezApduService.SELECT_AID_COMMAND_POS);
        } catch (java.io.IOException ioe) {
            Log.d(TAG, "IOException when transmitting to IsoDep");
        }

        if (reply != null && reply[0] == BreezApduService.USERID_COMMAND[0]) {
            try {
                String userId = new String(Arrays.copyOfRange(reply, 1, reply.length), "UTF-8");
                // Disable this path for now
                //m_methodChannel.invokeMethod("receivedBreezId", userId);
            } catch (UnsupportedEncodingException exc) {
                Log.e(TAG, "UnsupportedEncodingException while reading APDU user ID", exc);
            }

            beamBolt11(isoDep);
        }
    }

    private void beamBolt11(IsoDep isoDep) {
        byte[] bolt11Bytes = m_bolt11Bytes;
        int packetSize = 255;
        int payloadSize = packetSize - 3;
        int numberOfPackets = (bolt11Bytes.length / payloadSize) + 1;

        for (int i = 0; i < numberOfPackets; i++) {
            byte[] bolt11Chunk = Arrays.copyOfRange(bolt11Bytes, 0, bolt11Bytes.length > payloadSize ? payloadSize : bolt11Bytes.length);
            bolt11Bytes = Arrays.copyOfRange(bolt11Bytes, bolt11Bytes.length > payloadSize ? payloadSize : bolt11Bytes.length, bolt11Bytes.length);

            byte[] packet = new byte[3 + bolt11Chunk.length];
            packet[0] = BreezApduService.BOLT11_COMMAND[0];
            packet[1] = (byte) i;
            packet[2] = (byte) (numberOfPackets);

            System.arraycopy(bolt11Chunk, 0, packet, 3, bolt11Chunk.length);

            byte[] reply = null;
            try {
                reply = isoDep.transceive(packet);
            } catch (java.io.IOException ioe) {
                Log.d(TAG, "IOException when transmitting to IsoDep");
            }

            if (reply != null && !Arrays.equals(reply, BreezApduService.DATA_RESPONSE_OK)) {
                return;
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

    void logError(String str, String str2) {
        Bindings.log(str, "WARNING");
        Log.e(TAG, str + "\n" + str2);
    }
}
