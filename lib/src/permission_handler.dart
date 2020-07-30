import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'permission_enums.dart';
import 'codec.dart';
class Item {
  PermissionGroup group;
  PermissionStatus status;

  Item(this.group, this.status);
}
/// Provides a cross-platform (iOS, Android) API to request and check permissions.
class PermissionHandler   {
  factory PermissionHandler() {
    if (_instance == null) {
      const MethodChannel methodChannel =
          MethodChannel('flutter_trackflow');

      _instance = PermissionHandler.private(methodChannel);
    }
    return _instance;
  }
 List<Item> list = List<Item>();
  

  @visibleForTesting
  PermissionHandler.private(this._methodChannel);

  static PermissionHandler _instance;

  final MethodChannel _methodChannel;
  
  /// Check current permission status.
  ///
  /// Returns a [Future] containing the current permission status for the supplied [PermissionGroup].
  Future<PermissionStatus> checkPermissionStatus(
      PermissionGroup permission) async {

    final int status = await _methodChannel.invokeMethod(
        'checkPermissionStatus', permission.value);

    return Codec.decodePermissionStatus(status);
  }
 
List<Item> initList() {
  
    for (var i = 0; i < PermissionGroup.values.length; i++) {
     Future<PermissionStatus> status = PermissionHandler().checkPermissionStatus(PermissionGroup.values[i]);
      status.then((PermissionStatus status) {
               if(status==PermissionStatus.granted){
              list.add(Item(PermissionGroup.values[i], PermissionStatus.granted));
              print("granted");
                 }
                 else if(status==PermissionStatus.denied){
                   list.add(Item(PermissionGroup.values[i], PermissionStatus.denied)); 
                     print("granted");
                 }
                 else{
                     print("notapplicable");
                 }
               
              });
               continue;
            }
           print(list.length);
            return list;
}

        
          /// Request to see if you should show a rationale for requesting permission.
          ///
          /// This method is only implemented on Android, calling this on iOS always
          /// returns [false].
          Future<bool> shouldShowRequestPermissionRationale(
              PermissionGroup permission) async {
            if (!Platform.isAndroid) {
              return false;
            }
        
            final bool shouldShowRationale = await _methodChannel.invokeMethod(
                'shouldShowRequestPermissionRationale', permission.value);
        
            return shouldShowRationale;
          }
      
}
