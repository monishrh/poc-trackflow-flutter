package com.trackflowio.flutter_trackflow;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.PowerManager;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.annotation.VisibleForTesting;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.content.ContextCompat;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.PluginRegistry;

final class PermissionManager {
    @FunctionalInterface
    interface ActivityRegistry {
        void addListener(PluginRegistry.ActivityResultListener handler);
    }

  @FunctionalInterface
    interface CheckPermissionsSuccessCallback {
        void onSuccess(@PermissionConstants.PermissionStatus int permissionStatus);
    }

    @FunctionalInterface
    interface ShouldShowRequestPermissionRationaleSuccessCallback {
        void onSuccess(boolean shouldShowRequestPermissionRationale);
    }

    private boolean ongoing = false;

    void checkPermissionStatus(
            @PermissionConstants.PermissionGroup int permission,
            Context context,
            Activity activity,
            CheckPermissionsSuccessCallback successCallback,
            ErrorCallback errorCallback) {

        successCallback.onSuccess(determinePermissionStatus(
                permission,
                context,
                activity));
    }

  

    @PermissionConstants.PermissionStatus
    private int determinePermissionStatus(
            @PermissionConstants.PermissionGroup int permission,
            Context context,
            @Nullable Activity activity) {

        if (permission == PermissionConstants.PERMISSION_GROUP_NOTIFICATION) {
            return checkNotificationPermissionStatus(context);
        }

        final List<String> names = PermissionUtils.getManifestNames(context, permission);

        if (names == null) {
            Log.d(PermissionConstants.LOG_TAG, "No android specific permissions needed for: " + permission);

            return PermissionConstants.PERMISSION_STATUS_NOT_APPLICABLE;
        }

        //if no permissions were found then there is an issue and permission is not set in Android manifest
        if (names.size() == 0) {
            Log.d(PermissionConstants.LOG_TAG, "No permissions found in manifest for: " + permission);
            return PermissionConstants.PERMISSION_STATUS_NOT_APPLICABLE;
        }

        final boolean targetsMOrHigher = context.getApplicationInfo().targetSdkVersion >= Build.VERSION_CODES.M;

        for (String name : names) {
            // Only handle them if the client app actually targets a API level greater than M.
            if (targetsMOrHigher) {
                if (permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
                    String packageName = context.getPackageName();
                    PowerManager pm = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
                    // PowerManager.isIgnoringBatteryOptimizations has been included in Android M first.
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        if (pm != null && pm.isIgnoringBatteryOptimizations(packageName)) {
                            return PermissionConstants.PERMISSION_STATUS_GRANTED;
                        } else {
                            return PermissionConstants.PERMISSION_STATUS_DENIED;
                        }
                    } else {
                        return PermissionConstants.PERMISSION_STATUS_GRANTED;
                    }
                }
                final int permissionStatus = ContextCompat.checkSelfPermission(context, name);
               
                if (permissionStatus == -1) {
                    
                        return PermissionConstants.PERMISSION_STATUS_DENIED;
                    }
                    else if (permissionStatus ==  0) {
                        return PermissionConstants.PERMISSION_STATUS_GRANTED;
                    }
                    else{
                        return PermissionConstants.PERMISSION_STATUS_NOT_APPLICABLE; 
                    }
                }
            }
        

        return PermissionConstants.PERMISSION_STATUS_NOT_APPLICABLE;
    }

  

    private int checkNotificationPermissionStatus(Context context) {
        NotificationManagerCompat manager = NotificationManagerCompat.from(context);
        boolean isGranted = manager.areNotificationsEnabled();
        if (isGranted) {
            return PermissionConstants.PERMISSION_STATUS_GRANTED;
        }
        return PermissionConstants.PERMISSION_STATUS_DENIED;
    }

}

