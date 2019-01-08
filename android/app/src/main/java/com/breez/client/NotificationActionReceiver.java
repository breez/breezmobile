package com.breez.client;

import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.RemoteInput;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

import com.google.firebase.messaging.RemoteMessage;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;

import static com.breez.client.BreezFirebaseMessagingService.EXTRA_REMOTE_MESSAGE;
import static com.breez.client.BreezFirebaseMessagingService.ACTION_REMOTE_MESSAGE;
import static com.breez.client.MainActivity.NOTIFICATION_ID;

public class NotificationActionReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent)  {
        // Payment request is packed here
        RemoteMessage remoteMessage = intent.getParcelableExtra(EXTRA_REMOTE_MESSAGE);
        Log.i("RECEIVER", "get remote message****" + remoteMessage.getData().toString());

        // Resume Breez
        final Intent notificationIntent = new Intent(context, MainActivity.class);
        notificationIntent.setAction(Intent.ACTION_MAIN);
        notificationIntent.addCategory(Intent.CATEGORY_LAUNCHER);
        notificationIntent.putExtra("click_action", "FLUTTER_NOTIFICATION_CLICK");

        for (String s : remoteMessage.getData().keySet()) {
            notificationIntent.putExtra(s, remoteMessage.getData().get(s));
        }
        context.startActivity(notificationIntent);
    }
}

