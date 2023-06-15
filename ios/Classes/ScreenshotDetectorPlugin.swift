import Flutter
import UIKit

public class ScreenshotDetectorPlugin: NSObject, FlutterPlugin {
    static var channel: FlutterMethodChannel?
    
    static var observer: NSObjectProtocol?;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "screenshot_detector", binaryMessenger: registrar.messenger())
        let instance = ScreenshotDetectorPlugin()
        if let channel = channel {
            registrar.addMethodCallDelegate(instance, channel: channel)
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "initialize"){
            if(ScreenshotDetectorPlugin.observer != nil) {
                NotificationCenter.default.removeObserver(ScreenshotDetectorPlugin.observer!);
                ScreenshotDetectorPlugin.observer = nil;
            }
            ScreenshotDetectorPlugin.observer = NotificationCenter.default.addObserver(
                forName: UIApplication.userDidTakeScreenshotNotification,
                object: nil,
                queue: .main) { notification in
                    if let channel = ScreenshotDetectorPlugin.channel {
                        channel.invokeMethod("screenCaptured", arguments: nil)
                    }
                    
                    result("screenshot detected")
                }
            result("initialize")
        }else if(call.method == "dispose"){
            if(ScreenshotDetectorPlugin.observer != nil) {
                NotificationCenter.default.removeObserver(ScreenshotDetectorPlugin.observer!);
                ScreenshotDetectorPlugin.observer = nil;
            }
            result("dispose")
        }else{
            result("")
        }
    }
    
    deinit {
        if(ScreenshotDetectorPlugin.observer != nil) {
            NotificationCenter.default.removeObserver(ScreenshotDetectorPlugin.observer!);
            ScreenshotDetectorPlugin.observer = nil;
        }
    }
}
