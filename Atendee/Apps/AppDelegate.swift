////
////  AppDelegate.swift
////  Atendee
////
////  Created by Muhammad Farid Ullah on 03/04/2023.
//
//import Foundation
//import SwiftUI
//import Firebase
//import GoogleSignIn
//
////✅
////MARK: Only un comment.
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//
//        // Check if the app has launched before
//          let defaults = UserDefaults.standard
//          let hasLaunchedBefore = defaults.bool(forKey: "hasLaunchedBefore")
//
//          if !hasLaunchedBefore {
//              // If the app is launching for the first time or has been reinstalled,
//              // set the currentUser property to a default value
////              let userVM = User_VM()
////              userVM.currentUser_email = "UnknownUserAppstorage"
//
//              // Set the hasLaunchedBefore flag to true so that this code block
//              // does not run again on subsequent app launches
//              defaults.set(true, forKey: "hasLaunchedBefore")
//          }
//
//        return true
//    }
//
//
//    //The method should call the handleURL method of the GIDSignIn instance, which will properly handle the URL that your application receives at the end of the authentication process.
//    @available(iOS 9.0, *)
//    //it ask the delegate to open the resource specified by the url.
//    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }
//}
//
//
//
//
////2nd way to configure.
////@UIApplicationMain
////class AppDelegate2: UIResponder, UIApplicationDelegate {
////
////  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
////    // Override point for customization after application launch.
////
////    FirebaseApp.configure()
////    return true
////  }
////
////  // MARK: UISceneSession Lifecycle
////
////  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
////    // Called when a new scene session is being created.
////    // Use this method to select a configuration to create the new scene with.
////    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
////  }
////
////  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
////    // Called when the user discards a scene session.
////    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
////    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
////  }
////
////}
