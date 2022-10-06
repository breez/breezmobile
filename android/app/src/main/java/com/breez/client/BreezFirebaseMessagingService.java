package com.breez.client;

import static android.R.drawable.ic_delete;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.os.Build;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.breez.client.job.JobManager;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Map;
import java.util.logging.Logger;


public class BreezFirebaseMessagingService extends FirebaseMessagingService {
    public static final int REQUEST_CODE_OPEN = 101;
    public static final String KEY_INTENT_APPROVE = "keyintentaccept";

    public static final String ACTION_REMOTE_MESSAGE =
            "io.flutter.plugins.firebasemessaging.NOTIFICATION";
    public static final String EXTRA_REMOTE_MESSAGE = "notification";
    public static final String NOTIFICATION_ID = "NOTIFICATION_ID";

    private static final String TAG ="breez_fcm";


    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);
        Logger log = BreezLogger.getLogger(getApplicationContext(), TAG);
        log.info("FCM notification received! isBackground=" + BreezApplication.isBackground + " isRunning=" + BreezApplication.isRunning);

        if (runJobIfNeeded(remoteMessage)) {
            return;
        }

        Intent intent = new Intent(ACTION_REMOTE_MESSAGE);
        intent.putExtra(EXTRA_REMOTE_MESSAGE, remoteMessage);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);

        // Only show notifications if we are in the background
        if (BreezApplication.isBackground || !BreezApplication.isRunning) {
            Map<String, String> data = remoteMessage.getData();
            ShowNotification(data, remoteMessage);
        }
    }

    private void ShowNotification(Map<String, String> data, RemoteMessage remoteMessage) {
        int notificationID = (int) System.currentTimeMillis() / 1000;
        final Intent notificationIntent = new Intent(this, MainActivity.class);
        notificationIntent.setAction(Intent.ACTION_MAIN);
        notificationIntent.addCategory(Intent.CATEGORY_LAUNCHER);
        notificationIntent.putExtra("click_action", "FLUTTER_NOTIFICATION_CLICK");
        notificationIntent.putExtra("user_click", "1");
        notificationIntent.putExtra(KEY_INTENT_APPROVE, REQUEST_CODE_OPEN);
        notificationIntent.putExtra(NOTIFICATION_ID, notificationID);
        notificationIntent.putExtra(EXTRA_REMOTE_MESSAGE, remoteMessage);

        int flags = Build.VERSION.SDK_INT >= Build.VERSION_CODES.S ? PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE : PendingIntent.FLAG_UPDATE_CURRENT;
        PendingIntent approvePendingIntent = PendingIntent.getActivity(this, REQUEST_CODE_OPEN, notificationIntent, flags);

        String buttonTitle = data.get("button") != null ? data.get("button") : "Open";
        NotificationCompat.Action action = new NotificationCompat.Action.Builder(ic_delete, buttonTitle, approvePendingIntent).build();

        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this, "channel_id")
                .setContentTitle(data.get("title"))
                .setContentText(data.get("body"))
                .setAutoCancel(true)
                .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION))
                .setContentIntent(approvePendingIntent)
                .setContentInfo("CONTENT")
                .setLights(0xFF0089f9, 1000, 300)
                .setColorized(true)
                .setDefaults(Notification.DEFAULT_VIBRATE)
                .setSmallIcon(R.mipmap.breez_notify)
                .addAction(action)
                .setStyle(new NotificationCompat.BigTextStyle().bigText(data.get("body")))
                .setPriority(2);

        NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        NotificationChannel notificationChannel;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String CHANNEL_ID = "channel_id";
            CharSequence name = "Breez";
            int importance = NotificationManager.IMPORTANCE_HIGH;
            notificationChannel = new NotificationChannel(CHANNEL_ID, name, importance);
            notificationManager.createNotificationChannel(notificationChannel);
        }

        notificationManager.notify(notificationID, notificationBuilder.build());
    }

    private boolean runJobIfNeeded(RemoteMessage message){
        String jobToRun = message.getData().get("_job");
        if (jobToRun  != null) {
            try {
                JobManager.instance.enqueJob(jobToRun);
                Log.i(TAG, "job " + jobToRun + " was enqueued succesfully");
            } catch (Exception e) {
                Log.e(TAG, "failed to enque job from notification " + e.getMessage(), e);
            }
            return true;
        }

        return false;
    }
}
