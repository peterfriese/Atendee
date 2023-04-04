//
////  OnBoardingView.swift
////  GymTendy
////
////  Created by Muhammad Farid Ullah on 22/02/2023.
//
//
//import SwiftUI
//import UIOnboarding
//import UIKit
////
////struct ContentView: View {
////    @AppStorage("isLoginView") private var showingOnboarding = true
////    
////    var body: some View {
////        Login_View()
////            .fullScreenCover(isPresented: $showingOnboarding, content: {
////                if !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
////                    OnboardingView()
////                        .edgesIgnoringSafeArea(.all)
////                }
////                
////            })
////    }
////}
//
//
//struct OnboardingView: UIViewControllerRepresentable {
//    typealias UIViewControllerType = UIOnboardingViewController
//
//    class Coordinator: NSObject, UIOnboardingViewControllerDelegate {
//        func didFinishOnboarding(onboardingViewController: UIOnboardingViewController) {
//            //onboardingViewController.dismiss(animated: true, completion: nil)
//            onboardingViewController.modalTransitionStyle = .crossDissolve
//                onboardingViewController.dismiss(animated: true) {
//                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
//                }
//        }
//    }
//    
//    
//    func makeUIViewController(context: Context) -> UIOnboardingViewController {
//        let onboardingController: UIOnboardingViewController = .init(withConfiguration: .setUp())
//        onboardingController.delegate = context.coordinator
//        return onboardingController
//    }
//    
//    func updateUIViewController(_ uiViewController: UIOnboardingViewController, context: Context) {}
//    
//    func makeCoordinator() -> Coordinator {
//        return .init()
//    }
//}
//
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else {
//            return
//        }
//        window = .init(windowScene: windowScene)
//        window?.rootViewController = UIHostingController(rootView: ContentView())
//        window?.overrideUserInterfaceStyle = .dark
//        window?.makeKeyAndVisible()
//    }
//
//    func sceneDidDisconnect(_ scene: UIScene) {}
//
//    func sceneDidBecomeActive(_ scene: UIScene) {}
//
//    func sceneWillResignActive(_ scene: UIScene) {}
//
//    func sceneWillEnterForeground(_ scene: UIScene) {}
//
//    func sceneDidEnterBackground(_ scene: UIScene) {}
//}
//
//struct UIOnboardingHelper {
//    static func setUpIcon() -> UIImage {
//        return Bundle.main.appIcon ?? .init(named: "onboarding-icon")!
//    }
//    
//    // First Title Line
//    // Welcome Text
//    static func setUpFirstTitleLine() -> NSMutableAttributedString {
//        .init(string: "Welcome to", attributes: [.foregroundColor: UIColor.label])
//    }
//    
//    // Second Title Line
//    // App Name
//    static func setUpSecondTitleLine() -> NSMutableAttributedString {
//        .init(string: Bundle.main.displayName ?? "GymTen", attributes: [
//            .foregroundColor: UIColor.init(named: "camou") ?? UIColor.init(red: 0.654, green: 0.618, blue: 0.494, alpha: 1.0)
//        ])
//    }
//
//    static func setUpFeatures() -> Array<UIOnboardingFeature> {
//        return .init([
//            .init(icon: .init(named: "feature-1")!,
//                  title: "Instant Searching",
//                  description: "Search user instantly to perform what ever you want to perform CRUD operations"),
//            .init(icon: .init(named: "feature-2")!,
//                  title: "Best Data Security",
//                  description: "Your data is secured, it is being stored on both your local storage and cloud storage."),
//            .init(icon: .init(named: "feature-3")!,
//                  title: "Online Payment",
//                  description: "Support online payment for your gym users, so that they could pay you online."),
//            .init(icon: .init(named: "feature-3")!,
//                  title: "Online Payment",
//                  description: "Support online payment for your gym users, so that they could pay you online.")
//        ])
//    }
//    
//    static func setUpNotice() -> UIOnboardingTextViewConfiguration {
//        return .init(icon: .init(named: "onboarding-notice-icon"),
//                     text: "Developed and designed for both gym incharges and gym users.",
//                     linkTitle: "Learn more...",
//                     link: "https://www.lukmanascic.ch/portfolio/insignia",
//                     tint: .init(named: "camou") ?? .init(red: 0.654, green: 0.618, blue: 0.494, alpha: 1.0))
//    }
//    
//    static func setUpButton() -> UIOnboardingButtonConfiguration {
//        return .init(title: "Continue",
//                     backgroundColor: .init(named: "camou") ?? .init(red: 0.654, green: 0.618, blue: 0.494, alpha: 1-0))
//    }
//}
//
//extension UIOnboardingViewConfiguration {
//    static func setUp() -> UIOnboardingViewConfiguration {
//        return .init(appIcon: UIOnboardingHelper.setUpIcon(),
//                     firstTitleLine: UIOnboardingHelper.setUpFirstTitleLine(),
//                     secondTitleLine: UIOnboardingHelper.setUpSecondTitleLine(),
//                     features: UIOnboardingHelper.setUpFeatures(),
//                     textViewConfiguration: UIOnboardingHelper.setUpNotice(),
//                     buttonConfiguration: UIOnboardingHelper.setUpButton())
//    }
//}
