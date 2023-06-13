import 'package:flutter/services.dart';

import 'screenshot_detector_platform_interface.dart';

class ScreenshotDetector {
  ScreenshotDetector() {
    ScreenshotDetectorPlatform.instance.init();
  }

  void setOnScreenCapturedListener(VoidCallback onScreenCaptured) {
    ScreenshotDetectorPlatform.instance.setOnScreenCapturedListener(onScreenCaptured);
  }

  void dispose() {
    ScreenshotDetectorPlatform.instance.dispose;
  }
}
