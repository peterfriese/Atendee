//
//  SceneDelegate.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.
//

import Foundation
import SwiftUI
import Firebase
import GoogleSignIn


//✅
//MARK: only un comment.
final class SceneDelegate {
    static var rootViewController: UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }

        return root
    }
}
/*
 This is a Swift code snippet defining a static class method rootViewController of the Application_utility class. The method returns the root view controller of the main window in the application.

 The method starts by accessing the connectedScenes property of the shared UIApplication instance, which represents the app's active scenes. It assumes that the first connected scene is the UIWindowScene instance that contains the app's main window. If there is no UIWindowScene, it returns a new, empty UIViewController.

 Next, the method accesses the rootViewController property of the window's main view controller, which is the root view controller of the app. If there is no root view controller, it returns a new, empty UIViewController.

 Overall, this code is useful for obtaining the root view controller of the app, which can be useful for various purposes, such as presenting new view controllers, accessing navigation controllers or tab bar controllers, or obtaining information about the app's state.



 */




//2nd way.

//class Scene_Delegate: UIResponder, UIWindowSceneDelegate {
//
//  var window: UIWindow?
//
//  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
//    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
//    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//
//    // Create the SwiftUI view that provides the window contents.
//    let contentView = ContentView()
//
//    // Use a UIHostingController as window root view controller.
//    if let windowScene = scene as? UIWindowScene {
//      let window = UIWindow(windowScene: windowScene)
//      window.rootViewController = UIHostingController(rootView: contentView)
//      self.window = window
//      window.makeKeyAndVisible()
//    }
//  }
//
//  func sceneDidDisconnect(_ scene: UIScene) {
//    // Called as the scene is being released by the system.
//    // This occurs shortly after the scene enters the background, or when its session is discarded.
//    // Release any resources associated with this scene that can be re-created the next time the scene connects.
//    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
//  }
//
//  func sceneDidBecomeActive(_ scene: UIScene) {
//    // Called when the scene has moved from an inactive state to an active state.
//    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
//  }
//
//  func sceneWillResignActive(_ scene: UIScene) {
//    // Called when the scene will move from an active state to an inactive state.
//    // This may occur due to temporary interruptions (ex. an incoming phone call).
//  }
//
//  func sceneWillEnterForeground(_ scene: UIScene) {
//    // Called as the scene transitions from the background to the foreground.
//    // Use this method to undo the changes made on entering the background.
//  }
//
//  func sceneDidEnterBackground(_ scene: UIScene) {
//    // Called as the scene transitions from the foreground to the background.
//    // Use this method to save data, release shared resources, and store enough scene-specific state information
//    // to restore the scene back to its current state.
//  }
//
//}


