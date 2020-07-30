package com.trackflowio.flutter_trackflow;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import androidx.annotation.Nullable;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import com.trackflowio.flutter_trackflow.PermissionManager.ActivityRegistry;


import java.util.List;

final class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {
    private final Context applicationContext;
    private final PermissionManager permissionManager;
    

    MethodCallHandlerImpl(
            Context applicationContext,
            PermissionManager permissionManager) {
        this.applicationContext = applicationContext;
       this.permissionManager = permissionManager;
       
    }

    @Nullable
    private Activity activity;

    @Nullable
    private ActivityRegistry activityRegistry;

  

    public void setActivity(@Nullable Activity activity) {
      this.activity = activity;
    }

    public void setActivityRegistry(
        @Nullable ActivityRegistry activityRegistry) {
      this.activityRegistry = activityRegistry;
    }

   

  @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result)
    {
        switch (call.method) {
            
            case "checkPermissionStatus": {
                @PermissionConstants.PermissionGroup final int permission = Integer.parseInt(call.arguments.toString());
                permissionManager.checkPermissionStatus(
                        permission,
                        applicationContext,
						activity,
                        result::success,
                        (String errorCode, String errorDescription) -> result.error(
                                errorCode,
                                errorDescription,
                                null));

                break;
            }
          
            default:
                result.notImplemented();
                break;
        }
    }
}
