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

    var body: some View {
        Text("Nothing")
        RouterView { router in
            UserAdmn_loginOptionsView(router: router)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
