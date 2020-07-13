import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class Rootaccess {
  static const MethodChannel _channel =
      const MethodChannel('rootaccess');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }


  /// Triggers app to get root access
  ///
  /// If device is not rooted then this will return `false`.
  /// Else it will open installed superuser or similar app's pop up asking for Permission.
  static Future<bool> get rootAccess async {
    final bool access = await _channel.invokeMethod('isAccessGiven');
    return access;
  }

  static Future<bool> get isModifiedAndEmulated async {
    final bool isRealDevice = await _channel.invokeMethod('isRealDevice');
    if (Platform.isAndroid) {
      final bool isRootAccess = await _channel.invokeMethod('isAccessGiven');
      return isRootAccess || !isRealDevice;
    }
    else{
      final bool isJailBroken = await _channel.invokeMethod('isJailBroken');
      return isJailBroken || !isRealDevice;
    }
  }

  static Future<bool> get isModified async {
    if (Platform.isAndroid) {
      final bool isRootAccess = await _channel.invokeMethod('isAccessGiven');
      return isRootAccess;
    }
    else{
      final bool isJailBroken = await _channel.invokeMethod('isJailBroken');
      return isJailBroken;
    }
  }

  static Future<bool> get isRealDevice async {
    final bool isRealDevice = await _channel.invokeMethod('isRealDevice');
    return isRealDevice;
  }

  static Future<bool> get isJailBroken async {
    final bool isJailBroken = await _channel.invokeMethod('isJailBroken');
    return isJailBroken;
  }

}
