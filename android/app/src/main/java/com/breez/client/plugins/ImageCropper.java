package com.breez.client.plugins;

import android.content.Intent;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import com.theartofdev.edmodo.cropper.CropImage;
import io.flutter.plugin.common.MethodChannel.Result;
import com.theartofdev.edmodo.cropper.CropImageView;
import io.flutter.app.FlutterActivity;
import android.app.Activity;
import android.net.*;
import java.io.File;
import io.flutter.plugin.common.*;

public class ImageCropper implements MethodChannel.MethodCallHandler, PluginRegistry.ActivityResultListener {
    static final int CROP_SQUARE_SIZE = 100;
    MethodChannel m_methodChannel;
    PluginRegistry.Registrar m_registrar;
    Result m_currentCallResult;

    public ImageCropper(PluginRegistry.Registrar registrar)
    {
        m_registrar = registrar;
        registrar.addActivityResultListener(this);
        m_methodChannel = new MethodChannel(registrar.messenger(), "com.breez.client/image-cropper");
        m_methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("start")) {
            m_currentCallResult = result;            
            CropImage.activity( Uri.fromFile(new File(call.argument("filePath").toString())))
                .setGuidelines(CropImageView.Guidelines.ON)
                .setFixAspectRatio(true)
                .start(m_registrar.activity());
        }
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {
            CropImage.ActivityResult result = CropImage.getActivityResult(data);
            if (resultCode == Activity.RESULT_OK) {
                Uri resultUri = result.getUri();
                m_currentCallResult.success(resultUri.getPath());
            } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
                Exception error = result.getError();
                m_currentCallResult.error("Failed", "Faied to crop image", error.getMessage());
            }
            m_currentCallResult = null;
            return true;
        }

        return false;
    }
}