package com.lin.exampl.flutter_trip;

import androidx.annotation.NonNull;

import com.lin.plugin.asr.AsrPlugin;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        //flutter sdk >= v1.12.13+hotfix.5 时使用下面方法注册自定义plugin
        ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
        AsrPlugin.registerWith(shimPluginRegistry.registrarFor("org.devio.flutter.plugin.asr.AsrPlugin"));
    }

}