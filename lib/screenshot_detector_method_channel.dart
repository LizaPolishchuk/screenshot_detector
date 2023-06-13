import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screenshot_detector_platform_interface.dart';

class MethodChannelScreenshotDetector extends ScreenshotDetectorPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('screenshot_detector');
  VoidCallback? _onScreenCaptured;

  @override
  Future init() async {
    methodChannel.setMethodCallHandler(onMethodCall);
    await methodChannel.invokeMethod('initialize');
  }

  @override
  Future dispose() async {
    methodChannel.setMethodCallHandler(null);
    await methodChannel.invokeMethod('dispose');
  }

  @override
  setOnScreenCapturedListener(VoidCallback onScreenCaptured) {
    _onScreenCaptured = onScreenCaptured;
  }

  @override
  Future onMethodCall(MethodCall call) async {
    switch (call.method) {
      case "screenCaptured":
        _onScreenCaptured?.call();
        break;
    }
  }
}
