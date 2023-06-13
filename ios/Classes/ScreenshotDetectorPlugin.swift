import Flutter
import UIKit

public class ScreenshotDetectorPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "screenshot_detector", binaryMessenger: registrar.messenger())
    let instance = ScreenshotDetectorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "initialize"){
           if(SwiftScreenshotCallbackPlugin.observer != nil) {
               NotificationCenter.default.removeObserver(SwiftScreenshotCallbackPlugin.observer!);
               SwiftScreenshotCallbackPlugin.observer = nil;
           }
           SwiftScreenshotCallbackPlugin.observer = NotificationCenter.default.addObserver(
             forName: UIApplication.userDidTakeScreenshotNotification,
             object: nil,
             queue: .main) { notification in
             if let channel = SwiftScreenshotCallbackPlugin.channel {
               channel.invokeMethod("screenCaptured", arguments: nil)
             }

             result("screen shot called")
         }
         result("initialize")
       }else if(call.method == "dispose"){
           if(SwiftScreenshotCallbackPlugin.observer != nil) {
               NotificationCenter.default.removeObserver(SwiftScreenshotCallbackPlugin.observer!);
               SwiftScreenshotCallbackPlugin.observer = nil;
           }
           result("dispose")
       }else{
         result("")
       }
  }

   deinit {
        if(SwiftScreenshotCallbackPlugin.observer != nil) {
            NotificationCenter.default.removeObserver(SwiftScreenshotCallbackPlugin.observer!);
            SwiftScreenshotCallbackPlugin.observer = nil;
        }
    }
}