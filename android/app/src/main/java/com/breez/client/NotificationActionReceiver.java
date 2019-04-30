package com.breez.client;

import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.google.firebase.messaging.RemoteMessage;

import static com.breez.client.BreezFirebaseMessagingService.EXTRA_REMOTE_MESSAGE;

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
        notificationIntent.putExtra("user_click", "1");

        for (String s : remoteMessage.getData().keySet()) {
            notificationIntent.putExtra(s, remoteMessage.getData().get(s));
        }

        NotificationManager manager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        manager.cancel(intent.getIntExtra(BreezFirebaseMessagingService.NOTIFICATION_ID, 0));
        context.startActivity(notificationIntent);
    }
}

