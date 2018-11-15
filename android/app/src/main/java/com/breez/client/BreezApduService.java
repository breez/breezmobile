package com.breez.client;

import android.support.v4.content.LocalBroadcastManager;

import android.content.Intent;
import android.nfc.cardemulation.HostApduService;
import android.os.Bundle;
import android.util.Log;

import java.io.ByteArrayOutputStream;
import java.util.Arrays;
import java.io.File;
import java.io.BufferedInputStream;
import java.io.FileInputStream;

public class BreezApduService extends HostApduService {

    public static final String ACTION_BOLT11_RECEIVED = "lightning.action.BOLT11_RECEIVED";
    public static final String ACTION_LINK_DEACTIVATED = "lightning.action.LINK_DEACTIVATED";

    private static final String TAG = "breez-apdu";

    // the response sent from the phone if it does not understand an APDU
    private static final byte[] UNKNOWN_COMMAND_RESPONSE = {(byte) 0xff};

    // the SELECT AID APDU issued by the POS
    // our AID is 0xF0425245455A425245455A

    public static final byte[] SELECT_AID_COMMAND_POS = {
            (byte) 0x00, // Class
            (byte) 0xA4, // Instruction
            (byte) 0x04, // Parameter 1
            (byte) 0x00, // Parameter 2
            (byte) 0x0B, // Length = 11
            (byte) 0xF0, // Custom AID
            (byte) 0x42, // B
            (byte) 0x52, // R
            (byte) 0x45, // E
            (byte) 0x45, // E
            (byte) 0x5A, // Z
            (byte) 0x42, // B
            (byte) 0x52, // R
            (byte) 0x45, // E
            (byte) 0x45, // E
            (byte) 0x5A  // Z
    };

    public static final byte[] SELECT_AID_COMMAND_P2P = {
            (byte) 0x00, // Class
            (byte) 0xA4, // Instruction
            (byte) 0x04, // Parameter 1
            (byte) 0x00, // Parameter 2
            (byte) 0x0B, // Length = 11
            (byte) 0xF0, // Custom AID
            (byte) 0x42, // B
            (byte) 0x52, // R
            (byte) 0x45, // E
            (byte) 0x45, // E
            (byte) 0x5A, // Z
            (byte) 0x42, // B
            (byte) 0x52, // R
            (byte) 0x45, // E
            (byte) 0x45, // E
            (byte) 0x5B  // [
    };

    // OK status sent in response to SELECT AID command (0x9000)
    public static final byte[] SELECT_RESPONSE_OK = {(byte) 0x90, (byte) 0x00};

    public static final byte[] SELECT_RESPONSE_OK_DEBUG = {(byte) 0x90, (byte) 0x00};

    // Protocol commands issued by POS
    public static final byte[] BOLT11_COMMAND = {(byte) 0x01};

    // Protocol commands issued by client
    public static final byte[] USERID_COMMAND = {(byte) 0x02};

    // Protocol commands issued by peer
    public static final byte[] BLANK_INVOICE_COMMAND = {(byte) 0x04};
    public static final byte[] BLANK_INVOICE_NOT_AVAILABLE = {(byte) 0x05};

    // Custom protocol responses by client
    private static final byte[] BOLT11_RECEIVED = {(byte) 0x03};

    public static final byte[] DATA_RESPONSE_OK = {(byte) 0x00};


    private ByteArrayOutputStream bolt11receiveBuffer;

    private static int m_packetSize = 255;
    private static int m_payloadSize = m_packetSize - 3;
    private int m_packetsNumber = 0;
    private int m_currentPacket = 0;

    private byte[] m_blankInvoiceBytes;

    @Override
    public void onCreate() {
        Log.i(TAG, "Created");
        super.onCreate();
        bolt11receiveBuffer = new ByteArrayOutputStream();
    }

    private byte[] blankInvoicePacket() {
        byte[] blankInvoiceChunk = Arrays.copyOfRange(m_blankInvoiceBytes, 0, m_blankInvoiceBytes.length > m_payloadSize ? m_payloadSize : m_blankInvoiceBytes.length);
        m_blankInvoiceBytes = Arrays.copyOfRange(m_blankInvoiceBytes, m_blankInvoiceBytes.length > m_payloadSize ? m_payloadSize : m_blankInvoiceBytes.length, m_blankInvoiceBytes.length);

        byte[] packet = new byte[3 + blankInvoiceChunk.length];
        packet[0] = BreezApduService.BLANK_INVOICE_COMMAND[0];
        packet[1] = (byte) m_currentPacket;
        packet[2] = (byte) m_packetsNumber;

        System.arraycopy(blankInvoiceChunk, 0, packet, 3, blankInvoiceChunk.length);

        m_currentPacket++;
        return packet;
    }

    @Override
    public byte[] processCommandApdu(byte[] commandApdu, Bundle extras) {
        Log.i(TAG, "processCommandApdu");

        if (Arrays.equals(SELECT_AID_COMMAND_P2P, commandApdu)) {
            Log.i(TAG, "P2P link established");

            // Get the file
            File localDir = this.getFilesDir().getParentFile();
            File blankInvoiceFile = new File(localDir, "/app_flutter/blank_invoice.txt");

            m_blankInvoiceBytes = new byte[(int)blankInvoiceFile.length()];

            Log.i(TAG, blankInvoiceFile.getAbsolutePath());

            try {
                BufferedInputStream buf = new BufferedInputStream(new FileInputStream(blankInvoiceFile));
                buf.read(m_blankInvoiceBytes, 0, m_blankInvoiceBytes.length);
                buf.close();
            } catch (java.io.FileNotFoundException e) {
                Log.i(TAG, "Blank invoice file not found", e);
                return BLANK_INVOICE_NOT_AVAILABLE;
            } catch (java.io.IOException e) {
                e.printStackTrace();
            }

            m_packetsNumber = (m_blankInvoiceBytes.length / m_payloadSize) + 1;
            m_currentPacket = 0;
            return blankInvoicePacket();
        }

        else if (Arrays.equals(SELECT_AID_COMMAND_POS, commandApdu)) {
            Log.i(TAG, "POS link established");

            // Get the file
            File localDir = this.getFilesDir().getParentFile();
            File userIdFile = new File(localDir, "/app_flutter/userid.txt");

            byte[] userIdBytes = new byte[(int)userIdFile.length()];

            Log.i(TAG, userIdFile.getAbsolutePath());

            try {
                BufferedInputStream buf = new BufferedInputStream(new FileInputStream(userIdFile));
                buf.read(userIdBytes, 0, userIdBytes.length);
                buf.close();
            } catch (java.io.FileNotFoundException e) {
                Log.i(TAG, "User ID file not found", e);
            } catch (java.io.IOException e) {
                e.printStackTrace();
            }

            byte[] userIdResponse = new byte[USERID_COMMAND.length + userIdBytes.length];
            System.arraycopy(USERID_COMMAND, 0, userIdResponse, 0, USERID_COMMAND.length);
            System.arraycopy(userIdBytes, 0, userIdResponse, USERID_COMMAND.length, userIdBytes.length);

            return userIdResponse;
        }

        else if (commandApdu[0] == DATA_RESPONSE_OK[0]) {
            return blankInvoicePacket();
        }

        else if (commandApdu[0] == BOLT11_COMMAND[0]) {
            final int seqNo = commandApdu[1];
            final int totalPackets = commandApdu[2];

            Log.d(TAG, "Packet#: " + String.valueOf(seqNo));
            Log.d(TAG, "Total packets: " + String.valueOf(totalPackets));

            if (seqNo == 0 && totalPackets > 1) {
                bolt11receiveBuffer = new ByteArrayOutputStream();
            }

            bolt11receiveBuffer.write(commandApdu, 3, commandApdu.length - 3);

            if (totalPackets > 1) {
                if (seqNo == totalPackets - 1) { // Last packet
                    return bolt11Received();
                }
                return DATA_RESPONSE_OK;
            }
            else {
                return bolt11Received();
            }
        }

        else {
            return UNKNOWN_COMMAND_RESPONSE;
        }
    }

    private byte[] bolt11Received() {
        Intent intent = new Intent(ACTION_BOLT11_RECEIVED);
        intent.putExtra("bolt11", bolt11receiveBuffer.toString());
        startActivity(intent);
        bolt11receiveBuffer.reset();
        return BOLT11_RECEIVED;
    }

    @Override
    public void onDeactivated(int reason) {
        Log.d(TAG, "Link deactivated: " + reason);
        notifyLinkDeactivated(reason);
    }

    private void notifyLinkDeactivated(int reason) {
        Log.d(TAG, "notifyLinkDeactivated: " + reason);
        Intent intent = new Intent(ACTION_LINK_DEACTIVATED);
        intent.putExtra("reason", reason);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }
}
