import UIKit
import Flutter
import Firebase
import GoogleMaps


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  FirebaseApp.configure()
  GMSServices.provideAPIKey("AIzaSyD43HBRXRnHv48n73sVs3qodxBwIFyOQsI")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
