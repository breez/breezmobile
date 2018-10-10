package com.breez.client;

import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.RemoteInput;
import android.support.v4.content.LocalBroadcastManager;

import com.google.firebase.messaging.RemoteMessage;

import static com.breez.client.BreezFirebaseMessagingService.EXTRA_REMOTE_MESSAGE;
import static com.breez.client.BreezFirebaseMessagingService.ACTION_REMOTE_MESSAGE;
import static com.breez.client.MainActivity.NOTIFICATION_ID;

public class NotificationActionReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent)  {
        // Payment request is packed here
        RemoteMessage remoteMessage = intent.getParcelableExtra(EXTRA_REMOTE_MESSAGE);

        // Get rid of our notifications
        NotificationManager notificationManager = (NotificationManager) context
                .getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.cancelAll();

        // Resume Breez
        final Intent notificationIntent = new Intent(context, MainActivity.class);
        notificationIntent.setAction(Intent.ACTION_MAIN);
        notificationIntent.addCategory(Intent.CATEGORY_LAUNCHER);
        //notificationIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        context.startActivity(notificationIntent);

        // Send payment data
        Intent dataIntent = new Intent(ACTION_REMOTE_MESSAGE);
        dataIntent.putExtra(EXTRA_REMOTE_MESSAGE, remoteMessage);
        LocalBroadcastManager.getInstance(context).sendBroadcast(dataIntent);
    }
}

