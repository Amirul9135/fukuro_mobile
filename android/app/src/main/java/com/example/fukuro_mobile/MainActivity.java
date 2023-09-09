package com.example.fukuro_mobile;

import android.app.ActionBar;

import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    /*
    no longer necessary commented for futre ref
    private static final String CHANNEL = "com.example.myapp/notification";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        // Set up method channel
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("initSQLite")) {
                                NotificationDB.initialize(getApplicationContext());
                                // Handle the method call and return a result
                                result.success("Result from Java");
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }*/
}
