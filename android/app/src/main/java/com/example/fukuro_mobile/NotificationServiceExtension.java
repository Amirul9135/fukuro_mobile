package com.example.fukuro_mobile;

import android.graphics.Color;
import android.nfc.Tag;
import android.util.Log;

import com.onesignal.notifications.IActionButton;
import com.onesignal.notifications.IDisplayableMutableNotification;
import com.onesignal.notifications.INotificationReceivedEvent;
import com.onesignal.notifications.INotificationServiceExtension;

import java.net.HttpURLConnection;
import java.net.URL;

public class NotificationServiceExtension implements INotificationServiceExtension {

    @Override
    public void onNotificationReceived(INotificationReceivedEvent event) {
        Log.v("TESt", "IRemoteNotificationReceivedHandler fired" + " with INotificationReceivedEvent: " + event.toString());
        try{

            NotificationDB db = new NotificationDB(event.getContext());
            String data = "";
            if(event.getNotification().getAdditionalData() != null){
                data = event.getNotification().getAdditionalData().toString();
            }
            db.insertNotification(new Notification(event.getNotification().getTitle(),
                    event.getNotification().getBody(),data));
        }catch (Exception e){
            e.printStackTrace();
            Log.v("TESt", "IRemoteNotificationReceivedHandler fired error sni " + e.toString());
        }

        IDisplayableMutableNotification notification = event.getNotification();

        if (notification.getActionButtons() != null) {
            for (IActionButton button : notification.getActionButtons()) {
            }
        }

        notification.setExtender(builder -> builder.setColor(Color.BLUE));
    }
}