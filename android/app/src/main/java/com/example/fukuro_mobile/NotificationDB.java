package com.example.fukuro_mobile;

import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import androidx.annotation.Nullable;
public class NotificationDB extends SQLiteOpenHelper  {

    public static final String dbName = "notification";
    public static final String tbNotification = "notification";
    public static final String colNotificationTitle = "title";
    public static final String colNotificationBody = "body";
    public static final String colNotificationData = "data";

    public static final String createTbNotification = "CREATE TABLE " + tbNotification + " (id INTEGER PRIMARY KEY AUTOINCREMENT, "
            + colNotificationTitle + " TEXT, "
            + colNotificationData + " TEXT, "
            + colNotificationBody + " TEXT) ";

    public NotificationDB(Context context){
        super(context,dbName,null,1);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(createTbNotification);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

    public float insertNotification(Notification not){

        Log.v("SQL","inserting notification");
        float result = 0;
        SQLiteDatabase db = this.getWritableDatabase();
        Log.v("SQL", "PATH " + db.getPath());
        ContentValues values = new ContentValues();
        values.put(colNotificationTitle,not.title);
        values.put(colNotificationBody,not.body);
        values.put(colNotificationData,not.data);

        result = db.insert(tbNotification,null,values);
        Log.d("SQL",Float.toString(result) );
        return  result;
    }
}
