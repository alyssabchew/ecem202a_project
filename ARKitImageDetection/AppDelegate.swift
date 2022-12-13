/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Application's delegate.
 
 Adopted from Apple Documentation Example on ARKit
 
 Additional code adapted from Google's OAuth Documentation for Swift
*/

import UIKit
import ARKit

import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
    //        GIDSignIn.sharedInstance.clientID = "650303852572-8uenbk721vei175rb2p6utcbiahvlemr.apps.googleusercontent.com"
    let signInConfig = GIDConfiguration(clientID: "650303852572-8uenbk721vei175rb2p6utcbiahvlemr.apps.googleusercontent.com")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
          if error != nil || user == nil {
            // Show the app's signed-out state.
          } else {
            // Show the app's signed-in state.
              print("previous sign in restored!")
          }
        }

        return true
    }
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }
    
//    func application(
//      _ application: UIApplication,
//      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//    ) -> Bool {
//      GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
//        if error != nil || user == nil {
//          // Show the app's signed-out state.
//        } else {
//          // Show the app's signed-in state.
//        }
//      }
//      return true
//    }
    
//    // MARK: UISceneSession Lifecycle
//        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//            // Called when a new scene session is being created.
//            // Use this method to select a configuration to create the new scene with.
//            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//        }
//
//        func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//            // Called when the user discards a scene session.
//            // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//            // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//        }
}
