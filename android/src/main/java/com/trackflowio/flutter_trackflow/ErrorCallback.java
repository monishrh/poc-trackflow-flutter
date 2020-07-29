package com.trackflowio.flutter_trackflow;

@FunctionalInterface
interface ErrorCallback {
    void onError(String errorCode, String errorDescription);
}
