import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


// import UIKit
// import Flutter
// import FirebaseCore
// import FirebaseMessaging
//
// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     // Initialize Firebase
//     FirebaseApp.configure()
//
//     // Request notification permissions
//     if #available(iOS 10.0, *) {
//       UNUserNotificationCenter.current().delegate = self
//       let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//       UNUserNotificationCenter.current().requestAuthorization(
//         options: authOptions,
//         completionHandler: { granted, error in
//           print("Notification permission granted: \(granted)")
//         }
//       )
//     }
//
//     application.registerForRemoteNotifications()
//
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
//
//   // Handle FCM token
//   override func application(_ application: UIApplication,
//                             didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//     Messaging.messaging().apnsToken = deviceToken
//   }
// }