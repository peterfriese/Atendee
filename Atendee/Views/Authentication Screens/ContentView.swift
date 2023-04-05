//
//  ContentView.swift
//  Atendee
//
//  Created by Muhammad Farid Ullah on 03/04/2023.


//done
import SwiftUI
//import UIOnboarding
import UIKit
import SwiftfulRouting

struct ContentView: View {
    //@AppStorage("isLoginView") private var showingOnboarding = true
    @EnvironmentObject var userAdmin_vm: Authentication_AdminUser_VM
    
    var body: some View {
        //Text("Nothing")
        VStack {
            if userAdmin_vm.signedIn {
                MainView()
            } else {
                RouterView { router in
                    UserAdmn_loginOptionsView(router: router)
                }
            }
        }
        .onAppear {
            userAdmin_vm.signedIn = userAdmin_vm.isUserSignedIn
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
