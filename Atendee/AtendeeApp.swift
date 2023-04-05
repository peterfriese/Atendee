//
//  AtendeeApp.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.
//

import SwiftUI
import SwiftUI
import FirebaseCore

@main
struct AtendeeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var userAdmin_vm = Authentication_AdminUser_VM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userAdmin_vm)
        }
    }
}
