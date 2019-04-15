package com.breez.client.plugins.breez.breezlib;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.RingtoneManager;
import android.os.Build;
import android.support.v4.app.NotificationCompat;

import com.breez.client.MainActivity;
import com.breez.client.R;

import static android.R.drawable.ic_delete;

public class Notification {

    public static void showClosedChannelNotification(Context ctx) {
        String title = "Action Required";
        String body = "Breez has identified a change in the state of one of your payment channels. It is highly recommended you open Breez in order to ensure access to your funds.";
        String actionText = "Open Breez";
        showNotification(ctx, title, body, actionText);
    }

    private static void showNotification(Context ctx, String title, String body, String actionText) {
        final Intent notificationIntent = new Intent(ctx, MainActivity.class);
        notificationIntent.setAction(Intent.ACTION_MAIN);
        notificationIntent.addCategory(Intent.CATEGORY_LAUNCHER);
        notificationIntent.putExtra("click_action", "FLUTTER_NOTIFICATION_CLICK");
        notificationIntent.putExtra("user_click", "1");


        Bitmap icon = BitmapFactory.decodeResource(ctx.getResources(), R.mipmap.ic_launcher);

        PendingIntent appIntent = PendingIntent.getActivity(ctx, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);



        NotificationCompat.Action action =
                new NotificationCompat.Action.Builder(ic_delete,
                        actionText, appIntent)
                        .build();

        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(ctx, "channel_id")
                .setContentTitle(title)
                .setContentText(body)
                .setAutoCancel(true)
                .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))
                .setContentIntent(appIntent)
                .setContentInfo("CONTENT")
                .setLargeIcon(icon)
                .setColor(0xFF0089f9)
                .setLights(0xFF0089f9, 1000, 300)
                .setColorized(true)
                .setDefaults(android.app.Notification.DEFAULT_VIBRATE)
                .setSmallIcon(R.mipmap.breez_notify)
                .addAction(action)
                .setStyle(new NotificationCompat.BigTextStyle().bigText(body))
                .setPriority(2);

        NotificationManager notificationManager = (NotificationManager) ctx.getSystemService(Context.NOTIFICATION_SERVICE);
        NotificationChannel notificationChannel;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String CHANNEL_ID = "channel_id";
            CharSequence name = "Breez";
            int importance = NotificationManager.IMPORTANCE_HIGH;
            notificationChannel = new NotificationChannel(CHANNEL_ID, name, importance);
            notificationManager.createNotificationChannel(notificationChannel);
        }

        final int notificationID = (int)System.currentTimeMillis() / 1000;
        notificationManager.notify(notificationID, notificationBuilder.build());
    }
}
